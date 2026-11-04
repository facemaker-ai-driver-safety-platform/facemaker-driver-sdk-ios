# iOS integration — 0.1.1

## Package products

`FacemakerDriverSDK` contains the native lifecycle API and links `FacemakerTransport` and `FacemakerEngine`. `FacemakerDriverSDKUI` additionally contains `EmojiView`. The engine and native adapters are all binary frameworks; there is no implementation-source dependency. Xcode embeds the dynamic frameworks automatically when you attach the package products to your app target.

For a Package.swift-based host:

```swift
.package(url: "https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios.git", exact: "0.1.1")
// In your target dependencies:
.product(name: "FacemakerDriverSDK", package: "facemaker-driver-sdk-ios"),
.product(name: "FacemakerDriverSDKUI", package: "facemaker-driver-sdk-ios") // optional
```

## Host setup

Use iOS 15 or later and an arm64 build. Include `NSLocationWhenInUseUsageDescription` and `NSMotionUsageDescription` in your app's Info.plist. The host owns permission prompts. The SDK reports unavailable/permission states rather than manufacturing valid detector data. For the optional background-location mode, enable `UIBackgroundModes: location` and the host's appropriate location permission flow; uninterrupted execution after termination or arbitrary background suspension is not guaranteed.

Construct and control the SDK on the main thread. Keep one live instance. Supply a registered app ID, a server-authorized company/external-user identity and a stable per-install identifier.

```swift
import FacemakerDriverSDK
import FacemakerEngine

let configuration = try Configuration(
    environment: .development,
    endpoint: URL(string: "https://tfkff2jhji.execute-api.ap-northeast-2.amazonaws.com/api")!,
    appId: registeredAppId,
    appVersion: hostVersion,
    backgroundLocationEnabled: false
)
let sdk = try FacemakerDriverSDK(configuration: configuration) { identity, forceRefresh in
    // Called on the SDK upload queue, not the main thread.
    // Return a valid scoped SDK token from your host backend/token store.
    // On forceRefresh, obtain a new token; return nil when reauthentication is needed.
    tokenProvider(identity, forceRefresh)
}
sdk.onEvent = { event in /* update your app with event.type */ }
sdk.onEmoji = { state in /* update your in-app view */ }
sdk.onStatus = { status in /* input/SDK lifecycle state */ }
sdk.onUploadStatus = { state in /* idle/uploading/waiting/reauthentication_required/rejected */ }
try sdk.bindUser(UserScope(companyId: companyId, externalUserId: userId, installationId: installId))
let tripId = try sdk.startTrip(externalTripId: hostTripId)
// When the host ends the trip:
try sdk.endTrip()
// Keep the SDK open if pending uploads should continue. Close when done:
sdk.getUploadStatus { snapshot in /* snapshot.pendingCount, blockedCount, state */ }
// sdk.close()
```

Never put partner secrets, admin credentials or long-lived master tokens in an iOS app. The host's backend issues the identity/app/environment-scoped token. Use `.production` and your assigned production API endpoint for production scopes. A copied bearer alone does not provide indefinite authentication; the sample deliberately uses a short-lived, memory-only token.

## Emoji view (optional)

```swift
import FacemakerDriverSDKUI
let view = EmojiView(frame: .zero)
sdk.onEmoji = { state in view.render(state) } // callbacks arrive on main
```

Place this UIView inside your app, or use the UIViewRepresentable wrapper in the sample. It does not float over other iOS apps. The approved artwork is bundled in the UI binary framework. Missing rest data is represented as unmeasured/information; the SDK does not fabricate sleep records or claim to read Apple Health data.

## Sensors and lifecycle

The shared engine contains the current sustained drowsiness window, fresh GPS requirements, repeated-warning state and phone-mount stabilization/normal-turn handling. The iOS adapter converts native Core Motion/Location values and timestamps into the shared coordinate/time model. Optional display diagnostics are throttled independently from detector inputs.

`startTrip` / `endTrip` are explicit host actions on iOS. If your app decides trip boundaries automatically, integrate those host decisions with the same lifecycle calls. Permission loss, stale GPS and unstable mount quality must be shown as unavailable/unmeasured, not as a safe-driving result. Keep the phone stably mounted; phone motion can obscure vehicle motion.

The local queue isolates identities, retries transient failures, refreshes once on 401, and acknowledges only matching server record IDs. End the active trip before switching or unbinding users. Observe upload status independently from recording status. `close` stops sensor capture; it is not a promise to drain all network records first. The host remains responsible for tokens and authorization.

## Updating

Pin exact version 0.1.1 to reproduce this release. When upgrading, let Xcode resolve the new tag and binary checksums. Do not mix frameworks from different releases. Do not copy the SDK's internal implementation from a source checkout.
