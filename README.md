# Nuvio Multiplatform Workspace

> **Community-maintained source aggregator — not an official NuvioMedia repository.** Nuvio and related names belong to their respective owners. This repository does not claim affiliation with or endorsement by NuvioMedia.

This workspace collects the official public Nuvio source repositories at **pinned upstream commits**. The platform applications remain separate because they use different runtimes and platform SDKs. One bootstrap command checks out their source into `upstream/` and `references/` without rewriting upstream history or flattening their licensing.

**Important:** the ZIP/repository itself contains the workspace tooling and lockfile, not the hundreds of megabytes of upstream application code. Run the bootstrap step below to download the actual source repositories. `NuvioMobile`, `NuvioDesktop`, and `NuvioTV` are large projects; allow substantial disk space and network usage.

## Included platform source

| Target | Upstream source | Technology / notes |
|---|---|---|
| Android phone / tablet | `upstream/mobile` | Kotlin Multiplatform + Compose Multiplatform |
| iPhone / iPad | `upstream/mobile` | Kotlin Multiplatform + Compose Multiplatform; build requires macOS + Xcode |
| Windows / macOS / Linux desktop | `upstream/desktop` | Kotlin Multiplatform + Compose Multiplatform; upstream currently labels this app **alpha / testers only** |
| Android TV | `upstream/android-tv` | Kotlin, Jetpack Compose, TV Material 3, Media3 |
| Samsung Tizen TV | `upstream/smart-tv` | Shared JavaScript / HTML / CSS TV client; packages as WGT |
| LG webOS TV | `upstream/smart-tv` | Same shared TV client; packages as IPK |
| Self-hosted account / sync backend | `upstream/backend` | Docker Compose deployment with gateway, dashboard, auth, PostgreSQL and storage |
| Native torrent streaming | `upstream/engine` | C++20 + libtorrent; upstream says it is under active development and not production-ready |
| Native playback support | `upstream/mpvkit` | MPVKit / FFmpeg integration; LGPL by default, GPL when built with its GPL option |
| Usenet engine | `upstream/usenet-engine` | Separate Nuvio engine source |
| Speech model assets | `upstream/speech-models` | Auxiliary model repository; optional checkout |

The separate TV installer and lightweight Tizen/webOS wrappers are listed under `references/`. Their upstream repositories did not expose a `LICENSE` file at the pinned revision when this workspace was prepared. They are **not fetched by default**; use `--include-references` only for local inspection and resolve licensing before redistributing or publishing their contents.

## Quick start

Requirements: Git 2.30+, Bash (Linux/macOS/Git Bash) or PowerShell 7+ (Windows). Git LFS is recommended for any upstream content stored with LFS. Platform-specific SDKs are required to build individual applications.

### Linux / macOS / Git Bash

```bash
./scripts/bootstrap.sh
./scripts/verify.sh
```

Fetch the optional model repository too:

```bash
./scripts/bootstrap.sh --include-optional
```

Fetch the no-license-file reference repositories for local inspection only:

```bash
./scripts/bootstrap.sh --include-references
```

Fetch everything:

```bash
./scripts/bootstrap.sh --all
```

### Windows PowerShell

```powershell
.\scripts\bootstrap.ps1
.\scripts\verify.ps1
```

Optional arguments:

```powershell
.\scripts\bootstrap.ps1 -IncludeOptional
.\scripts\bootstrap.ps1 -IncludeReferences
.\scripts\bootstrap.ps1 -All
```

All checkouts are pinned to the commit SHAs in [`UPSTREAMS.lock`](UPSTREAMS.lock). The bootstrap scripts do not automatically overwrite an existing checkout or local modifications. To recreate one upstream folder, remove that folder and rerun bootstrap.

## Build commands

Run commands from this workspace root. The equivalent commands are also available as `make` targets on Linux/macOS with GNU Make.

```bash
# Android mobile app
make build-mobile-android

# iOS simulator app (macOS + Xcode)
make build-mobile-ios

# Desktop app (current host)
make run-desktop

# Android TV app
make build-android-tv

# Shared Tizen / webOS TV client
make build-smart-tv
make package-tizen
make package-webos

# Native torrent engine tests
make test-engine

# Backend setup help
make backend-help
```

If GNU Make is unavailable, use the direct Gradle / npm / CMake commands documented in [`docs/build-matrix.md`](docs/build-matrix.md).

## Architecture

```text
Nuvio Multiplatform Workspace
├── upstream/
│   ├── mobile/          # Android + iOS
│   ├── desktop/         # Windows + macOS + Linux
│   ├── android-tv/      # Android TV
│   ├── smart-tv/        # shared Samsung Tizen + LG webOS client
│   ├── backend/         # self-host deployment
│   ├── engine/          # C++ torrent streaming engine
│   ├── mpvkit/          # native playback libraries
│   └── usenet-engine/   # Usenet engine
└── references/          # optional wrappers / repos needing license review
```

This is intentionally an **upstream-preserving workspace**, not a new single-codebase rewrite. Platform-specific source remains buildable using its own upstream Gradle, npm, Xcode, CMake and Docker workflows. This avoids pretending that a browser client can replace native media playback, TV remote handling, Apple frameworks, or native streaming engines.

## Update / reproducibility

1. Review the upstream repository and its active branch.
2. Select the new source commit SHA.
3. Update the matching row in `UPSTREAMS.lock` (branch and SHA together).
4. Delete only that local checkout under `upstream/` or `references/`.
5. Run bootstrap and verify again.
6. Record platform build/test results in the pull request.

Do not use a moving branch head as a reproducible build input. Do not merge changes from one platform repository into another without checking the upstream project structure and licensing first.

## License summary

The workspace scripts, lockfile, build helper and original documentation are MIT-licensed; see [`LICENSE`](LICENSE). **That MIT license does not apply to downloaded upstream projects.** Each checked-out repository keeps its own license and copyright notices. See [`docs/licensing.md`](docs/licensing.md) before mirroring, modifying, packaging or redistributing the combined source.

## Upstream links

- [NuvioMobile](https://github.com/NuvioMedia/NuvioMobile)
- [NuvioDesktop](https://github.com/NuvioMedia/NuvioDesktop)
- [NuvioTV](https://github.com/NuvioMedia/NuvioTV)
- [NuvioTVSmart](https://github.com/NuvioMedia/NuvioTVSmart)
- [self-host](https://github.com/NuvioMedia/self-host)
- [nuvio-engine](https://github.com/NuvioMedia/nuvio-engine)
- [MPVKit](https://github.com/NuvioMedia/MPVKit)
- [nuvio-usenet-engine](https://github.com/NuvioMedia/nuvio-usenet-engine)
- [speech-models](https://github.com/NuvioMedia/speech-models)
