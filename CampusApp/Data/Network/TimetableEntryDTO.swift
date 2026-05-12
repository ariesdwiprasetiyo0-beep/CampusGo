import Foundation

struct TimetableEntryDTO: Codable {
    let id: String
    let subject_code: String
    let subject_name: String
    let room: String
    let start_time: String
    let end_time: String
    let lecturer_name: String

    func toDomain() -> TimetableEntry {
        TimetableEntry(
            id: UUID(uuidString: id) ?? UUID(),
            subjectCode: subject_code,
            subjectName: subject_name,
            room: room,
            startTime: ISO8601DateFormatter().date(from: start_time) ?? Date(),
            endTime: ISO8601DateFormatter().date(from: end_time) ?? Date(),
            lecturer: lecturer_name
        )
    }
}
