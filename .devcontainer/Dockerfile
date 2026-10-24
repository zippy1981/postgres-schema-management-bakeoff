FROM mcr.microsoft.com/devcontainers/python:3-3.14-trixie

ENV PYTHONUNBUFFERED 1

# [Optional] If your requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# Tools the candidate hooks expect on PATH (candidates/*/bin/devcontainer_post_create.sh):
# - postgresql-client: psql and pg_dump, from the PGDG repo so they match the db service's major
#   version (pg_dump refuses to dump a newer server). Keep PG_MAJOR in sync with docker-compose.yml.
# - default-jre-headless: Java runtime for apgdiff.
# - cmake: builds pgquarrel.
ARG PG_MAJOR=18
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-common \
    && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
    && apt-get -y install --no-install-recommends \
        postgresql-client-${PG_MAJOR} \
        default-jre-headless \
        cmake \
    && rm -rf /var/lib/apt/lists/*



