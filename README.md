# Copernicus Thematic Water Hub Backend

Plone 6 backend for WaterHub, based on the generic EEA `eeacms/plone-backend`
image and configured by the `eea.waterhub.policy` add-on.

## Requirements

- Docker with Docker Compose
- GNU Make

## Start developing

Build and start the development container:

```shell
make develop
make start
```

The development container stays idle so that Plone can be started interactively,
as in other EEA backend projects:

```shell
docker compose exec backend bash
./docker-entrypoint.sh start
```

On its first interactive start, the entrypoint creates a `Plone` site using the
Volto distribution and applies `eea.waterhub.policy:default`. Site state
persists in the named Docker volume `waterhub-backend-data`.

- Backend: http://localhost:8080/Plone
- REST API: http://localhost:8080/Plone/++api++
- Local login: `admin` / `admin`

The frontend can then be run from the sibling project:

```shell
cd ../waterhub-frontend
make relstorage
```

Stop the backend without deleting its data:

```shell
make stop
```

Delete containers and local site data explicitly:

```shell
make clean
```

## Images

`make develop` builds `waterhub-backend:develop` with `mxdev` support.
`make build` builds the production-style `waterhub-backend:latest` image.

The base image is configurable for both builds:

```shell
make develop PLONE_IMAGE=eeacms/plone-backend:<approved-tag>
make build PLONE_IMAGE=eeacms/plone-backend:<approved-tag>
```

The default is `eeacms/plone-backend:latest` for the initial smoke test. Pin an
approved immutable tag before sharing or deploying the image.

## Policy development

`make develop` clones the policy repository into
`sources/eea.waterhub.policy`. This nested checkout is ignored by the backend
repository and keeps its own Git history. The development image also installs
the package through `mxdev`, while Compose mounts the local checkout over that
editable source. Edit it directly; pushing to GitHub is not required.

After Python or ZCML changes, stop the interactive process with `Ctrl-C` and run
`./docker-entrypoint.sh start` again. Run tests and checks from another shell:

```shell
make test
make lint
make format
make shell
```

Commit policy changes from its own checkout:

```shell
cd sources/eea.waterhub.policy
git status
git add .
git commit
git push
```

Re-run `make develop` only after changing Python dependencies, `mx.ini`, or the
development Dockerfile. GenericSetup profile changes must also be reapplied to
an existing site through Site Setup, or implemented as an upgrade step.

Released backend images use the policy version pinned in `constraints.txt`.

