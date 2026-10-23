# Release

WaterHub backend releases are intended to follow the standard EEA Plone
backend flow: Jenkins verifies the repository, creates a GitHub tag/release,
and publishes the corresponding `eeacms/waterhub-backend` image to Docker Hub.

Release automation is not active until the Jenkins job, credentials, and
publishing permissions listed below have been confirmed.

## Release preparation

1. Update `CHANGELOG.md`, moving completed entries from `Unreleased` under the
   proposed release tag.
2. Pin released dependency versions in `constraints.txt`; do not publish an
   image from an unreviewed policy branch or editable checkout.
3. Run the complete local preflight:

   ```shell
   make ci
   make build IMAGE=waterhub-backend TAG=release-candidate
   ```

4. Run the approved Trivy preflight against the release-candidate image. Add a
   `.trivyignore` entry only for a reviewed, unfixed critical CVE and document
   why it is accepted.
5. Open a pull request to the protected default branch and obtain the required
   review and successful quality checks.

## Intended automated flow

After the EEA pipeline is enabled:

1. The default-branch Jenkins job runs the same test-image commands exposed by
   `make ci` and performs SonarQube and release-image checks.
2. The approved release job creates the GitHub tag and release.
3. A tag build publishes `eeacms/waterhub-backend:<tag>` to Docker Hub using
   Jenkins-managed credentials.
4. Deployment automation, if approved for WaterHub, consumes that immutable
   image tag through the relevant Rancher, Helm, or Fleet repository.

Do not create or push release tags manually once Jenkins owns this flow.

## Infrastructure values to confirm

Before implementing or enabling the release pipeline, obtain:

- Jenkins multibranch and release job names/URLs
- SonarQube project key and display name
- Jenkins GitHub, SonarQube, and Docker Hub credential IDs
- CI notification address
- Docker Hub publishing permission for `eeacms/waterhub-backend`
- Default-branch and tag naming rules
- Whether arm64 images are required
- Whether Rancher, Helm, or Fleet release automation is required

Record operational identifiers in the Jenkins configuration or approved
deployment repository, not in this document when they contain secrets.
