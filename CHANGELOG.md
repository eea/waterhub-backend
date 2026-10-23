# Changelog

All notable changes to the WaterHub backend image are documented in this file.

## Unreleased

- Add Betterleaks secret scanning and repository-specific detection rules.
- Add project instructions, release documentation, changelog, and MIT license.
- Add a deterministic policy quality-gate image and matching local commands.
- Test `eea.waterhub.policy` with Ruff, pytest, coverage, and package validation.
- Pin the backend to `eeacms/plone-backend:6.1.4-16`, Plone 6.1.4, Python 3.12,
  and `eea.volto.policy` 12.7.
- Add editable `eea.waterhub.policy` development through `mxdev`.

Release entries should use the release tag as their heading and summarize
changes since the previous tag. Keep new work under `Unreleased` until a
release is prepared.
