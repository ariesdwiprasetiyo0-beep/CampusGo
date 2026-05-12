import SwiftUI

@MainActor
struct AppCoordinator: View {
    let container: DIContainer

    @State private var navigationPath: NavigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 16) {
                Text("Campus App")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(spacing: 12) {
                    NavigationLink("Jadwal Kuliah", value: "timetable")
                    NavigationLink("Event", value: "events")
                    NavigationLink("Kartu Mahasiswa", value: "studentid")
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "timetable":
                    TimetableView(viewModel: container.makeTimetableViewModel())
                case "events":
                    EventListingView(viewModel: container.makeEventListingViewModel())
                case "studentid":
                    StudentIDView(viewModel: container.makeStudentIDViewModel())
                default:
                    Text("Unknown destination")
                }
            }
        }
    }
}
