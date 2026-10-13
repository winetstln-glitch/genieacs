FROM node:18-alpine

# Install curl and GenieACS 1.2.16
RUN apk add --no-cache curl \
    && npm install -g genieacs@1.2.16 \
    && npm cache clean --force

WORKDIR /app

# Ensure directories for extensions and files exist
RUN mkdir -p /opt/genieacs/ext /opt/genieacs/files

EXPOSE 3000 7547 7557 7567
