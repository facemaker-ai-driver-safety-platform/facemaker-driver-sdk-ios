// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "FacemakerDriverSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "FacemakerDriverSDK", targets: ["FacemakerDriverSDK", "FacemakerTransport", "FacemakerEngine"]),
        .library(name: "FacemakerDriverSDKUI", targets: ["FacemakerDriverSDKUI", "FacemakerDriverSDK", "FacemakerTransport", "FacemakerEngine"])
    ],
    targets: [
        .binaryTarget(name: "FacemakerEngine", url: "https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios/releases/download/0.1.1/FacemakerEngine.xcframework.zip", checksum: "63a603a07c69b26987b42b3408d6d286c9b2d31464c9361b520998fb1a989d4e"),
        .binaryTarget(name: "FacemakerTransport", url: "https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios/releases/download/0.1.1/FacemakerTransport.xcframework.zip", checksum: "a348f3f7ffa7c9f5b133a90552edb6b8dfcee37b9ed23551c5a7ccf60dac5dc5"),
        .binaryTarget(name: "FacemakerDriverSDK", url: "https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios/releases/download/0.1.1/FacemakerDriverSDK.xcframework.zip", checksum: "a83ae750e0bc50ae0dc40cfe8f65ab5caf8be38c024eb5302396d913f79e18db"),
        .binaryTarget(name: "FacemakerDriverSDKUI", url: "https://github.com/facemaker-ai-driver-safety-platform/facemaker-driver-sdk-ios/releases/download/0.1.1/FacemakerDriverSDKUI.xcframework.zip", checksum: "ff25f651a5612d2633d28b20693dee7f5921295186841c0ac4275af4480775be")
    ]
)
