ARG ODOO_TAG
FROM odoo:${ODOO_TAG}


USER root
LABEL MAINTAINER Sergio Valdes <sergiovaldes2409@gmail.com>

RUN apt update
RUN apt-get update && apt-get install -y procps

