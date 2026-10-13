# GenieACS Installer for Windows
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GenieACS Windows Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
Write-Host "[0/4] Checking administrator privileges..." -ForegroundColor Yellow
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR - This script requires administrator privileges!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please restart PowerShell as Administrator and try again:" -ForegroundColor Yellow
    Write-Host "1. Right-click on PowerShell" -ForegroundColor White
    Write-Host "2. Select 'Run as administrator'" -ForegroundColor White
    Write-Host "3. Navigate to this directory and run: .\install.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}
Write-Host "OK - Running as administrator" -ForegroundColor Green
Write-Host ""

# Check if Docker is installed
Write-Host "[1/4] Checking Docker installation..." -ForegroundColor Yellow
$dockerInstalled = $false
try {
    $null = docker --version
    $dockerInstalled = $true
    Write-Host "OK - Docker is installed" -ForegroundColor Green
} catch {
    Write-Host "Docker is not installed. Attempting to install automatically via winget..." -ForegroundColor Yellow
    try {
        $null = winget --version
        Write-Host "OK - winget is available, installing Docker Desktop..." -ForegroundColor Green
        winget install --id Docker.DockerDesktop -e --accept-package-agreements --accept-source-agreements
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "Docker Desktop installed successfully!" -ForegroundColor Green
            Write-Host "Please start Docker Desktop from the Start Menu, wait for it to run, then re-run .\install.ps1" -ForegroundColor Yellow
            exit 0
        } else {
            Write-Host "ERROR - Docker Desktop installation failed." -ForegroundColor Red
            Write-Host "Please download and install Docker Desktop manually from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
            exit 1
        }
    } catch {
        Write-Host "ERROR - winget is not available." -ForegroundColor Red
        Write-Host "Please download and install Docker Desktop manually: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
        exit 1
    }
}

# Verify Docker Daemon is running
Write-Host "Verifying Docker daemon status..." -ForegroundColor Gray
$dockerReady = $false
try {
    $null = docker info 2>$null
    if ($LASTEXITCODE -eq 0) {
        $dockerReady = $true
        Write-Host "OK - Docker Engine is running" -ForegroundColor Green
    }
} catch {}

if (-not $dockerReady) {
    Write-Host "ERROR - Docker is installed but Docker Desktop is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop from the Start Menu and wait until the whale icon is solid, then re-run .\install.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if Docker Compose is available
Write-Host "[2/4] Checking Docker Compose..." -ForegroundColor Yellow
$composeCmd = $null
if (Get-Command docker-compose -ErrorAction SilentlyContinue) {
    $composeCmd = "docker-compose"
    Write-Host "OK - docker-compose (v1) found" -ForegroundColor Green
} else {
    try {
        & docker compose version | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $composeCmd = "docker compose"
            Write-Host "OK - docker compose (v2) found" -ForegroundColor Green
        }
    } catch {}
}

if (-not $composeCmd) {
    Write-Host "ERROR - Docker Compose not found" -ForegroundColor Red
    exit 1
}

# Start containers with pre-built image
Write-Host "[3/4] Pulling pre-built images and starting GenieACS..." -ForegroundColor Yellow
if ($composeCmd -eq "docker-compose") {
    docker-compose pull
    docker-compose up -d
} else {
    docker compose pull
    docker compose up -d
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR - Failed to start containers" -ForegroundColor Red
    exit 1
}
Write-Host "OK - Containers started successfully" -ForegroundColor Green

# Restore Multi-Vendor configuration automatically
Write-Host ""
Write-Host "[4/4] Restoring Multi-Vendor configuration & Virtual Parameters..." -ForegroundColor Yellow
Write-Host "Waiting 15 seconds for MongoDB to initialize..." -ForegroundColor Gray
Start-Sleep -Seconds 15

if (Test-Path ".\restore-config.ps1") {
    & .\restore-config.ps1
} else {
    Write-Host "WARNING - restore-config.ps1 not found. Run restore manually if needed." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation & Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "GenieACS Access URLs:" -ForegroundColor White
Write-Host "  Dashboard (Recommended): http://localhost" -ForegroundColor Cyan
Write-Host "  GenieACS Direct UI:      http://localhost:3000" -ForegroundColor Cyan
Write-Host "  CWMP (TR-069):          http://localhost:7547" -ForegroundColor Cyan
Write-Host "  NBI (REST API):         http://localhost:7557" -ForegroundColor Cyan
Write-Host "  File Server:            http://localhost:7567" -ForegroundColor Cyan
Write-Host ""
Write-Host "Default UI Credentials:" -ForegroundColor White
Write-Host "  Username: admin" -ForegroundColor Yellow
Write-Host "  Password: admin" -ForegroundColor Yellow
Write-Host ""
