#!/bin/bash

# Restore GenieACS Configuration
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Restoring GenieACS Multi-Vendor Config${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Determine DB directory
DB_PATH=""
if [ -d "db" ]; then
    DB_PATH="db"
elif [ -d "multitab/db" ]; then
    DB_PATH="multitab/db"
else
    echo -e "${RED}ERROR - Database folder 'db' not found!${NC}"
    echo -e "${YELLOW}Ensure the 'db' folder is present in the current directory.${NC}"
    exit 1
fi
echo -e "${CYAN}Using database source: ${DB_PATH}${NC}"

# Check if containers are running
echo -e "${YELLOW}[1/3] Checking MongoDB container...${NC}"
MONGO_RUNNING=$(docker inspect -f '{{.State.Running}}' genieacs-mongodb 2>/dev/null)
if [ "$MONGO_RUNNING" != "true" ]; then
    echo -e "${RED}✗ MongoDB container 'genieacs-mongodb' is not running.${NC}"
    echo -e "${YELLOW}Start containers first with: docker compose up -d${NC}"
    exit 1
fi
echo -e "${GREEN}✓ MongoDB container is running${NC}"

# Copy db files to container
echo -e "${YELLOW}[2/3] Copying configuration files to MongoDB container...${NC}"
docker cp "${DB_PATH}/." genieacs-mongodb:/tmp/genieacs-db
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Configuration files copied${NC}"
else
    echo -e "${RED}✗ Failed to copy configuration files${NC}"
    exit 1
fi

# Restore database
echo -e "${YELLOW}[3/3] Restoring database collections (mongorestore)...${NC}"
docker exec genieacs-mongodb mongorestore --db genieacs --drop /tmp/genieacs-db
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database restored successfully${NC}"
else
    echo -e "${RED}✗ Failed to restore database${NC}"
    exit 1
fi

# Set superadmin role for dsbilling and remove alijayanet
echo -e "${YELLOW}Configuring default superadmin credentials...${NC}"
docker exec genieacs-mongodb mongo genieacs --eval '
  db.users.deleteOne({_id: "alijayanet"});
  db.users.updateOne({_id: "dsbilling"}, {$set: {roles: "admin"}});
  db.users.updateOne({_id: "admin"}, {$set: {roles: "admin"}});
' > /dev/null 2>&1
echo -e "${GREEN}✓ Superadmin account ready: dsbilling / ds271015${NC}"

# Restart GenieACS services
echo ""
echo -e "${YELLOW}Restarting GenieACS service to reload configuration...${NC}"
docker restart genieacs 2>/dev/null || docker restart genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui 2>/dev/null
echo -e "${GREEN}✓ Services restarted${NC}"

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Configuration Restored Successfully!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${NC}Multi-vendor support & Multi-Tab UI are now active:"
echo -e "${CYAN}  • Huawei${NC}"
echo -e "${CYAN}  • FiberHome${NC}"
echo -e "${CYAN}  • ZTE${NC}"
echo -e "${CYAN}  • CData${NC}"
echo -e "${CYAN}  • GGCLink${NC}"
echo -e "${CYAN}  • VSOL${NC}"
echo -e "${CYAN}  • Mikrotik${NC}"
echo ""
echo -e "${NC}Access GenieACS:"
echo -e "${CYAN}  Dashboard:   http://localhost:8080${NC}"
echo -e "${CYAN}  GenieACS UI: http://localhost:3000 (dsbilling / ds271015)${NC}"
echo ""
