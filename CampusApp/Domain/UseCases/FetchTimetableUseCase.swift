import Foundation

protocol FetchTimetableUseCase {
    func execute(from start: Date, to end: Date) async throws -> [TimetableEntry]
}

final class FetchTimetableUseCaseImpl: FetchTimetableUseCase {
    private let repository: TimetableRepository

    init(repository: TimetableRepository) {
        self.repository = repository
    }

    func execute(from start: Date, to end: Date) async throws -> [TimetableEntry] {
        return try await repository.fetchEntries(from: start, to: end)
    }
}
