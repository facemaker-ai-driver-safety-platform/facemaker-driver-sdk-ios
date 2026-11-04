# SwiftUI integration sample

Open `FacemakerSDKSample.xcodeproj` in Xcode. Resolve the public SPM package at exact version 0.1.1, select your signing team and a compatible arm64 iPhone, then build/run. This source demonstrates only host integration; the SDK itself is downloaded as binary XCFrameworks.

Enter your authorized development endpoint, registered app ID, company ID, external user ID, token-bound installation ID and short-lived SDK bearer token. The installation ID must match the identity used when the backend issued the token; replace the displayed example UUID if needed. Obtain these through your integration contact/host backend. No credentials are included. The token stays in memory and is cleared by Close SDK; the sample does not implement a partner login backend or persistent token refresh. Stop the trip and close before changing the connection. Keep the SDK open after End trip to allow queued uploads; an immediate Close stops active work. No live server data is created by simply opening/building this example.

Allow location and motion permissions. The default mode is foreground capture; only enable background-location capture if your app requires it. Start trip, observe SDK/upload state and in-app EmojiView, then End trip. Configure a different app bundle identifier if your signing team requires it.

On an arm64 simulator you can validate build/layout; simulated sensor/location input is not real driving evidence. This release was checked with generic destination builds without starting a simulator or accessing a phone.

Command-line build (unsigned device target, requires Xcode and public network access):

```sh
xcodebuild -project FacemakerSDKSample.xcodeproj -scheme FacemakerSDKSample \
  -configuration Release -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO build
```
