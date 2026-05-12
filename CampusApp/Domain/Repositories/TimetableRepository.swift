import Foundation

protocol TimetableRepository {
    func fetchEntries(for week: DateInterval) async throws -> [TimetableEntry]
    func save(_ entries: [TimetableEntry]) async throws
    func deleteAll() async throws
}
