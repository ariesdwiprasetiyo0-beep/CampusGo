import Foundation

protocol GetEventsUseCase {
    func execute(upcoming limit: Int) async throws -> [CampusEvent]
}

final class GetEventsUseCaseImpl: GetEventsUseCase {
    private let repository: EventRepository

    init(repository: EventRepository) {
        self.repository = repository
    }

    func execute(upcoming limit: Int) async throws -> [CampusEvent] {
        return try await repository.fetchUpcoming(limit: limit)
    }
}
