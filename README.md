# Installation and Initial Configuration for Hammerton Devs
Instructions assume you are starting in your home directory (e.g. `~/`)

## Docker installation
1. [Install docker](https://docs.docker.com/get-docker/)
2. [Install docker compose](https://docs.docker.com/compose/install/)

## Setup Odoo with Docker
1. Download the Repository
    - `git clone git clone --branch ham-dev git@github.com:Sergio2409/docker_compose_odoo_template.git`

## Set up other repo directories
    - Clone Odoo-EE repo (must have access) `git clone git@github.com:odoo/enterprise.git odoo-e`
    - Clone hmr-odoo repo (must have access) `git clone https://github.com/hmr-odoo/hammerton.git hmr-odoo`

2. Enter the folder
    - cd docker_compose_odoo_template

3. Select Odoo version from the Supported tags.
    - Go to to the link [Odoo oficial docker image](https://registry.hub.docker.com/_/odoo/)
    - Select one tag from the the Supported tags and respective Dockerfile links for the respective Odoo version (e.g. `16.0`).
    - Update the first line in `dockerfile/odoo.Dockerfile` to specify the appropriate Odoo version. The default version is `FROM odoo:14.0`.

4. The next step is to update the `.env` file with your own values if required otherwise you can let the default values.
	File `.env`:
    - DB_IMAGE=postgres              # [Postgres oficial docker image](https://registry.hub.docker.com/_/postgres)
    - DB_TAG=latest                  # From the above link select the respective tag, the `latest` tag is the default
    - DB_PORT=5433                   # PostgreSQL port
    - DB_NAME=odoo                   # Database name
    - DB_USER=odoo                   # User login
    - DB_PASSWD=odoo                 # User password
    - ODOO_E_PATH=../odoo-3          # Relative path to Odoo-EE source
    - HMR_MODULES_PATH=../hmr-odoo   # Relative path to Hammerton modules
5. Before using the file you need to execute the build command. This step is executed only one time
    - `sudo docker compose build`

6. Start all the containers the first time
    - `sudo docker compose up`

7. Comment the line 15 of the `docker compose.yml` to avoid installing the `base` module every time

8. Start all the containers
    - `sudo docker compose up`

9. [Open the Odoo instance by clicking this link](http://localhost:8069/)
    - The credentials are configured in the `.env` file.
    - If no changes are made use login: `admin` and password: `admin`

10. At this point the setup was finished if no error occured

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

    - Uncomment the line 15 of the `docker compose.yml` and modify the `openacademy` by the propper module name

6. How to execute the Odoo update command in console

    - Uncomment the line 17 of the `docker compose.yml` and modify the `openacademy` by the propper module name

7. How to include custom addons into the container

    - Create the new addon into the `addons-extra` folder to be recognized by the Odoo container
    - Stop the server
    - Start the server
    - Remember to update the App list inside Odoo Apps

8. How to access to the Debuggin session (Ipdb)
    - On a new terminal once the Docker is running type: sudo docker attach odoo-stack
