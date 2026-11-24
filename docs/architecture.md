# Architecture overview

Nuvio is delivered as several cooperating codebases rather than one universal executable. This workspace mirrors that boundary instead of forcing every target into a common framework.

```text
Clients
  ├─ Mobile: Kotlin Multiplatform / Compose (Android, iOS)
  ├─ Desktop: Kotlin Multiplatform / Compose (Windows, macOS, Linux)
  ├─ Android TV: Jetpack Compose + TV Material 3 + Media3
  └─ Smart TV: shared JavaScript / HTML / CSS app
       ├─ Samsung Tizen package (WGT)
       └─ LG webOS package (IPK)

Services and native components
  ├─ Self-host deployment: gateway, dashboard, auth, PostgreSQL, storage, functions
  ├─ Nuvio Engine: C++20 torrent streaming core
  ├─ Usenet engine: separate protocol engine
  ├─ MPVKit: mpv / FFmpeg native playback libraries
  └─ Speech models: auxiliary model assets
```

The self-host README describes a single Docker Compose deployment with gateway routes to the dashboard and API, plus authentication, PostgREST, PostgreSQL, storage and edge functions. Clients use one backend URL and a discovery endpoint at `/.well-known/nuvio`.

The shared smart-TV app is the source of truth for the Tizen and webOS TV UI. Tizen and webOS packaging still needs platform-specific tooling. The Android TV app is maintained separately and has a native Android TV build.

## Why keep platform repositories separate?

The client codebases have different runtime APIs, packaging systems, device constraints, playback integrations and release workflows. Keeping exact upstream repositories intact gives a reproducible source collection without inventing an untested shared build or silently mixing platform code. A future refactor can add shared interfaces after there are passing platform tests and a clear compatibility contract.
