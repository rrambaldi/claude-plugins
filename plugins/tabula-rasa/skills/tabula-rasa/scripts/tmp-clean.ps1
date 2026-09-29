<#
tmp-clean.ps1 — libera spazio nella cartella temporanea di Windows senza toccare file in uso né
sessioni Claude vive. Pulisce solo %TEMP%, che è dell'utente che lo lancia.

Uso:  powershell -NoProfile -ExecutionPolicy Bypass -File tmp-clean.ps1        simulazione
      powershell -NoProfile -ExecutionPolicy Bypass -File tmp-clean.ps1 -y     applica

  -y         applica davvero
  -s         solo la sessione Claude da cui lo lanci: i file del suo scratchpad
  -d GIORNI  file generici non toccati (scrittura, accesso, creazione) da più di GIORNI  [7]
  -i MINUTI  sessione Claude considerata chiusa se inattiva da più di MINUTI            [120]

Come tmp-clean.sh, senza -t. Windows non dice quali file sono aperti: lo script prova a
cancellarli e salta quelli che Windows blocca. Node e Git Bash però non li bloccano, quindi le
sessioni Claude vive si riconoscono da ~/.claude/sessions/, e -s non tocca tasks\. Non entra
mai in link e junction, e non usa Remove-Item -Recurse, che in PowerShell 5.1 le segue.
#>
param(
  [Alias('y')] [switch]$Apply,
  [Alias('s')] [switch]$Session,
  [Alias('d')] [ValidateRange(0, 36500)] [int]$Days = 7,
  [Alias('i')] [ValidateRange(0, 5256000)] [int]$IdleMinutes = 120
)
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

$tmp = [IO.Path]::GetTempPath().TrimEnd('\', '/')
$base = if ($env:CLAUDE_CODE_TMPDIR) { $env:CLAUDE_CODE_TMPDIR } else { $tmp }
$cl = Join-Path $base 'claude-0'    # su Windows process.getuid non c'è: Claude Code usa 0
$cfg = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
$now = Get-Date
$total = [long]0
$link = [IO.FileAttributes]::ReparsePoint

function Human([long]$b) {
  if ($b -ge 1GB) { '{0:N1}G' -f ($b / 1GB) } elseif ($b -ge 1MB) { '{0:N1}M' -f ($b / 1MB) }
  elseif ($b -ge 1KB) { '{0:N1}K' -f ($b / 1KB) } else { "$b" }
}
function Show($action, $bytes, $path, $why) { '{0,-6} {1,7}  {2}  [{3}]' -f $action, (Human $bytes), $path, $why }
function Get-Size($files) { [long]($files | Measure-Object Length -Sum).Sum }

# Tutti i file sotto $dir, senza entrare in link e junction.
function Get-Files($dir) {
  foreach ($i in Get-ChildItem -LiteralPath $dir -Force -ErrorAction SilentlyContinue) {
    if ($i.Attributes -band $link) { continue }
    if ($i.PSIsContainer) { Get-Files $i.FullName } else { $i }
  }
}

# Cancella i file e dice quanti byte ha liberato: quelli in uso Windows non li lascia togliere.
function Remove-Files($files) {
  $freed = [long]0
  foreach ($f in $files) {
    Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue
    if (-not (Test-Path -LiteralPath $f.FullName)) { $freed += $f.Length }
  }
  $freed
}

# Toglie le cartelle rimaste vuote sotto $dir, lasciando $dir. Directory.Delete senza recursive
# fallisce se la cartella non è vuota, invece di chiedere conferma come Remove-Item.
function Remove-EmptyDirs($dir) {
  foreach ($d in Get-ChildItem -LiteralPath $dir -Directory -Force -ErrorAction SilentlyContinue) {
    if ($d.Attributes -band $link) { continue }
    Remove-EmptyDirs $d.FullName
    try { [IO.Directory]::Delete($d.FullName) } catch {}
  }
}

# Mostra i 30 file più grandi e il totale; con -y li cancella tutti.
function Invoke-List($files, $why) {
  $files = @($files | Sort-Object Length -Descending)
  $sum = Get-Size $files
  $files | Select-Object -First 30 | ForEach-Object { Show CANC $_.Length $_.FullName $why }
  if ($files.Count -gt 30) { "... e altri $($files.Count - 30) file" }
  "Totale: $($files.Count) file, $(Human $sum)"
  if ($Apply) {
    $sum = Remove-Files $files
    "Cancellati: $(Human $sum), quelli in uso restano"
  }
  $script:total += $sum
}

function Summary {
  ''
  if ($Apply) { "Liberati circa $(Human $total)." }
  else { "Simulazione: si libererebbero circa $(Human $total). Rilancia con -y per applicare." }
  $drive = (Get-Item -LiteralPath $tmp).PSDrive
  "Liberi su $($drive.Name): $(Human $drive.Free)"
}

# ---------------------------------------------------------------------------
# -s: solo lo scratchpad della sessione da cui lo lanci
# ---------------------------------------------------------------------------
if ($Session) {
  if (-not $env:CLAUDE_CODE_SESSION_ID) { throw '-s va lanciato da Claude Code (manca CLAUDE_CODE_SESSION_ID)' }
  "== Sessione $env:CLAUDE_CODE_SESSION_ID =="
  foreach ($p in Get-ChildItem -LiteralPath $cl -Directory -Force -ErrorAction SilentlyContinue) {
    $sp = [IO.Path]::Combine($p.FullName, $env:CLAUDE_CODE_SESSION_ID, 'scratchpad')
    if (-not (Test-Path -LiteralPath $sp)) { continue }
    Invoke-List (Get-Files $sp) 'sessione corrente'
    if ($Apply) { Remove-EmptyDirs $sp }
  }
  Summary
  exit 0
}

# ---------------------------------------------------------------------------
# 1. Sessioni Claude: claude-0\<progetto>\<sessione>\
# ---------------------------------------------------------------------------
''; '== Sessioni Claude =='
# Ogni claude vivo scrive sessions\<pid>.json con la sessione attuale (dopo /clear l'id cambia).
$live = @()
foreach ($j in Get-ChildItem -LiteralPath (Join-Path $cfg 'sessions') -Filter *.json -ErrorAction SilentlyContinue) {
  try {
    $s = Get-Content -LiteralPath $j.FullName -Raw | ConvertFrom-Json
    if ($s.sessionId -and (Get-Process -Id $s.pid -ErrorAction SilentlyContinue)) { $live += $s.sessionId }
  } catch {}
}
$idleCut = $now.AddMinutes(-$IdleMinutes)
foreach ($p in Get-ChildItem -LiteralPath $cl -Directory -Force -ErrorAction SilentlyContinue) {
  if ($p.Attributes -band $link) { continue }
  foreach ($sd in Get-ChildItem -LiteralPath $p.FullName -Directory -Force -ErrorAction SilentlyContinue) {
    if ($sd.Attributes -band $link) { continue }
    $files = @(Get-Files $sd.FullName)
    $size = Get-Size $files
    $jsonl = Get-Item -LiteralPath ([IO.Path]::Combine($cfg, 'projects', $p.Name, "$($sd.Name).jsonl")) -ErrorAction SilentlyContinue

    if ($live -contains $sd.Name) { Show TIENI $size $sd.FullName 'sessione viva'; continue }
    if ($sd.LastWriteTime -gt $idleCut -or ($files | Where-Object { $_.LastWriteTime -gt $idleCut })) {
      Show TIENI $size $sd.FullName "modificata negli ultimi $IdleMinutes min"; continue
    }
    if ($jsonl -and $jsonl.LastWriteTime -gt $idleCut) {
      Show TIENI $size $sd.FullName "conversazione attiva negli ultimi $IdleMinutes min"; continue
    }

    Show CANC $size $sd.FullName "inattiva da più di $IdleMinutes min"
    if ($Apply) {
      $size = Remove-Files $files
      Remove-EmptyDirs $sd.FullName
      try { [IO.Directory]::Delete($sd.FullName) } catch {}
    }
    $total += $size
  }
}

# ---------------------------------------------------------------------------
# 2. File generici vecchi e non in uso (anche quelli sciolti in claude-0)
# ---------------------------------------------------------------------------
''; "== File non toccati da più di $Days giorni =="
$cut = $now.AddDays(-$Days)
$inSessions = $cl + [IO.Path]::DirectorySeparatorChar
$old = Get-Files $tmp | Where-Object {
  $_.LastWriteTime -lt $cut -and $_.LastAccessTime -lt $cut -and $_.CreationTime -lt $cut -and
  $_.Name -notmatch '\.(lock|lck|pid)$' -and
  -not ($_.FullName.StartsWith($inSessions, [StringComparison]::OrdinalIgnoreCase) -and $_.DirectoryName -ne $cl)
}
Invoke-List $old 'vecchio'

Summary
