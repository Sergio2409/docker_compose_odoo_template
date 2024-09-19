# Install Python and required packages
FROM ubuntu:22.04
LABEL MAINTAINER Sergio Valdes <sergiovaldes2409@gmail.com>

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libldap2-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    postgresql \
    postgresql-client \
    procps \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv

# Create a virtual environment
RUN python3 -m venv /opt/odoo-venv

# Activate the virtual environment and install Odoo requirements
COPY requirements.txt /tmp/requirements.txt
RUN /opt/odoo-venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt

# Expose the Odoo port
EXPOSE 8069

# Command to run Odoo using the virtual environment
CMD ["/opt/odoo-venv/bin/python", "/home/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
