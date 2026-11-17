# Changelog

All notable changes to the WaterHub backend image are documented in this file.

## Unreleased

- Pin `collective.volto.formsupport` 3.3.3 for the contact form and
  Friendly Captcha support.
- Use released `eea.waterhub.policy`.
- Add Betterleaks secret scanning and repository-specific detection rules.
- Add project instructions, release documentation, changelog, and MIT license.
- Add a deterministic policy quality-gate image and matching local commands.
- Test `eea.waterhub.policy` with Ruff, pytest, coverage, and package validation.
- Add editable `eea.waterhub.policy` development through `mxdev`.
- Build the development image from the self-contained `develop/` directory on
  top of the production image, with separate development requirements.

Release entries should use the release tag as their heading and summarize
changes since the previous tag. Keep new work under `Unreleased` until a
release is prepared.
