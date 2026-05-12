import Foundation

protocol FetchTimetableUseCase {
    func execute(for week: DateInterval) async throws -> [TimetableEntry]
}

final class FetchTimetableUseCaseImpl: FetchTimetableUseCase {
    private let repository: TimetableRepository

    init(repository: TimetableRepository) {
        self.repository = repository
    }

    func execute(for week: DateInterval) async throws -> [TimetableEntry] {
        return try await repository.fetchEntries(for: week)
    }
}
