# Contributing

This repository coordinates upstream source checkouts. Please keep changes to the lockfile, bootstrap scripts, workspace documentation and build helpers here.

For application behavior, UI, playback, server behavior or platform packaging, submit changes to the corresponding upstream NuvioMedia repository so the original maintainers can review them in the right project.

Before changing an upstream pin:

- Confirm the target branch and full commit SHA.
- Review the upstream changes and license notices.
- Run `./scripts/validate-manifest.sh`.
- Bootstrap the changed source and run `./scripts/verify.sh`.
- Record actual build/test results; do not report a platform as validated if its required SDK or device was unavailable.
