# Platform build matrix

Run `./scripts/bootstrap.sh` first. Commands below run from the workspace root. Build support is inherited from the pinned upstream project; this aggregator does not replace its platform SDK requirements.

| Target | Command | Required environment |
|---|---|---|
| Android mobile | `cd upstream/mobile && ./gradlew :androidApp:assembleFullDebug` | Android Studio, JDK, Android SDK |
| iOS mobile | See command below | macOS, Xcode |
| Desktop run | `cd upstream/desktop && ./gradlew :composeApp:run` | JDK and host toolchain; Windows use `gradlew.bat` |
| Android TV | `cd upstream/android-tv && ./gradlew :app:assembleFullDebug` | Android Studio, JDK, Android SDK |
| Tizen / webOS web app | `cd upstream/smart-tv && npm ci && npm run build` | Node.js and npm |
| Tizen WGT | `cd upstream/smart-tv && npm run package:tizen` | Node.js/npm; Tizen Studio for signing/store builds |
| webOS IPK | `cd upstream/smart-tv && npm run package:webos` | Node.js/npm and webOS CLI tools |
| Engine tests | `cd upstream/engine && cmake --preset dev && cmake --build --preset dev && ctest --preset dev` | CMake, Ninja and C++20 toolchain |
| Self-host backend | See `upstream/backend/README.md` | 64-bit Linux server, Docker Engine + Compose v2, HTTPS domain or external proxy |

## iOS simulator build

```bash
cd upstream/mobile
env NUVIO_IOS_DISTRIBUTION=full xcodebuild \
  -project iosApp/iosApp.xcodeproj \
  -scheme iosApp \
  -configuration Debug \
  -sdk iphonesimulator \
  -derivedDataPath build/ios-derived-full-simulator \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Desktop packaging

The desktop upstream currently describes itself as alpha software for testers. See its README before relying on it. Typical host packaging commands include:

```bash
cd upstream/desktop
./gradlew :composeApp:packageReleaseDistributionForCurrentOS
```

For Windows PowerShell, use `.`\gradlew.bat :composeApp:packageReleaseMsi --rerun-tasks` from the upstream desktop directory.

## Backend local setup

Follow the backend README and security documentation. The upstream's recommended public deployment uses a real domain and HTTPS; do not expose development ports directly to the internet. For local development, follow its local-mode steps and keep secrets in local environment files that are not committed.

## Platform feature caveats

- The shared Tizen / webOS client has OS-version-dependent capabilities. The upstream README documents Tizen 4+ and webOS 5+ baselines and differences for torrent/P2P and plugin services.
- The Android TV app is a distinct project from the mobile client.
- The C++ Nuvio Engine README says the project is actively developed and not yet production-ready.
- MPVKit defaults to LGPL; enabling its optional GPL build changes the resulting bundle's license to GPL.
