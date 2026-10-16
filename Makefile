PLONE_IMAGE ?= eeacms/plone-backend:latest
IMAGE ?= waterhub-backend
TAG ?= latest

.PHONY: help develop start stop logs build clean config

help:
	@echo "WaterHub backend commands:"
	@echo "  make develop  Build the development image (including mxdev sources)"
	@echo "  make start    Run Plone in the foreground on port 8080"
	@echo "  make stop     Stop containers and preserve site data"
	@echo "  make logs     Follow backend logs"
	@echo "  make build    Build the production-style image"
	@echo "  make clean    Remove containers and the local site-data volume"

develop:
	PLONE_IMAGE=$(PLONE_IMAGE) docker compose build backend

start:
	PLONE_IMAGE=$(PLONE_IMAGE) docker compose up backend

stop:
	docker compose down

logs:
	docker compose logs --follow backend

build:
	docker build --build-arg PLONE_IMAGE=$(PLONE_IMAGE) --tag $(IMAGE):$(TAG) .

clean:
	docker compose down --volumes --remove-orphans

config:
	PLONE_IMAGE=$(PLONE_IMAGE) docker compose config

