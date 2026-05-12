import Foundation

enum TicketCategory: String, Codable {
    case academic = "academic"
    case itsupport = "itsupport"
    case facilities = "facilities"
    case general = "general"
}

enum TicketStatus: String, Codable {
    case open = "open"
    case inProgress = "in_progress"
    case resolved = "resolved"
    case closed = "closed"
}

struct HelpTicket: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var category: TicketCategory
    var status: TicketStatus
    let createdAt: Date
}
