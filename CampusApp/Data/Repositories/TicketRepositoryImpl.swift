import Foundation
import CoreData

enum TicketError: LocalizedError {
    case submitFailed
    case fetchFailed

    var errorDescription: String? {
        switch self {
        case .submitFailed:
            return "Failed to submit ticket"
        case .fetchFailed:
            return "Failed to fetch tickets"
        }
    }
}

final class TicketRepositoryImpl: TicketRepository {
    private let context: NSManagedObjectContext
    private let apiClient: APIClient

    init(context: NSManagedObjectContext, apiClient: APIClient) {
        self.context = context
        self.apiClient = apiClient
    }

    func submit(_ ticket: HelpTicket) async throws -> HelpTicket {
        let dto = HelpTicketDTO(from: ticket)
        let submitted: HelpTicketDTO = try await apiClient.request(SubmitTicketEndpoint(ticket: dto))
        return submitted.toDomain()
    }

    func fetchAll() async throws -> [HelpTicket] {
        return try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "TicketEntity")
            let results = try self.context.fetch(request)
            return results.map { entity in
                HelpTicket(
                    id: entity.value(forKey: "id") as? UUID ?? UUID(),
                    title: entity.value(forKey: "title") as? String ?? "",
                    description: entity.value(forKey: "description") as? String ?? "",
                    category: TicketCategory(rawValue: entity.value(forKey: "category") as? String ?? "general") ?? .general,
                    status: TicketStatus(rawValue: entity.value(forKey: "status") as? String ?? "open") ?? .open,
                    createdAt: entity.value(forKey: "createdAt") as? Date ?? Date()
                )
            }
        }
    }
}

struct HelpTicketDTO: Codable {
    let id: String
    let title: String
    let description: String
    let category: String
    let status: String
    let created_at: String

    init(from domain: HelpTicket) {
        self.id = domain.id.uuidString
        self.title = domain.title
        self.description = domain.description
        self.category = domain.category.rawValue
        self.status = domain.status.rawValue
        self.created_at = ISO8601DateFormatter().string(from: domain.createdAt)
    }

    func toDomain() -> HelpTicket {
        HelpTicket(
            id: UUID(uuidString: id) ?? UUID(),
            title: title,
            description: description,
            category: TicketCategory(rawValue: category) ?? .general,
            status: TicketStatus(rawValue: status) ?? .open,
            createdAt: ISO8601DateFormatter().date(from: created_at) ?? Date()
        )
    }
}

struct SubmitTicketEndpoint: Endpoint {
    let ticket: HelpTicketDTO

    var path: String { "/tickets" }
    var method: String { "POST" }
    var queryItems: [URLQueryItem] { [] }
}
