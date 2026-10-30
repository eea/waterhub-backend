# syntax=docker/dockerfile:1
FROM eeacms/plone-backend:6.1.5-1

ARG EGGREPO_URL=https://eggrepo.eea.europa.eu/simple

COPY requirements.txt constraints.txt /app/
RUN pip install --no-cache-dir \
    --extra-index-url "${EGGREPO_URL}" \
    -r /app/requirements.txt \
    -c /app/constraints.txt

ENV ZCML="eea.waterhub.policy"

LABEL org.opencontainers.image.title="WaterHub backend" \
      org.opencontainers.image.description="Plone 6 backend for WaterHub"

