import SwiftUI
import SwiftData

@MainActor
final class DIContainer {
    // MARK: - Infrastructure

    let modelContainer: ModelContainer
    let coreDataStack: CoreDataStack
    let apiClient: APIClient
    let keychainService: KeychainService

    // MARK: - Init

    init() throws {
        modelContainer = try ModelContainer(for:
            TimetableEntrySD.self,
            CampusEventSD.self
        )
        coreDataStack = CoreDataStack(name: "CampusApp")
        apiClient = APIClient(baseURL: URL(string: "https://api.campus.edu/v1")!)
        keychainService = KeychainService()
    }

    // MARK: - Repositories

    func makeTimetableRepository() -> TimetableRepository {
        TimetableRepositoryImpl(modelContext: modelContainer.mainContext)
    }

    func makeEventRepository() -> EventRepository {
        EventRepositoryImpl(modelContext: modelContainer.mainContext)
    }

    func makeStudentRepository() -> StudentRepository {
        StudentRepositoryImpl(
            context: coreDataStack.viewContext,
            keychain: keychainService
        )
    }

    func makeTicketRepository() -> TicketRepository {
        TicketRepositoryImpl(
            context: coreDataStack.viewContext,
            apiClient: apiClient
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
