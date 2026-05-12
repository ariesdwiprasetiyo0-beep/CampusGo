import SwiftData

@Model
final class CampusEventSD {
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var location: String
    var category: String

    init(from domain: CampusEvent) {
        self.id = domain.id
        self.title = domain.title
        self.description = domain.description
        self.date = domain.date
        self.location = domain.location
        self.category = domain.category.rawValue
    }

    func toDomain() -> CampusEvent {
        CampusEvent(
            id: id,
            title: title,
            description: description,
            date: date,
            location: location,
            category: EventCategory(rawValue: category) ?? .academic
        )
    }
}
