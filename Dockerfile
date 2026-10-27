# syntax=docker/dockerfile:1

ARG PLONE_IMAGE=eeacms/plone-backend:6.1.4-23
FROM ${PLONE_IMAGE}

ARG EGGREPO_URL=https://eggrepo.eea.europa.eu/simple

COPY requirements.txt constraints.txt /app/
RUN pip install --no-cache-dir \
    --extra-index-url "${EGGREPO_URL}" \
    -r /app/requirements.txt \
    -c /app/constraints.txt

ENV ZCML="eea.waterhub.policy"

LABEL org.opencontainers.image.title="WaterHub backend" \
      org.opencontainers.image.description="Plone 6 backend for WaterHub"

