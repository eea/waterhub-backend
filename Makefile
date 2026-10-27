PLONE_IMAGE ?= eeacms/plone-backend:6.1.4-16
IMAGE ?= waterhub-backend
TAG ?= latest
POLICY_REPOSITORY ?= https://github.com/eea/eea.waterhub.policy.git
POLICY_SOURCE ?= sources/eea.waterhub.policy
POLICY_REF ?= master
TEST_IMAGE ?= waterhub-backend-test
TEST_TAG ?= latest
TEST_CONTAINER ?= waterhub-backend-policy-test

.PHONY: help checkout develop start stop restart logs shell test-image test lint package ci format build clean config

help:
	@echo "WaterHub backend commands:"
	@echo "  make checkout Clone the editable policy source under sources/"
	@echo "  make develop  Build the development image (including mxdev sources)"
	@echo "  make start    Start the idle backend development container"
	@echo "  make stop     Stop containers and preserve site data"
	@echo "  make restart  Restart the idle development container"
	@echo "  make logs     Follow backend logs"
	@echo "  make shell    Open a shell in the running backend"
	@echo "  make test-image Build the self-contained policy test image"
	@echo "  make test     Run policy tests with coverage in the test image"
	@echo "  make lint     Check policy Python sources in the test image"
	@echo "  make package  Build and validate policy distributions"
	@echo "  make ci       Run all policy quality gates and export reports"
	@echo "  make format   Format policy Python sources"
	@echo "  make build    Build the production-style image"
	@echo "  make clean    Remove containers and the local site-data volume"

checkout:
	@mkdir -p sources
	@if [ ! -d "$(POLICY_SOURCE)/.git" ]; then \
		git clone $(POLICY_REPOSITORY) $(POLICY_SOURCE); \
		git -C $(POLICY_SOURCE) checkout $(POLICY_REF); \
	fi

develop: checkout build
	BACKEND_IMAGE=$(IMAGE):$(TAG) docker compose build backend

start:
	BACKEND_IMAGE=$(IMAGE):$(TAG) docker compose up -d backend

stop:
	docker compose down

restart:
	docker compose restart backend

logs:
	docker compose logs --follow backend

shell:
	docker compose exec backend bash

test-image: checkout
	docker build \
		--build-arg PLONE_IMAGE=$(PLONE_IMAGE) \
		--file Dockerfile.test \
		--tag $(TEST_IMAGE):$(TEST_TAG) \
		.

test: test-image
	docker run --rm $(TEST_IMAGE):$(TEST_TAG) make test-ci

lint: test-image
	docker run --rm $(TEST_IMAGE):$(TEST_TAG) make lint

package: test-image
	docker run --rm $(TEST_IMAGE):$(TEST_TAG) make package

ci: test-image
	@set -eu; \
		docker rm --force $(TEST_CONTAINER) >/dev/null 2>&1 || true; \
		docker create --name $(TEST_CONTAINER) $(TEST_IMAGE):$(TEST_TAG) make ci >/dev/null; \
		status=0; \
		docker start --attach $(TEST_CONTAINER) || status=$$?; \
		rm -rf xunit-reports-current; \
		docker cp $(TEST_CONTAINER):/app/policy/xunit-reports-current ./xunit-reports-current || status=$$?; \
		docker rm --force $(TEST_CONTAINER) >/dev/null; \
		exit $$status

format:
	docker compose exec backend ruff check --fix /app/sources/eea.waterhub.policy/src /app/sources/eea.waterhub.policy/tests
	docker compose exec backend ruff format /app/sources/eea.waterhub.policy/src /app/sources/eea.waterhub.policy/tests

build:
	docker build --build-arg PLONE_IMAGE=$(PLONE_IMAGE) --tag $(IMAGE):$(TAG) .

clean:
	docker compose down --volumes --remove-orphans

config:
	BACKEND_IMAGE=$(IMAGE):$(TAG) docker compose config

