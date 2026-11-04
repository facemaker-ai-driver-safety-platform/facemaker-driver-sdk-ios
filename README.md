# Facemaker AI Driver Safety Platform — iOS SDK

Version **0.1.1**. Binary-only SDK for iOS apps, distributed with Swift Package Manager.
The SDK implementation sources are not included. Public module interfaces and integration sample source are included as required for installation and use. Binary distribution does not prevent reverse engineering.

## Install in Xcode

1. Choose **File → Add Package Dependencies**.
2. Enter `https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios.git` and select **Exact Version: 0.1.1**.
3. Add `FacemakerDriverSDK` for the base SDK. Add `FacemakerDriverSDKUI` if your app displays the optional in-app emoji view.

```swift
import FacemakerDriverSDK
import FacemakerEngine
// Optional: import FacemakerDriverSDKUI
```

Each product carries its complete binary link/embed dependencies. The package downloads four release XCFrameworks with pinned SHA256 checksums. No private source repository or Maven access is required.

- [iOS integration guide](Documentation/IOS.md)
- [Buildable SwiftUI sample](Example/README.md)
- [Release notes](CHANGELOG.md)
- [Release files](https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios/releases/tag/0.1.1)

## Requirements

- iOS 15 or later; arm64 physical devices and arm64 Apple Silicon simulator build slices.
- Built with Xcode 27.2, Swift 6.4.2 in Swift 5 language mode and library evolution enabled; shared Kotlin/Native engine 2.2.21.
- Intel simulator and older Xcode toolchains are not part of this release's verified matrix. No guarantee of backwards compiler compatibility is made.
- The host provides location/motion permissions and authorized scoped SDK tokens. No test accounts, credentials, administrator sessions or backend secrets are shipped.

The SDK emits sensor-based driving risk events; it does not use a camera or facial recognition. The optional UI is a view inside the host app, not a system-wide floating overlay.

## Verification

The release binaries are built from the current shared detection engine, including GPS freshness, sustained-event and repeated-warning controls, phone-mount stability and turn compensation, and bounded optional diagnostics. iOS trip start/end is controlled by the host through `startTrip` / `endTrip`; no claim of a new iOS automatic-trip controller is made.

Compilation/package validation does not constitute a new physical-device or road-driving test. Backend acceptance requires partner-specific app/user scopes.

## License and contact

Proprietary SDK; usage and redistribution require a separate agreement with MoveMyBicycle. See [LICENSE.txt](LICENSE.txt). Contact: develop@movemybicycle.com.
