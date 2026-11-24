SHELL := /bin/bash

.PHONY: bootstrap verify validate build-mobile-android build-mobile-ios run-desktop build-android-tv build-smart-tv package-tizen package-webos test-smart-tv test-engine backend-help

bootstrap:
	./scripts/bootstrap.sh

verify:
	./scripts/verify.sh

validate:
	./scripts/validate-manifest.sh

build-mobile-android:
	cd upstream/mobile && ./gradlew :androidApp:assembleFullDebug

build-mobile-ios:
	cd upstream/mobile && env NUVIO_IOS_DISTRIBUTION=full xcodebuild -project iosApp/iosApp.xcodeproj -scheme iosApp -configuration Debug -sdk iphonesimulator -derivedDataPath build/ios-derived-full-simulator CODE_SIGNING_ALLOWED=NO build

run-desktop:
	cd upstream/desktop && ./gradlew :composeApp:run

build-android-tv:
	cd upstream/android-tv && ./gradlew :app:assembleFullDebug

build-smart-tv:
	cd upstream/smart-tv && npm ci && npm run build

package-tizen:
	cd upstream/smart-tv && npm ci && npm run package:tizen

package-webos:
	cd upstream/smart-tv && npm ci && npm run package:webos

test-smart-tv:
	cd upstream/smart-tv && npm ci && npm test

test-engine:
	cd upstream/engine && cmake --preset dev && cmake --build --preset dev && ctest --preset dev

backend-help:
	@echo "See docs/build-matrix.md and upstream/backend/README.md. A public HTTPS domain is needed for the recommended deployment."
