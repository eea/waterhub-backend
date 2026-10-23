# Project instructions

## Scope

This repository builds the Plone 6 backend image for the Copernicus Thematic
Water Hub. WaterHub-specific Plone behavior belongs in the separately versioned
`eea.waterhub.policy` package under `sources/eea.waterhub.policy`; frontend work
belongs in the sibling `waterhub-frontend` repository.

## Supported stack

- Base image: `eeacms/plone-backend:6.1.4-16`
- Plone: 6.1.4
- Python: 3.12
- `eea.volto.policy`: 12.7

Read the exact pins from `constraints.txt`, `requirements.txt`, and the
`PLONE_IMAGE` Make variable. Do not upgrade them independently.

## Development workflow

Use Docker, Docker Compose, and GNU Make:

```shell
make checkout
make develop
make start
```

The backend container stays idle until Plone is started interactively:

```shell
make shell
./docker-entrypoint.sh start
```

Restart Plone after Python or ZCML changes. Rebuild the development image after
dependency, `mx.ini`, or development Dockerfile changes. Apply changed
GenericSetup profiles or provide an upgrade step for existing sites.

## Quality gates

Before committing backend or policy integration changes, run:

```shell
make ci
```

This is the canonical local and Jenkins-compatible quality command. It builds
`Dockerfile.test`, runs the policy's Ruff, pytest, coverage, and distribution
checks, then exports reports to `xunit-reports-current/`. Do not replace this
with host-only commands or bind mounts; Jenkins must run the same baked-image
path as developers.

Use narrower targets while iterating:

```shell
make lint
make test
make package
```

Run `make build` after production Dockerfile or dependency changes.

## Repository boundaries

The ignored `sources/eea.waterhub.policy` directory is a separate Git checkout.
Commit policy changes from that directory and backend image/configuration
changes from this repository. Do not commit generated reports, build outputs,
virtual environments, or editable-source artifacts.

## Release and infrastructure

Maintain user-visible changes under `Unreleased` in `CHANGELOG.md`. Follow
`RELEASE.md` for release preparation. Do not invent or commit Jenkins job names,
SonarQube keys, credential IDs, notification addresses, or deployment targets;
confirm them with the EEA infrastructure owners first.
