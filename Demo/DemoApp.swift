import SwiftUI
import Components

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack(spacing: 16) {
                    RDSPrimaryButton(title: "Primary Button", action: { print("Tapped") })
                    Text("Design system demo")
                }
                .padding()
                .navigationTitle("RDS Demo")
            }
        }
    }
}
