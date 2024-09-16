# Installation and Initial Configuration for Hammerton Devs

Instructions assume you are starting in your home directory (e.g., `~/`).

## Docker Installation
1. [Install Docker](https://docs.docker.com/get-docker/)
2. [Install Docker Compose](https://docs.docker.com/compose/install/)

## Setup Odoo with Docker

1. Download the Repository:
    ```bash
    git clone --branch ham-dev git@github.com:Sergio2409/docker_compose_odoo_template.git
    ```

2. Set up other repo directories:

    - Clone Odoo-EE 16.0 repo (must have access):
        ```bash
        git clone --branch 16.0 git@github.com:odoo/enterprise.git odoo-e
        ```

    - Clone the `hmr-odoo` repo (must have access):
        ```bash
        git clone git@github.com/hmr-odoo/hammerton.git hmr-odoo
        ```

3. Enter the folder:
    ```bash
    cd docker_compose_odoo_template
    ```

4. Select Odoo version from the Supported tags:
    - Go to the [Odoo official docker image](https://registry.hub.docker.com/_/odoo/).
    - Select a tag from the Supported tags for your desired Odoo version (e.g., `16.0`).
    - Update the first line in `dockerfile/odoo.Dockerfile` with the appropriate Odoo version. The default is `FROM odoo:14.0`.

5. Update the `.env` file with your own values or use the defaults:
    ```bash
    # .env file
    DB_IMAGE=postgres               # [Postgres official docker image](https://registry.hub.docker.com/_/postgres)
    DB_TAG=latest                   # The `latest` tag is the default
    DB_PORT=5433                    # PostgreSQL port
    DB_NAME=odoo                    # Database name
    DB_USER=odoo                    # User login
    DB_PASSWD=odoo                  # User password
    ODOO_E_PATH=../odoo-e           # Relative path to Odoo-EE source
    HMR_MODULES_PATH=../hmr-odoo    # Relative path to Hammerton modules
    ```

6. Build the Docker images (execute this command once):
    ```bash
    sudo docker compose build
    ```

7. Start all the containers for the first time:
    ```bash
    sudo docker compose up
    ```

8. Comment `- ${HMR_MODULES_PATH}:/mnt/hammerton)` (line 15) of `docker-compose.yml` to avoid installing the `base` module every time.

9. Start all the containers:
    ```bash
    sudo docker compose up
    ```

10. [Open the Odoo instance](http://localhost:8069/)
    - The credentials are configured in the `.env` file.
    - Default login: `admin`, password: `admin`.

11. [Open the pgAdmin instance](http://localhost:8080/)
    - The credentials are configured in the `.env` file.
    - Default login: `admin`, password: `admin`.

12. The setup is complete if no errors occurred.

## How-To Section

1. **How to start all containers:**
    ```bash
    sudo docker compose up
    ```

2. **How to stop all containers:**
    - Press `Ctrl + C`.

3. **How to do a clean restart of a Docker instance:**

    - Stop the containers:
        ```bash
        sudo docker compose down
        ```
    - Remove all containers:
        ```bash
        sudo docker rm -f $(sudo docker ps -a -q)
        ```
    - Remove all volumes:
        ```bash
        sudo docker volume rm $(sudo docker volume ls -q)
        ```

    *Note: Deleting volumes will wipe out data. Back up any necessary data before deleting.*

4. **How to execute the Odoo scaffold command:**
    ```bash
    sudo docker exec odoo-stack /usr/bin/odoo scaffold openacademy /mnt/extra-addons
    ```

5. **How to execute the Odoo install command in the console:**
    - Uncomment line 15 of the `docker-compose.yml` and modify `openacademy` to the desired module name.

6. **How to execute the Odoo update command in the console:**
    - Uncomment line 17 of the `docker-compose.yml` and modify `openacademy` to the desired module name.

7. **How to include custom addons in the container:**
    - Create the new addon in the `addons-extra` folder to be recognized by the Odoo container.
    - Stop the server.
    - Start the server again.
    - Remember to update the App list inside Odoo Apps.

8. **How to access the debugging session (Ipdb):**
    - In a new terminal, once Docker is running, type:
        ```bash
        sudo docker attach odoo-stack
        ```
