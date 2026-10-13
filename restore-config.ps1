# Restore GenieACS Configuration
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Restoring GenieACS Multi-Vendor Config" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Determine DB directory
$dbPath = $null
if (Test-Path "db") {
    $dbPath = "db"
} elseif (Test-Path "multitab/db") {
    $dbPath = "multitab/db"
} else {
    Write-Host "ERROR - Database folder 'db' not found!" -ForegroundColor Red
    Write-Host "Ensure the 'db' folder is present in the current directory." -ForegroundColor Yellow
    exit 1
}
Write-Host "Using database source: $dbPath" -ForegroundColor Gray

# Check if MongoDB container is running
Write-Host "[1/3] Checking MongoDB container..." -ForegroundColor Yellow
$mongoRunning = docker inspect -f '{{.State.Running}}' genieacs-mongodb 2>$null
if ($mongoRunning -ne "true") {
    Write-Host "ERROR - 'genieacs-mongodb' container is not running!" -ForegroundColor Red
    Write-Host "Please start the containers first with: docker compose up -d" -ForegroundColor Yellow
    exit 1
}
Write-Host "OK - MongoDB container is running" -ForegroundColor Green

# Copy db files to container
Write-Host "[2/3] Copying configuration files to MongoDB container..." -ForegroundColor Yellow
docker cp "${dbPath}/." genieacs-mongodb:/tmp/genieacs-db
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Configuration files copied" -ForegroundColor Green
} else {
    Write-Host "ERROR - Failed to copy configuration files" -ForegroundColor Red
    exit 1
}

# Restore database
Write-Host "[3/3] Restoring database collections (mongorestore)..." -ForegroundColor Yellow
docker exec genieacs-mongodb mongorestore --db genieacs --drop /tmp/genieacs-db
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - Database restored successfully" -ForegroundColor Green
} else {
    Write-Host "ERROR - Failed to restore database" -ForegroundColor Red
    exit 1
}

# Restart GenieACS services to reload config
Write-Host ""
Write-Host "Restarting GenieACS services to reload configuration..." -ForegroundColor Yellow
docker restart genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui
Write-Host "OK - Services restarted" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuration Restored Successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Multi-vendor support & Multi-Tab UI are now active:" -ForegroundColor White
Write-Host "  - Huawei" -ForegroundColor Cyan
Write-Host "  - FiberHome" -ForegroundColor Cyan
Write-Host "  - ZTE" -ForegroundColor Cyan
Write-Host "  - CData" -ForegroundColor Cyan
Write-Host "  - GGCLink" -ForegroundColor Cyan
Write-Host "  - VSOL" -ForegroundColor Cyan
Write-Host "  - MikroTik" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access GenieACS:" -ForegroundColor White
Write-Host "  Dashboard:  http://localhost" -ForegroundColor Green
Write-Host "  GenieACS UI: http://localhost:3000 (admin / admin)" -ForegroundColor Green
Write-Host ""
