#!/bin/bash

echo "Script running as user: $(whoami)"

# Ensure we have all required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ODOO_TAG> <ODOO_WEB_PORT>"
    exit 1
fi

# Assign arguments to variables
ODOO_TAG=$1
ODOO_WEB_PORT=$2

# Dynamically compute DB_NAME and INIT_COMMAND
DB_NAME="odoo${ODOO_TAG%%.*}"
INIT_COMMAND="-d $DB_NAME -i base"

# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo ".env file not found in the current directory."
    exit 1
fi

# Update the .env file
sed -i "s/^ODOO_TAG=.*/ODOO_TAG=$ODOO_TAG/" "$ENV_FILE"
sed -i "s/^DB_NAME=.*/DB_NAME=$DB_NAME/" "$ENV_FILE"
sed -i "s|^INIT_COMMAND=.*|INIT_COMMAND=$INIT_COMMAND|" "$ENV_FILE"
sed -i "s/^ODOO_WEB_PORT=.*/ODOO_WEB_PORT=$ODOO_WEB_PORT/" "$ENV_FILE"

echo "Updated .env file with the following values:"
echo "  ODOO_TAG=$ODOO_TAG"
echo "  DB_NAME=$DB_NAME"
echo "  INIT_COMMAND=$INIT_COMMAND"
echo "  ODOO_WEB_PORT=$ODOO_WEB_PORT"

# Navigate to the ODOO_E_PATH
ODOO_E_PATH=$(grep ^ODOO_E_PATH "$ENV_FILE" | cut -d= -f2 | tr -d '\r' | xargs)

echo "Sanitized ODOO_E_PATH: '$ODOO_E_PATH'"

if [ ! -d "$ODOO_E_PATH" ]; then
    echo "Odoo Enterprise path does not exist."
    exit 1
fi

# Store the current directory
CURRENT_DIR=$(pwd)
echo "Current directory stored: $CURRENT_DIR"

# Switch to the enterprise path
cd "$ODOO_E_PATH" || exit
echo "Switched to Odoo Enterprise path: $(pwd)"

# Switch to the branch specified by ODOO_TAG
echo "Switching to branch $ODOO_TAG..."
git fetch
git checkout "$ODOO_TAG" || { echo "Failed to switch to branch $ODOO_TAG. Exiting."; exit 1; }

# Return to the original directory
cd "$CURRENT_DIR" || exit
echo "Returned to the original directory: $(pwd)"

# Execute the Docker commands
echo "Stopping and cleaning up Docker containers and volumes..."
sudo docker-compose down
sudo docker volume rm $(sudo docker volume ls -q)
sudo rm -rf ./db-own-data/*
sudo docker-compose up

echo "Script execution completed successfully."
