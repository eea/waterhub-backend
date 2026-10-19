PLONE_IMAGE ?= eeacms/plone-backend:latest
IMAGE ?= waterhub-backend
TAG ?= latest
POLICY_REPOSITORY ?= https://github.com/eea/eea.waterhub.policy.git
POLICY_SOURCE ?= sources/eea.waterhub.policy

.PHONY: help checkout develop start stop restart logs shell test lint format build clean config

help:
	@echo "WaterHub backend commands:"
	@echo "  make checkout Clone the editable policy source under sources/"
	@echo "  make develop  Build the development image (including mxdev sources)"
	@echo "  make start    Start the idle backend development container"
	@echo "  make stop     Stop containers and preserve site data"
	@echo "  make restart  Restart the idle development container"
	@echo "  make logs     Follow backend logs"
	@echo "  make shell    Open a shell in the running backend"
	@echo "  make test     Run policy tests in the backend container"
	@echo "  make lint     Check policy Python sources"
	@echo "  make format   Format policy Python sources"
	@echo "  make build    Build the production-style image"
	@echo "  make clean    Remove containers and the local site-data volume"

checkout:
	@mkdir -p sources
	@if [ ! -d "$(POLICY_SOURCE)/.git" ]; then \
		git clone $(POLICY_REPOSITORY) $(POLICY_SOURCE); \
	fi

develop: checkout
	PLONE_IMAGE=$(PLONE_IMAGE) docker compose build backend

start:
	PLONE_IMAGE=$(PLONE_IMAGE) docker compose up -d backend

stop:
	docker compose down

restart:
	docker compose restart backend

logs:
	docker compose logs --follow backend

shell:
	docker compose exec backend bash

test:
	docker compose exec backend pytest /app/sources/eea.waterhub.policy/tests

lint:
	docker compose exec backend ruff check /app/sources/eea.waterhub.policy/src /app/sources/eea.waterhub.policy/tests
	docker compose exec backend ruff format --check /app/sources/eea.waterhub.policy/src /app/sources/eea.waterhub.policy/tests

format:
	docker compose exec backend ruff check --fix /app/sources/eea.waterhub.policy/src /app/sources/eea.waterhub.policy/tests
	docker compose exec backend ruff format /app/sources/eea.waterhub.policy/src /app/sources/eea.waterhub.policy/tests

build:
	docker build --build-arg PLONE_IMAGE=$(PLONE_IMAGE) --tag $(IMAGE):$(TAG) .

clean:
	docker compose down --volumes --remove-orphans

config:
	PLONE_IMAGE=$(PLONE_IMAGE) docker compose config

