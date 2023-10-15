FROM odoo:16.0

USER root
LABEL MAINTAINER Sergio Valdes <sergiovaldes2409@gmail.com>

RUN apt update
RUN apt-get update && apt-get install -y procps
RUN pip install ipdb
