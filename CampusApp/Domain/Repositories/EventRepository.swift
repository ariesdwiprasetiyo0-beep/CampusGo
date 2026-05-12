import Foundation

protocol EventRepository {
    func fetchUpcoming(limit: Int) async throws -> [CampusEvent]
    func fetchAll() async throws -> [CampusEvent]
    func save(_ events: [CampusEvent]) async throws
}
