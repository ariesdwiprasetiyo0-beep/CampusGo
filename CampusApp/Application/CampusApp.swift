import SwiftUI
import SwiftData

@main
struct CampusApp: App {
    @State private var container: DIContainer

    init() {
        do {
            _container = State(initialValue: try DIContainer())
        } catch {
            fatalError("Failed to initialize DIContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinator(container: container)
        }
    }
}
