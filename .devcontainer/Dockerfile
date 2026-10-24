FROM mcr.microsoft.com/devcontainers/python:3-3.14-trixie

ENV PYTHONUNBUFFERED 1

# Install uv (pinned to 0.12.24, published 2026-10-08) by copying the static binaries
# from the official image into /usr/local/bin, which is on PATH for the vscode user.
COPY --from=ghcr.io/astral-sh/uv:0.12.24 /uv /uvx /usr/local/bin/

# [Optional] If your requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>



