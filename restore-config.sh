#!/bin/bash

# Restore GenieACS Configuration
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Restoring GenieACS Configuration${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check if containers are running
echo -e "${YELLOW}[1/3] Checking MongoDB container...${NC}"
MONGO_RUNNING=$(docker inspect -f '{{.State.Running}}' genieacs-mongodb 2>/dev/null)
if [ "$MONGO_RUNNING" != "true" ]; then
    echo -e "${RED}✗ MongoDB container is not running. Start containers first with: docker-compose up -d${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MongoDB is running${NC}"

# Copy db files to container
echo -e "${YELLOW}[2/3] Copying configuration files...${NC}"
docker cp db/. genieacs-mongodb:/tmp/genieacs-db
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Configuration files copied${NC}"
else
    echo -e "${RED}✗ Failed to copy configuration files${NC}"
    exit 1
fi

# Restore database
echo -e "${YELLOW}[3/3] Restoring database...${NC}"
docker exec genieacs-mongodb mongorestore --db genieacs --drop /tmp/genieacs-db
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database restored successfully${NC}"
else
    echo -e "${RED}✗ Failed to restore database${NC}"
    exit 1
fi

# Restart GenieACS services
echo ""
echo -e "${YELLOW}Restarting GenieACS services...${NC}"
docker restart genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui
echo -e "${GREEN}✓ Services restarted${NC}"

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Configuration Restored!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${NC}Multi-vendor support is now available:"
echo -e "${CYAN}  • Huawei${NC}"
echo -e "${CYAN}  • FiberHome${NC}"
echo -e "${CYAN}  • ZTE${NC}"
echo -e "${CYAN}  • CData${NC}"
echo -e "${CYAN}  • GGCLink${NC}"
echo -e "${CYAN}  • VSOL${NC}"
echo -e "${CYAN}  • Mikrotik${NC}"
echo -e "${CYAN}  • And many more!${NC}"
echo ""
