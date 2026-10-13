#!/bin/bash

# GenieACS Docker Installer for Linux
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  GenieACS Linux Installation Script    ${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check if Docker is installed
echo -e "${YELLOW}[1/4] Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN} ✔ Docker is installed${NC}"
else
    echo -e "${RED} ✘ Docker is not installed. Please install Docker first.${NC}"
    echo -e "${YELLOW}Visit: https://docs.docker.com/get-docker/${NC}"
    exit 1
fi

# Check if Docker Compose is available
echo -e "${YELLOW}[2/4] Checking Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
    echo -e "${GREEN} ✔ Docker Compose (v1) is available${NC}"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
    echo -e "${GREEN} ✔ Docker Compose (v2 plugin) is available${NC}"
else
    echo -e "${RED} ✘ Docker Compose not found. Please install Docker Compose plugin.${NC}"
    exit 1
fi

# Pull pre-built images and start containers
echo -e "${YELLOW}[3/4] Pulling pre-built images and starting GenieACS...${NC}"
$COMPOSE_CMD pull
$COMPOSE_CMD up -d
if [ $? -eq 0 ]; then
    echo -e "${GREEN} ✔ Containers started successfully${NC}"
else
    echo -e "${RED} ✘ Failed to start containers${NC}"
    exit 1
fi

# Wait for MongoDB to start and restore multi-vendor configuration
echo -e "${YELLOW}[4/4] Restoring Multi-Vendor configuration...${NC}"
echo -e "${YELLOW}   Waiting 15 seconds for MongoDB to initialize...${NC}"
sleep 15

if [ -f "./restore-config.sh" ]; then
    chmod +x ./restore-config.sh
    ./restore-config.sh
else
    echo -e "${RED} ✘ restore-config.sh not found.${NC}"
fi

# Final Success Message
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Installation & Setup Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${NC}Access GenieACS:"
echo -e "${CYAN}  Dashboard (Recommended): http://localhost:8080${NC}"
echo -e "${CYAN}  GenieACS Direct UI:      http://localhost:3000${NC}"
echo -e "${CYAN}  CWMP (TR-069):          http://localhost:7547${NC}"
echo -e "${CYAN}  NBI (REST API):         http://localhost:7557${NC}"
echo -e "${CYAN}  File Server:            http://localhost:7567${NC}"
echo ""
echo -e "${NC}Default credentials:"
echo -e "${YELLOW}  Username: dsbilling${NC}"
echo -e "${YELLOW}  Password: ds271015${NC}"
echo ""
