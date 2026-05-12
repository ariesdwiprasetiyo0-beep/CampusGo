import Foundation

struct CampusEventDTO: Codable {
    let id: String
    let title: String
    let description: String
    let date: String
    let location: String
    let category: String

    func toDomain() -> CampusEvent {
        CampusEvent(
            id: UUID(uuidString: id) ?? UUID(),
            title: title,
            description: description,
            date: ISO8601DateFormatter().date(from: date) ?? Date(),
            location: location,
            category: EventCategory(rawValue: category) ?? .academic
        )
    }
}
