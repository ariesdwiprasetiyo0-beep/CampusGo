import SwiftData

@Model
final class TimetableEntrySD {
    var id: UUID
    var subjectCode: String
    var subjectName: String
    var room: String
    var startTime: Date
    var endTime: Date
    var lecturer: String

    init(from domain: TimetableEntry) {
        self.id = domain.id
        self.subjectCode = domain.subjectCode
        self.subjectName = domain.subjectName
        self.room = domain.room
        self.startTime = domain.startTime
        self.endTime = domain.endTime
        self.lecturer = domain.lecturer
    }

    func toDomain() -> TimetableEntry {
        TimetableEntry(
            id: id,
            subjectCode: subjectCode,
            subjectName: subjectName,
            room: room,
            startTime: startTime,
            endTime: endTime,
            lecturer: lecturer
        )
    }
}
