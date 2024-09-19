# Installation and Initial Configuration for Hammerton Devs

Instructions assume you are starting in your home directory (e.g., `~/`).

## Docker Installation
1. [Install Docker](https://docs.docker.com/get-docker/)
2. [Install Docker Compose](https://docs.docker.com/compose/install/)

## Setup Odoo with Docker

1. Download this Repository:
    ```bash
    git clone --branch ham-dev git@github.com:Sergio2409/docker_compose_odoo_template.git
    ```

2. Set up other repo directories somewhere on your local filesystem. They will be mounted later on in your `.env` file:

    - Clone Odoo 16.0 Community repo:
        ```bash
        git clone --branch 16.0 git@github.com:odoo/odoo.git odoo
        ```

    - Clone Odoo-EE 16.0 repo (must have access):
        ```bash
        git clone --branch 16.0 git@github.com:odoo/enterprise.git odoo-e
        ```

    - Clone the `hmr-odoo` repo (must have access):
        ```bash
        git clone git@github.com:hmr-odoo/hammerton.git hmr-odoo
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
    ## DATABASE INFO ##
    DB_IMAGE=postgres               # [Postgres oficial docker image](https://registry.hub.docker.com/_/postgres)
    DB_TAG=latest                   # From the above link select the respective tag, the `latest` tag is the default
    DB_PORT=5433                    # PostgreSQL port
    DB_NAME=odoo                    # Database name
    DB_USER=odoo                    # User login
    DB_PASSWD=odoo                  # User password

    ## PGADMIN ##
    PGADMIN_EMAIL=admin@example.com # Email for pgadmin
    PGADMIN_PASSWORD=odoo           # Password for pgadmin

    ## PATHS ##
    ODOO_E_PATH=../odoo-e           # Relative path to Odoo-EE packages
    ODOO_SRC_PATH=../odoo           # Relative path to Odoo source
    HMR_MODULES_PATH=../hmr-odoo    # Relative path to Hammerton modules
    ```

6. (Optional - if you don't build first, it builds when you run `up`.) Before using the file you need to execute the build command. This step is executed only one time.
    ```bash
    sudo docker compose build
    ```

7. Start all the containers for the first time:
    ```bash
    sudo docker compose up
    ```

9. Open the Odoo instance (http://localhost:8069/)
    - The credentials are configured in the `.env` file.
    - Default login: `admin`, password: `admin`.

10. Open the pgAdmin instance (http://localhost:8080/)
    - The credentials are configured in the `.env` file.
    - Default database password: `odoo` (or as defined in `.env`).

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
9. **After a database restore, upgrade base module with restored database.**

    - Go to Apps => Apps => remove Apps filter and search `base`. Click three dots, then click upgrade button.

10. **How to Restore or Upload an Odoo Backup from Another Server**

    1. Download a neutralized database backup (with or without filestore) from Odoo.sh (or other hosting provider) for the desired environment.

    2. Use the [Odoo Database Manager tool](http://localhost:8069/web/database/manager) to restore the backup:
        - You can pick any database manager password (common default is `admin`).
        - Select the `.zip` file with the backup.
        - Choose a new database name (avoid using `odoo`).
        - After the restoration completes, click on the database name to open it.

    3. Log in with the credentials from the restored database.

    4. Optional: Upgrade the `hmr_*` modules in the following suggested order via the Apps menu:
        - `hmr_stock`
        - `hmr_sale`
        - `hmr_hr`
        - `hmr_account`

    5. Alternatives:
        - Use `pgAdmin`, `psql`, or `pg_restore` to restore the database manually.
        - Note: Odoo.sh uses SQL format dumps that aren't compatible with `pg_restore` or pgAdmin's restore function, so these must be loaded using `psql` or a query window in pgAdmin.
