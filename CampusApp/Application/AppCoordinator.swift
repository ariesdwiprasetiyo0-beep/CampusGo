import SwiftUI

// MARK: - App Root: TabView Navigation
// Uses TabView as the top-level navigation pattern per Apple HIG.
// Each tab owns its own NavigationStack for independent navigation stacks.

@MainActor
struct AppCoordinator: View {
    let container: DIContainer

    var body: some View {
        if #available(iOS 18.0, *) {
            TabView {
                Tab("Jadwal", systemImage: "calendar") {
                    NavigationStack {
                        TimetableView(viewModel: container.makeTimetableViewModel())
                    }
                }
                
                Tab("Event", systemImage: "ticket") {
                    NavigationStack {
                        EventListingView(viewModel: container.makeEventListingViewModel())
                    }
                }
                
                Tab("Peta", systemImage: "map") {
                    NavigationStack {
                        CampusMapView()
                    }
                }
                
                Tab("Kartu Mahasiswa", systemImage: "person.crop.rectangle") {
                    NavigationStack {
                        StudentIDView(viewModel: container.makeStudentIDViewModel())
                    }
                }
            }
            .tint(.appAccent)
        } else {
            // Fallback on earlier versions
        }
    }
}
