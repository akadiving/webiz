ARG PYTHON_VERSION="3.11"
ARG DEBIAN_FRONTEND=noninteractive
ARG PIP_NO_CACHE_DIR=1
ARG PIP_CACHE_DIR=/tmp/

# Stage build
# Content image build: https://gitlab.inspectorio.com/devops/platform-docker-images/-/blob/master/images/python/${PYTHON_VERSION}-build/Dockerfile
FROM python:${PYTHON_VERSION}-slim AS build

# Update packages
RUN apt update -qq -y \
    && apt install -qq -y gcc build-essential libxml2 binutils libproj-dev gdal-bin libmagic1 \
    && apt clean \
    && pip install -U pip \
    && pip install poetry==1.8.2 \
    && poetry config virtualenvs.create false \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python -m venv /opt

COPY pyproject.toml poetry.lock ./

RUN . /opt/bin/activate \
    && poetry install

# Stage runtime
# Content image runtime: https://gitlab.inspectorio.com/devops/platform-docker-images/-/blob/master/images/python/${PYTHON_VERSION}-runtime/Dockerfile
FROM python:${PYTHON_VERSION}-slim AS runtime

# Copy the installed dependencies from the build stage
COPY --from=build /opt /opt

# Copy the remaining application files
COPY . .

EXPOSE 5000
ENTRYPOINT ["uwsgi --listen 128 --ini uwsgi.ini"]
