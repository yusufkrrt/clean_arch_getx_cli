# install.ps1
# Adds getx_cli.exe to the user PATH on Windows

$ErrorActionPreference = "Stop"

$cliExe = Join-Path $PSScriptRoot "bin\getx_cli.exe"

if (-not (Test-Path $cliExe)) {
    Write-Host "❌ getx_cli.exe not found. Compiling..." -ForegroundColor Red
    dart compile exe "$PSScriptRoot\bin\getx_cli.dart" -o $cliExe
}

$installDir = "$env:USERPROFILE\.getx_cli\bin"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Copy-Item $cliExe "$installDir\getx_cli.exe" -Force

# Add to user PATH if not already there
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
    [System.Environment]::SetEnvironmentVariable(
        "Path",
        "$userPath;$installDir",
        "User"
    )
    Write-Host "✅ Added $installDir to PATH." -ForegroundColor Green
    Write-Host "   Restart your terminal for changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host "✅ Already in PATH." -ForegroundColor Green
}

Write-Host ""
Write-Host "🚀 getx_cli installed successfully!" -ForegroundColor Cyan
Write-Host "   Usage: getx_cli create my_app" -ForegroundColor White
Write-Host "          getx_cli module home" -ForegroundColor White
