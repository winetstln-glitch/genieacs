# GenieACS Installer for Windows
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GenieACS Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
Write-Host "[0/5] Checking administrator privileges..." -ForegroundColor Yellow
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
Write-Host "[1/5] Checking Docker installation..." -ForegroundColor Yellow
try {
    docker --version | Out-Null
    Write-Host "OK - Docker is installed" -ForegroundColor Green
} catch {
    Write-Host "Docker is not installed. Attempting to install automatically..." -ForegroundColor Yellow
    
    # Check if winget is available
    try {
        winget --version | Out-Null
        Write-Host "OK - winget is available" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "Installing Docker Desktop..." -ForegroundColor Yellow
        Write-Host "This may take several minutes. Please wait..." -ForegroundColor Cyan
        Write-Host "Note: You may see a UAC prompt - please click Yes" -ForegroundColor Yellow
        Write-Host ""
        
        winget install --id Docker.DockerDesktop -e --accept-package-agreements --accept-source-agreements
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Cyan
            Write-Host "  Docker Desktop Installed!" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "IMPORTANT: Please follow these steps:" -ForegroundColor Yellow
            Write-Host "1. Start Docker Desktop from Start Menu" -ForegroundColor White
            Write-Host "2. Complete the Docker Desktop setup wizard" -ForegroundColor White
            Write-Host "3. Wait for Docker Engine to be ready (whale icon in system tray)" -ForegroundColor White
            Write-Host "4. Restart this script: .\install.ps1" -ForegroundColor White
            Write-Host ""
            exit 0
        } else {
            Write-Host ""
            Write-Host "ERROR - Docker Desktop installation failed (exit code: $LASTEXITCODE)" -ForegroundColor Red
            Write-Host ""
            Write-Host "Please install Docker Desktop manually:" -ForegroundColor Yellow
            Write-Host "1. Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor Cyan
            Write-Host "2. Run the installer as Administrator" -ForegroundColor White
            Write-Host "3. Complete the installation" -ForegroundColor White
            Write-Host "4. Restart this script" -ForegroundColor White
            Write-Host ""
            exit 1
        }
    } catch {
        Write-Host "ERROR - winget is not available or failed to install Docker" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please install Docker Desktop manually:" -ForegroundColor Yellow
        Write-Host "Download: https://www.docker.com/products/docker-desktop" -ForegroundColor Cyan
        Write-Host ""
        exit 1
    }
}

# Check if Docker Compose is available
Write-Host "[2/5] Checking Docker Compose..." -ForegroundColor Yellow
try {
    docker-compose --version | Out-Null
    Write-Host "OK - Docker Compose is available" -ForegroundColor Green
} catch {
    Write-Host "ERROR - Docker Compose not found" -ForegroundColor Red
    exit 1
}

# Start containers
Write-Host "[3/5] Starting GenieACS containers..." -ForegroundColor Yellow
docker-compose up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Containers started successfully" -ForegroundColor Green
} else {
    Write-Host "ERROR - Failed to start containers" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[4/5] Containers started successfully" -ForegroundColor Green
Write-Host "[5/5] Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Access GenieACS:" -ForegroundColor White
Write-Host "  Dashboard: http://localhost" -ForegroundColor Cyan
Write-Host "  GenieACS UI: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Default credentials:" -ForegroundColor White
Write-Host "  Username: admin" -ForegroundColor Yellow
Write-Host "  Password: admin" -ForegroundColor Yellow
Write-Host ""
Write-Host "To restore multi-vendor configuration:" -ForegroundColor White
Write-Host "  1. Wait 30 seconds for MongoDB to start" -ForegroundColor Yellow
Write-Host "  2. Run: .\restore-config.ps1" -ForegroundColor Yellow
Write-Host ""
