# syntax=docker/dockerfile:1

# Build context is this directory: `cd develop && docker build .`
# The production image already has the production requirements installed;
# this layer adds develop/requirements.txt and the mx.ini source checkouts.
ARG BACKEND_IMAGE=eeacms/waterhub-backend:latest
FROM ${BACKEND_IMAGE}

WORKDIR /app/develop

COPY mx.ini requirements.txt ./
RUN pip install --no-cache-dir mxdev \
    && mxdev -c mx.ini \
    && pip install --no-cache-dir -r requirements-mxdev.txt \
    && find /app -not -user plone -exec chown plone:plone {} \+

WORKDIR /app

LABEL org.opencontainers.image.title="WaterHub backend (development)" \
      org.opencontainers.image.description="Development Plone 6 backend for WaterHub"
