# Instalar el fix de Copilot -> RCtrl en el inicio de Windows
$scriptPath = Join-Path $PSScriptRoot "copilot_a_ctrl.ahk"
$startupFolder = [Environment]::GetFolderPath("Startup")
$shortcutPath = Join-Path $startupFolder "CopilotToCtrl.lnk"

if (-not (Test-Path $scriptPath)) {
    Write-Host "ERROR: No se encontro copilot_a_ctrl.ahk en $PSScriptRoot" -ForegroundColor Red
    exit 1
}

# Verificar que AutoHotkey v2 esta instalado
$ahkPath = $null
$possiblePaths = @(
    "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe",
    "C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe",
    "C:\Program Files\AutoHotkey\AutoHotkey64.exe",
    "C:\Program Files\AutoHotkey\AutoHotkey.exe"
)
foreach ($p in $possiblePaths) {
    if (Test-Path $p) { $ahkPath = $p; break }
}

if (-not $ahkPath) {
    Write-Host ""
    Write-Host "AutoHotkey v2 no esta instalado." -ForegroundColor Red
    Write-Host "Descargalo de: https://www.autohotkey.com/" -ForegroundColor Yellow
    Write-Host "Instala la version v2, luego volve a ejecutar este script." -ForegroundColor Yellow
    exit 1
}

Write-Host "AutoHotkey encontrado en: $ahkPath" -ForegroundColor Green

# Crear acceso directo en Startup
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $ahkPath
$shortcut.Arguments = "`"$scriptPath`""
$shortcut.WorkingDirectory = $PSScriptRoot
$shortcut.Description = "Fix ASUS Copilot Key -> RCtrl"
$shortcut.Save()

Write-Host ""
Write-Host "OK: Acceso directo creado en Startup:" -ForegroundColor Green
Write-Host "  $shortcutPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "El fix se ejecutara automaticamente cada vez que inicies Windows." -ForegroundColor Green
Write-Host ""

# Ejecutar ahora
Write-Host "Ejecutando el fix ahora..." -ForegroundColor Yellow
Start-Process -FilePath $ahkPath -ArgumentList "`"$scriptPath`""
Write-Host "Listo! La tecla Copilot ahora deberia funcionar como RCtrl." -ForegroundColor Green
