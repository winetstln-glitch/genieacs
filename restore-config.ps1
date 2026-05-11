# Restore GenieACS Configuration
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Restoring GenieACS Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if containers are running
Write-Host "[1/3] Checking MongoDB container..." -ForegroundColor Yellow
$mongoRunning = docker inspect -f '{{.State.Running}}' genieacs-mongodb 2>$null
if ($mongoRunning -ne "true") {
    Write-Host "ERROR - MongoDB container is not running. Start containers first with: docker-compose up -d" -ForegroundColor Red
    exit 1
}
Write-Host "OK - MongoDB is running" -ForegroundColor Green

# Copy db files to container
Write-Host "[2/3] Copying configuration files..." -ForegroundColor Yellow
docker cp db/. genieacs-mongodb:/tmp/genieacs-db
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Configuration files copied" -ForegroundColor Green
} else {
    Write-Host "ERROR - Failed to copy configuration files" -ForegroundColor Red
    exit 1
}

# Restore database
Write-Host "[3/3] Restoring database..." -ForegroundColor Yellow
docker exec genieacs-mongodb mongorestore --db genieacs --drop /tmp/genieacs-db
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Database restored successfully" -ForegroundColor Green
} else {
    Write-Host "ERROR - Failed to restore database" -ForegroundColor Red
    exit 1
}

# Restart GenieACS services
Write-Host ""
Write-Host "Restarting GenieACS services..." -ForegroundColor Yellow
docker restart genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui
Write-Host "OK - Services restarted" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration Restored!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Multi-vendor support is now available:" -ForegroundColor White
Write-Host "  - Huawei" -ForegroundColor Cyan
Write-Host "  - FiberHome" -ForegroundColor Cyan
Write-Host "  - ZTE" -ForegroundColor Cyan
Write-Host "  - CData" -ForegroundColor Cyan
Write-Host "  - GGCLink" -ForegroundColor Cyan
Write-Host "  - VSOL" -ForegroundColor Cyan
Write-Host "  - Mikrotik" -ForegroundColor Cyan
Write-Host "  - And many more!" -ForegroundColor Cyan
Write-Host ""
