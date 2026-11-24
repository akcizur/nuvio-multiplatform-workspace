# Licensing and redistribution notes

This workspace intentionally keeps upstream projects separate. Its root `LICENSE` covers only the scripts, Makefile, lockfile and original documentation created for this aggregator. It does **not** relicense any upstream application, engine, asset, logo or dependency.

## Licenses observed at the pinned revisions

| Component | Observed license | Important note |
|---|---|---|
| NuvioMobile | GPL-3.0 | Preserve upstream copyright and GPL notices. |
| NuvioDesktop | GPL-3.0 | Preserve upstream copyright and GPL notices. |
| NuvioTV | GPL-3.0 | Preserve upstream copyright and GPL notices. |
| NuvioTVSmart | GPL-3.0 | Shared TV source for Tizen and webOS. |
| self-host | Apache-2.0 | Keep `NOTICE` and Apache license obligations. |
| nuvio-engine | GPL-3.0-or-later | Also review `THIRD_PARTY_NOTICES.md`; dependencies have separate licenses. |
| MPVKit | LGPL-3.0 | Its README states that enabling the GPL build option changes the bundle to GPL-3.0. |
| nuvio-usenet-engine | GPL-3.0 | Keep its upstream license and notices. |
| speech-models | Apache-2.0 | Check model-specific documentation and asset terms before redistribution. |

## Repositories without a discovered root LICENSE file

At the pinned revision, no root `LICENSE` file was found for `NuvioTVSmart-Installer`, `NuvioTVWebOS`, `NuvioTizen`, `NuvioTVTizenBrew`, or `nuvio-libass`. Their source is therefore marked `NO-LICENSE-FILE` and excluded from default bootstrap. The absence of a license file does not mean the source is public domain or automatically reusable. Obtain clarification or permission from the relevant rights holder before copying, modifying for redistribution, or publishing these sources in a public mirror.

## Before publishing a mirror or binary

1. Preserve the upstream repository's original license, copyright headers, notices and attribution.
2. Keep each independently licensed component identifiable; do not replace all licenses with the workspace MIT license.
3. Review transitive/native dependencies, bundled binaries, fonts, images, codecs, models and platform SDK conditions separately.
4. For GPL-covered combined or modified distributions, satisfy the applicable source-code, license-copy and notice requirements. This document is not legal advice.
5. Review MPVKit's LGPL/GPL build selection and the Nuvio Engine third-party notices for the exact build configuration you ship.

The license names in `UPSTREAMS.lock` are a snapshot from the pinned commits checked on 2026-11-24. Recheck upstream license files before every new release or redistribution.
