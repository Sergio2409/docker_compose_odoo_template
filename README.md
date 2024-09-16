# Installation and Initial Configuration for Hammerton Devs

Instructions assume you are starting in your home directory (e.g. `~/`)

## Docker installation

1. [Install docker](https://docs.docker.com/get-docker/)
2. [Install docker compose](https://docs.docker.com/compose/install/)

## Setup Odoo with Docker

1. Download the Repository
   - With SSH: `git clone --branch ham-dev git@github.com:Sergio2409/docker_compose_odoo_template.git`
   - With HTTPS: `git clone --branch ham-dev https://github.com/Sergio2409/docker_compose_odoo_template.git`

## Set up other repo directories

    - Clone Odoo-EE 16.0 repo (must have access) `git clone --branch 16.0 git@github.com:odoo/enterprise.git odoo-e`
    - Clone hmr-odoo repo (must have access) `git clone https://github.com/hmr-odoo/hammerton.git hmr-odoo`

2. Enter the folder

   - cd docker_compose_odoo_template

3. Select Odoo version from the Supported tags.

   - Go to to the link [Odoo oficial docker image](https://registry.hub.docker.com/_/odoo/)
   - Select one tag from the the Supported tags and respective Dockerfile links for the respective Odoo version (e.g. `16.0`).
   - Update the first line in `dockerfile/odoo.Dockerfile` to specify the appropriate Odoo version. The default version is `FROM odoo:16.0`.

4. The next step is to update the `.env` file with your own values if required otherwise you can let the default values.
   File `.env`:
   ```
   DB_IMAGE=postgres             # [Postgres oficial docker image](https://registry.hub.docker.com/_/postgres)
   DB_TAG=latest                 # From the above link select the respective tag, the `latest` tag is the default
   DB_PORT=5432                  # PostgreSQL port
   DB_NAME=odoo                  # Database name
   DB_USER=odoo                  # User login
   DB_PASSWD=odoo                # User password
   ODOO_E_PATH=../odoo-e         # Relative path to Odoo-EE source
   HMR_MODULES_PATH=../hmr-odoo  # Relative path to Hammerton modules
   ```
5. (Optional - if you don't build first, it builds when you run `up`.) Before using the file you need to execute the build command. This step is executed only one time.

   - `sudo docker compose build`

6. Start all the containers the first time

   - `sudo docker compose up`

7. Comment the line 15 of the `docker compose.yml` to avoid installing the `base` module every time

8. Start all the containers

   - `sudo docker compose up`

9. [Open the Odoo instance by clicking this link](http://localhost:8069/)

   - The credentials are configured in the `.env` file.
   - If no changes are made use login: `admin` and password: `admin`

10. At this point the setup was finished if no error occured, and you'll be able
    to use Odoo with the default database.

11. To upload a database from another server, download a neutralized database backup (with or without filestore) from Odoo.sh (or whatever hosting), then use the [Odoo Database manager tool](http://localhost:8069/web/database/manager) to Restore it.

- You can pick any password (`admin` is common/default)
- Select the `.zip` file with the backup
- Choose a database name (not `odoo`) to use
- After completion, click on the database name to open it.
- Log in (using a username and password contained in that database)
- Go into Apps and run an Upgrade on the various `hmr_*` modules
  to perform their installation.
- The order may matter, suggested is `hmr_stock`, `hmr_sale`, `hmr_hr`, `hmr_account`, etc.

## How To section

1. How to start all containers

   - `sudo docker compose up`

2. How to stop all containers

   - `Press Ctrl + c`

3. How to Do a Clean Restart of a Docker Instance

   - Stop the container(s) using the following command: `docker compose down`
   - Delete all containers using the following command: `sudo docker rm -f $(sudo docker ps -a -q)`
   - Delete all volumes using the following command: `sudo docker volume rm $(sudo docker volume ls -q)`

   Note: Deleting volumes will wipe out their data. Back up any data that you need before deleting a container

4. How to execute the Odoo scaffold command

   - `sudo docker exec odoo-stack /usr/bin/odoo scaffold openacademy /mnt/extra-addons`

5. How to execute the Odoo install command in console

   - Uncomment the line 15 of the `docker compose.yml` and modify the `openacademy` by the proper module name

6. How to execute the Odoo update command in console

   - Uncomment the line 17 of the `docker compose.yml` and modify the `openacademy` by the proper module name

7. How to include custom addons into the container

   - Create the new addon into the `addons-extra` folder to be recognized by the Odoo container
   - Stop the server
   - Start the server
   - Remember to update the App list inside Odoo Apps

8. How to access to the Debugging session (Ipdb)

   - On a new terminal once the Docker is running type: sudo docker attach odoo-stack

9. How to access Odoo PostgreSQL database from pgAdmin?

   - In pgAdmin, add a server configuration connecting to `localhost` using the
     settings in your `.env` configuration: port is `DB_PORT`, username is
     `DB_USER`, password is `DB_PASSWD`

10. How to restore an Odoo backup from a production or staging server?

- Download a neutralized database backup (with or without filestore) from Odoo.sh (or whatever hosting) for the desired environment.
- The [Odoo Database manager tool](http://localhost:8069/web/database/manager) can then Restore it
  - You can pick any password (`admin` is common/default)
  - Select the `.zip` file with the backup
  - Choose a database name (not `odoo`) to use
  - After completion, click on the database name to open it.
- Alternatives:
  - Using pgAdmin or `psql` or `pg_restore`, you can restore the database
  - Odoo.sh does SQL format dumps, which don't work with `pg_restore` or pgAdmin
    restore function, so these should be loaded using `psql` or a query window in
    pgAdmin.
