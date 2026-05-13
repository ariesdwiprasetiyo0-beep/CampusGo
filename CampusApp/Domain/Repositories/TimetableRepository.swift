import Foundation

protocol TimetableRepository {
    func fetchEntries(from start: Date, to end: Date) async throws -> [TimetableEntry]
    func save(_ entries: [TimetableEntry]) async throws
    func deleteAll() async throws
}
