# Install Python and required packages
FROM ubuntu:22.04
LABEL MAINTAINER Sergio Valdes <sergiovaldes2409@gmail.com>

# Prevents interactive prompts during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    libldap2-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    procps \
    postgresql \
    postgresql-client \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    wkhtmltopdf && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /opt/odoo-venv

# Set the context for Odoo source
COPY --from=odoo-src /requirements.txt /tmp/requirements.txt

# Activate the virtual environment and install Odoo requirements
RUN /opt/odoo-venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt

# Expose the Odoo port
EXPOSE 8069

# Command to run Odoo using the virtual environment
ENTRYPOINT ["/opt/odoo-venv/bin/python3", "/home/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf", "-d", "odoo"]