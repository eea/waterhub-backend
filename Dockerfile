# syntax=docker/dockerfile:1

ARG PLONE_IMAGE=eeacms/plone-backend:6.1.4-16
FROM ${PLONE_IMAGE}

COPY requirements.txt constraints.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt -c /app/constraints.txt

LABEL org.opencontainers.image.title="WaterHub backend" \
      org.opencontainers.image.description="Plone 6 backend for WaterHub"

