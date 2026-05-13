import SwiftUI
import SwiftData

// MARK: - Build Configuration
// Set `useMockData = true` for local development / previews.
// Set to `false` to use real SwiftData + CoreData + API repositories.
private let useMockData = true

@MainActor
final class DIContainer {
    // MARK: - Infrastructure (only used when useMockData == false)

    private var modelContainer: ModelContainer?
    private var coreDataStack: CoreDataStack?
    private var apiClient: APIClient?
    private var keychainService: KeychainService?

    // MARK: - Init

    init() throws {
        if !useMockData {
            modelContainer = try ModelContainer(for:
                TimetableEntrySD.self,
                CampusEventSD.self
            )
            coreDataStack = CoreDataStack(name: "CampusApp")
            apiClient = APIClient(baseURL: URL(string: "https://api.campus.edu/v1")!)
            keychainService = KeychainService()
        }
    }

    // MARK: - Repositories

    func makeTimetableRepository() -> TimetableRepository {
        if useMockData {
            return MockTimetableRepository()
        }
        return TimetableRepositoryImpl(modelContext: modelContainer!.mainContext)
    }

    func makeEventRepository() -> EventRepository {
        if useMockData {
            return MockEventRepository()
        }
        return EventRepositoryImpl(modelContext: modelContainer!.mainContext)
    }

    func makeStudentRepository() -> StudentRepository {
        if useMockData {
            return MockStudentRepository()
        }
        return StudentRepositoryImpl(
            context: coreDataStack!.viewContext,
            keychain: keychainService!
        )
    }

    func makeTicketRepository() -> TicketRepository {
        if useMockData {
            return MockTicketRepository()
        }
        return TicketRepositoryImpl(
            context: coreDataStack!.viewContext,
            apiClient: apiClient!
        )
    }

    // MARK: - Use Cases

    func makeFetchTimetableUseCase() -> FetchTimetableUseCase {
        FetchTimetableUseCaseImpl(repository: makeTimetableRepository())
    }

    func makeGetEventsUseCase() -> GetEventsUseCase {
        GetEventsUseCaseImpl(repository: makeEventRepository())
    }

    func makeGetStudentProfileUseCase() -> GetStudentProfileUseCase {
        GetStudentProfileUseCaseImpl(repository: makeStudentRepository())
    }

    func makeSubmitTicketUseCase() -> SubmitTicketUseCase {
        SubmitTicketUseCaseImpl(repository: makeTicketRepository())
    }

    // MARK: - ViewModels

    func makeTimetableViewModel() -> TimetableViewModel {
        TimetableViewModel(useCase: makeFetchTimetableUseCase())
    }

    func makeEventListingViewModel() -> EventListingViewModel {
        EventListingViewModel(useCase: makeGetEventsUseCase())
    }

    func makeStudentIDViewModel() -> StudentIDViewModel {
        StudentIDViewModel(useCase: makeGetStudentProfileUseCase())
    }
}
