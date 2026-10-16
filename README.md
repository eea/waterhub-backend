# Copernicus Thematic Water Hub Backend

Plone 6 backend for WaterHub, based on the generic EEA `eeacms/plone-backend`
image. The initial scaffold intentionally contains no WaterHub policy add-on.

## Requirements

- Docker with Docker Compose
- GNU Make

## Start developing

Build the development image, then start Plone:

```shell
make develop
make start
```

On its first start, the container creates a `Plone` site using the Volto
distribution. Site state persists in the named Docker volume
`waterhub-backend-data`.

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

## Adding the policy package later

Once either `eea.waterhub.policy` or `copernicus.waterhub.policy` exists:

1. Add the package to `requirements.txt`.
2. Pin its released version in `constraints.txt`.
3. Uncomment the matching checkout in `mx.ini` for editable development.
4. Add its GenericSetup profile to `PROFILES` in `docker-compose.yml`, if it
   needs automatic installation.
5. Rebuild with `make develop`.

