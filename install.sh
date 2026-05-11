#!/bin/bash

# GenieACS Installer for Linux
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  GenieACS Installation Script${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check if Docker is installed
echo -e "${YELLOW}[1/4] Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker is installed${NC}"
else
    echo -e "${RED}✗ Docker is not installed. Please install Docker first.${NC}"
    echo -e "${YELLOW}Visit: https://docs.docker.com/get-docker/${NC}"
    exit 1
fi

# Check if Docker Compose is available
echo -e "${YELLOW}[2/4] Checking Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓ Docker Compose is available${NC}"
else
    echo -e "${RED}✗ Docker Compose not found${NC}"
    exit 1
fi

# Start containers
echo -e "${YELLOW}[3/4] Starting GenieACS containers...${NC}"
docker-compose up -d
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Containers started successfully${NC}"
else
    echo -e "${RED}✗ Failed to start containers${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${NC}Access GenieACS:"
echo -e "${CYAN}  Dashboard: http://localhost${NC}"
echo -e "${CYAN}  GenieACS UI: http://localhost:3000${NC}"
echo ""
echo -e "${NC}Default credentials:"
echo -e "${YELLOW}  Username: admin${NC}"
echo -e "${YELLOW}  Password: admin${NC}"
echo ""
echo -e "${NC}To restore multi-vendor configuration:"
echo -e "${YELLOW}  1. Wait 30 seconds for MongoDB to start${NC}"
echo -e "${YELLOW}  2. Run: bash restore-config.sh${NC}"
echo ""
