import SwiftUI
import CoreLocation
import FacemakerDriverSDK
import FacemakerDriverSDKUI
import FacemakerEngine

@main struct SDKSampleApp: App {
    var body: some Scene { WindowGroup { SampleView() } }
}

// Integration example only. SDK implementation is supplied by binary frameworks.
final class SampleModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var endpoint = "https://tfkff2jhji.execute-api.ap-northeast-2.amazonaws.com/api"
    @Published var appId = ""
    @Published var companyId = ""
    @Published var userId = ""
    @Published var bearer = ""
    @Published var installationId = UUID().uuidString.lowercased()
    @Published var backgroundLocation = false
    @Published var status = "Enter your authorized SDK connection. No credentials are included."
    @Published var running = false
    @Published var emoji: EmojiState?
    private let permission = CLLocationManager()
    private var sdk: FacemakerDriverSDK?
    override init() { super.init(); permission.delegate = self }
    func start() {
        guard !running else { return }
        guard let url = URL(string: endpoint), !appId.isEmpty, !companyId.isEmpty, !userId.isEmpty, !installationId.isEmpty, !bearer.isEmpty else {
            status = "Fill in the endpoint, app ID, company ID, user ID and SDK bearer token."; return
        }
        if permission.authorizationStatus == .notDetermined { permission.requestWhenInUseAuthorization(); return }
        guard permission.authorizationStatus == .authorizedWhenInUse || permission.authorizationStatus == .authorizedAlways else {
            status = "Allow location access in Settings, then tap Start trip."; return
        }
        do {
            // This sample uses a single short-lived token kept only in memory.
            // A production host supplies its own backend-backed refresh provider.
            let token = bearer
            if let old = sdk { old.close(); sdk = nil }
            let config = try Configuration(environment: .development, endpoint: url, appId: appId,
                appVersion: "0.1.1-sample", backgroundLocationEnabled: backgroundLocation)
            let client = try FacemakerDriverSDK(configuration: config) { _, forceRefresh in forceRefresh ? nil : token }
            client.onStatus = { [weak self] in self?.status = "SDK: " + $0 }
            client.onUploadStatus = { [weak self] in self?.status = "Upload: " + $0 }
            client.onEmoji = { [weak self] in self?.emoji = $0 }
            client.onEvent = { [weak self] in self?.status = "Event: " + $0.type }
            try client.bindUser(UserScope(companyId: companyId, externalUserId: userId, installationId: installationId))
            sdk = client
            _ = try client.startTrip(); running = true; status = "Trip started."
        } catch { sdk?.close(); sdk = nil; status = "Could not start: \(error)" }
    }
    func end() {
        do { try sdk?.endTrip(); running = false; status = "Trip ended. Pending uploads continue while the SDK is open." }
        catch { status = "Could not end: \(error)" }
    }
    func close() { sdk?.close(); sdk = nil; running = false; emoji = nil; bearer = ""; status = "SDK closed. Token cleared." }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { status = "Location permission updated. Tap Start trip when ready." }
}

struct SampleView: View {
    @StateObject private var model = SampleModel()
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Authorized development connection")) {
                    TextField("API endpoint (ending in /api)", text: $model.endpoint)
                    TextField("Registered app ID", text: $model.appId)
                    TextField("Company ID", text: $model.companyId)
                    TextField("External user ID", text: $model.userId)
                    TextField("Token-bound installation ID", text: $model.installationId)
                    SecureField("Short-lived SDK bearer token", text: $model.bearer)
                    Toggle("Request background location capture", isOn: $model.backgroundLocation)
                }.disabled(model.running).textInputAutocapitalization(.never).disableAutocorrection(true)
                Section(header: Text("Trip")) {
                    Button("Start trip", action: model.start).disabled(model.running)
                    Button("End trip", action: model.end).disabled(!model.running)
                    Button("Close SDK and clear token", action: model.close)
                    Text(model.status).font(.footnote)
                }
                Section(header: Text("In-app SDK view")) {
                    if let emoji = model.emoji { SDKFace(state: emoji).frame(height: 150) }
                    else { Text("A status view appears after the SDK reports a state.").foregroundColor(.secondary) }
                }
            }.navigationTitle("Facemaker SDK Sample")
        }
    }
}
struct SDKFace: UIViewRepresentable {
    let state: EmojiState
    func makeUIView(context: Context) -> EmojiView { EmojiView(frame: .zero) }
    func updateUIView(_ view: EmojiView, context: Context) { view.render(state) }
}
