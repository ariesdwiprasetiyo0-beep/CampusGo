import Foundation

struct TimetableEntry: Identifiable, Equatable {
    let id: UUID
    let subjectCode: String
    let subjectName: String
    let room: String
    let startTime: Date
    let endTime: Date
    let lecturer: String
}
