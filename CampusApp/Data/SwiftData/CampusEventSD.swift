import Foundation
import SwiftData

@Model
final class CampusEventSD {
    var id: UUID
    var title: String
    var eventDescription: String
    var date: Date
    var location: String
    var category: String

    init(from domain: CampusEvent) {
        self.id = domain.id
        self.title = domain.title
        self.eventDescription = domain.description
        self.date = domain.date
        self.location = domain.location
        self.category = domain.category.rawValue
    }

    func toDomain() -> CampusEvent {
        CampusEvent(
            id: id,
            title: title,
            description: eventDescription,
            date: date,
            location: location,
            category: EventCategory(rawValue: category) ?? .academic
        )
    }
}
