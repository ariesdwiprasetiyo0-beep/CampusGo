import Foundation

enum EventCategory: String, Codable {
    case orientation = "orientation"
    case academic = "academic"
    case cultural = "cultural"
    case sports = "sports"
}

struct CampusEvent: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let location: String
    let category: EventCategory
}
