# syntax=docker/dockerfile:1

ARG PLONE_IMAGE=eeacms/plone-backend:latest
FROM ${PLONE_IMAGE}

WORKDIR /app

COPY requirements.txt constraints.txt mx.ini ./
RUN pip install --no-cache-dir mxdev \
    && mxdev -c mx.ini \
    && touch constraints-mxdev.txt \
    && pip install --no-cache-dir \
        -r requirements-mxdev.txt \
        -c constraints-mxdev.txt

LABEL org.opencontainers.image.title="WaterHub backend (development)" \
      org.opencontainers.image.description="Development Plone 6 backend for WaterHub"

