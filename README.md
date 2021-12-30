# docker_compose_odoo_template

# Installation and Initial Configuration

## Initial Preparation
1. [Install docker](https://docs.docker.com/get-docker/)
2. [Install docker-compose](https://docs.docker.com/compose/install/)

## Instalación de Odoo con docker
1. Download the Repository
~~~
git clone git@github.com:Sergio2409/docker_compose_odoo_template.git
~~~
2. Enter the folder
~~~
cd docker_compose_odoo_template
~~~
3. Select Odoo version from the Supported tags.
- Go to to the link [Odoo oficial docker image](https://registry.hub.docker.com/_/odoo/)
- Select one tag from the the Supported tags and respective Dockerfile links for the respective Odoo version.
- Update the file `odoo.Dockerfile` with the respective Odoo version. 
- First line of file `odoo.Dockerfile` `FROM odoo:14.0`, 14.0 is the default tag

4. The next step is to update the `.env` file with your own values if required otherwise you can let the default values.

File `.env`:
- DB_IMAGE=postgres - [Postgres oficial docker image](https://registry.hub.docker.com/_/postgres)
- DB_TAG=latest     - From the above link select the respective tag, the `latest` tag is the default
- DB_PORT=5433      - PostgreSQL port
- DB_NAME=odoo      - Database name
- DB_USER=odoo      - User login
- DB_PASSWD=odoo    - User password
5. Before using the file you need to execute the build command
~~~
`sudo docker-compose build`
This step is executed only one time
~~~
6. At this point the setup was finished if no error occured

## How to section
1. How to start all containers
~~~
`sudo docker-compose up`
~~~

2. How to Do a Clean Restart of a Docker Instance
~~~
Stop the container(s) using the following command:
  `docker-compose down`
Delete all containers using the following command:
  `sudo docker rm -f $(sudo docker ps -a -q)`
Delete all volumes using the following command:
  `sudo docker volume rm $(sudo docker volume ls -q)`

Note: Deleting volumes will wipe out their data. Back up any data that you need before deleting a container
~~~

3. How to execute the Odoo scaffold command
`sudo docker exec odoo-stack /usr/bin/odoo scaffold openacademy /mnt/extra-addons`

4. How to execute the Odoo install command in console
Uncomment the line 15 of the `docker-compose.yml` and modify the `openacademy` by the propper module name

5. How to execute the Odoo update command in console
Uncomment the line 17 of the `docker-compose.yml` and modify the `openacademy` by the propper module name
~~~