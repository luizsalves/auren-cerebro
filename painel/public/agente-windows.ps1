# Agente do cérebro para a máquina Windows.
# Fica perguntando ao painel se há deploy pendente e, se houver, faz `git pull`
# (ou roda deploy.ps1 / deploy.cmd, se existir) na pasta local do projeto.
#
# Instalar (PowerShell, usuário normal):
#   .\agente-windows.ps1 -Instalar -Url http://IP:3333 -Token SEU_TOKEN
# Depois edite %USERPROFILE%\.cerebro\agente.json e aponte cada projeto para a pasta local.
# Rodar na mão (para ver o log): .\agente-windows.ps1
# Remover:  .\agente-windows.ps1 -Remover

param(
  [switch]$Instalar,
  [switch]$Remover,
  [string]$Url,
  [string]$Token,
  [int]$Intervalo = 20
)
$ErrorActionPreference = 'Stop'
$Dir = Join-Path $env:USERPROFILE '.cerebro'
$Cfg = Join-Path $Dir 'agente.json'
$Log = Join-Path $Dir 'agente.log'
$Tarefa = 'Cerebro Agente'

function Escrever($t) {
  $l = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $t"
  Write-Host $l
  try { Add-Content -Path $Log -Value $l -Encoding UTF8 } catch {}
}

if ($Remover) {
  Unregister-ScheduledTask -TaskName $Tarefa -Confirm:$false -ErrorAction SilentlyContinue
  Write-Host "Tarefa removida. A configuração continua em $Cfg."
  exit 0
}

if ($Instalar) {
  if (-not $Url -or -not $Token) { Write-Host "Use: -Instalar -Url http://IP:3333 -Token TOKEN"; exit 1 }
  New-Item -ItemType Directory -Force -Path $Dir | Out-Null
  $destino = Join-Path $Dir 'agente-windows.ps1'
  if ($PSCommandPath -ne $destino) { Copy-Item $PSCommandPath $destino -Force }
  $projetos = @{}
  if (Test-Path $Cfg) { try { $antigo = Get-Content $Cfg -Raw | ConvertFrom-Json; $antigo.projetos.PSObject.Properties | ForEach-Object { $projetos[$_.Name] = $_.Value } } catch {} }
  # tenta descobrir pendentes agora para já listar os projetos
  try {
    $r = Invoke-RestMethod -Uri "$($Url.TrimEnd('/'))/api/agente/pendentes?maquina=$([uri]::EscapeDataString($env:COMPUTERNAME))" -Headers @{ Authorization = "Bearer $Token" } -TimeoutSec 10
  } catch { Write-Host "Aviso: não consegui falar com o painel em $Url ($($_.Exception.Message)). Confira URL e token." }
  $cfg = [ordered]@{
    url = $Url.TrimEnd('/'); token = $Token; maquina = $env:COMPUTERNAME; intervalo = $Intervalo
    raizPadrao = (Join-Path $env:USERPROFILE 'projetos')   # se o projeto não estiver em "projetos", procura em raizPadrao\<slug>
    projetos = $projetos                                     # "slug": "C:\caminho\da\pasta"
  }
  $cfg | ConvertTo-Json -Depth 5 | Set-Content -Path $Cfg -Encoding UTF8
  $acao = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$destino`""
  $gatilho = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
  $conf = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -StartWhenAvailable
  Unregister-ScheduledTask -TaskName $Tarefa -Confirm:$false -ErrorAction SilentlyContinue
  Register-ScheduledTask -TaskName $Tarefa -Action $acao -Trigger $gatilho -Settings $conf -Description 'Recebe deploys do painel do cérebro (git pull nos projetos locais)' | Out-Null
  Start-ScheduledTask -TaskName $Tarefa
  Write-Host ""
  Write-Host "Agente instalado e rodando (tarefa '$Tarefa', inicia no logon)."
  Write-Host "Configuração: $Cfg"
  Write-Host "Edite 'projetos' e aponte cada slug para a pasta local, ex.: `"zum-web-studio`": `"C:\\dev\\zum-web-studio`""
  Write-Host "Projetos sem pasta configurada são procurados em $($cfg.raizPadrao)\<slug>."
  exit 0
}

# ---------- laço principal ----------
if (-not (Test-Path $Cfg)) { Write-Host "Sem configuração. Rode com -Instalar primeiro."; exit 1 }
$c = Get-Content $Cfg -Raw | ConvertFrom-Json
$cab = @{ Authorization = "Bearer $($c.token)" }
$base = "$($c.url)/api/agente"
$maq = [uri]::EscapeDataString($(if ($c.maquina) { $c.maquina } else { $env:COMPUTERNAME }))
$intervalo = if ($c.intervalo) { [int]$c.intervalo } else { 20 }
Escrever "agente iniciado → $($c.url)"

function PastaDe($slug) {
  $p = $null
  if ($c.projetos -and $c.projetos.PSObject.Properties[$slug]) { $p = $c.projetos.$slug }
  if (-not $p -and $c.raizPadrao) { $cand = Join-Path $c.raizPadrao $slug; if (Test-Path $cand) { $p = $cand } }
  return $p
}

function Deploy($item) {
  $slug = $item.slug
  $pasta = PastaDe $slug
  $saida = New-Object System.Text.StringBuilder
  [void]$saida.AppendLine("# deploy $slug — $(Get-Date -Format 'dd/MM/yyyy HH:mm') — $env:COMPUTERNAME")
  $ok = $false
  if (-not $pasta) {
    [void]$saida.AppendLine("sem pasta configurada para '$slug' em $Cfg (chave projetos) — pulei")
  } elseif (-not (Test-Path $pasta)) {
    [void]$saida.AppendLine("pasta não existe: $pasta")
  } else {
    try {
      Push-Location $pasta
      if (Test-Path (Join-Path $pasta 'deploy.ps1')) {
        [void]$saida.AppendLine("▸ deploy.ps1"); $o = & powershell -NoProfile -ExecutionPolicy Bypass -File .\deploy.ps1 2>&1 | Out-String; [void]$saida.Append($o); $ok = ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE)
      } elseif (Test-Path (Join-Path $pasta 'deploy.cmd')) {
        [void]$saida.AppendLine("▸ deploy.cmd"); $o = & cmd /c deploy.cmd 2>&1 | Out-String; [void]$saida.Append($o); $ok = ($LASTEXITCODE -eq 0)
      } elseif (Test-Path (Join-Path $pasta '.git')) {
        [void]$saida.AppendLine("▸ git pull --ff-only ($pasta)"); $o = & git pull --ff-only 2>&1 | Out-String; [void]$saida.Append($o); $ok = ($LASTEXITCODE -eq 0)
        if ($ok -and (Test-Path 'package.json') -and (Test-Path 'node_modules')) {
          [void]$saida.AppendLine("▸ npm install"); $o = & npm install --no-audit --no-fund 2>&1 | Out-String; [void]$saida.Append($o)
        }
      } else {
        [void]$saida.AppendLine("pasta sem .git e sem deploy.ps1/deploy.cmd — nada a fazer")
      }
    } catch { [void]$saida.AppendLine("erro: $($_.Exception.Message)") }
    finally { Pop-Location }
  }
  [void]$saida.AppendLine($(if ($ok) { "✓ ok" } else { "✗ falhou" }))
  Escrever "$slug → $(if ($ok) {'ok'} else {'falhou'})"
  $corpo = @{ id = $item.id; slug = $slug; ok = $ok; log = $saida.ToString() } | ConvertTo-Json -Depth 3
  try { Invoke-RestMethod -Method Post -Uri "$base/resultado?maquina=$maq" -Headers $cab -ContentType 'application/json; charset=utf-8' -Body ([System.Text.Encoding]::UTF8.GetBytes($corpo)) -TimeoutSec 15 | Out-Null } catch { Escrever "não consegui devolver o resultado: $($_.Exception.Message)" }
}

while ($true) {
  try {
    $r = Invoke-RestMethod -Uri "$base/pendentes?maquina=$maq" -Headers $cab -TimeoutSec 15
    foreach ($item in @($r.pendentes)) { if ($item) { Deploy $item } }
  } catch { Escrever "painel indisponível: $($_.Exception.Message)" }
  Start-Sleep -Seconds $intervalo
}
