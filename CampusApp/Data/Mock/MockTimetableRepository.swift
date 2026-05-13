import Foundation

// MARK: - Mock Timetable Repository
final class MockTimetableRepository: TimetableRepository {

    func fetchEntries(from start: Date, to end: Date) async throws -> [TimetableEntry] {
        try await Task.sleep(for: .milliseconds(600))

        let calendar = Calendar.current

        // Build schedule relative to the current week's Monday
        var weekStart = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        ) ?? Date()

        // Adjust to Monday if Sunday-based calendar
        let weekday = calendar.component(.weekday, from: weekStart)
        if weekday == 1 { // Sunday
            weekStart = calendar.date(byAdding: .day, value: 1, to: weekStart) ?? weekStart
        }

        func dayDate(_ daysFromMonday: Int, hour: Int, minute: Int = 0) -> Date {
            let day = calendar.date(byAdding: .day, value: daysFromMonday, to: weekStart) ?? weekStart
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
        }

        let entries: [TimetableEntry] = [
            // Monday
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3012",
                subjectName: "Pemrograman Berorientasi Objek",
                room: "Ruang 401-A",
                startTime: dayDate(0, hour: 8, minute: 0),
                endTime: dayDate(0, hour: 9, minute: 40),
                lecturer: "Dr. Budi Santoso"
            ),
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3024",
                subjectName: "Basis Data Lanjut",
                room: "Lab DB-02",
                startTime: dayDate(0, hour: 10, minute: 0),
                endTime: dayDate(0, hour: 11, minute: 40),
                lecturer: "Prof. Sri Handayani"
            ),
            // Tuesday
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3031",
                subjectName: "Jaringan Komputer",
                room: "Ruang 305-B",
                startTime: dayDate(1, hour: 13, minute: 0),
                endTime: dayDate(1, hour: 14, minute: 40),
                lecturer: "Ir. Agus Pramono, M.T."
            ),
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3045",
                subjectName: "Kecerdasan Buatan",
                room: "Ruang 502-C",
                startTime: dayDate(1, hour: 15, minute: 0),
                endTime: dayDate(1, hour: 16, minute: 40),
                lecturer: "Dr. Rini Astuti"
            ),
            // Wednesday
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3012",
                subjectName: "Pemrograman Berorientasi Objek",
                room: "Lab Pemrograman-01",
                startTime: dayDate(2, hour: 8, minute: 0),
                endTime: dayDate(2, hour: 9, minute: 40),
                lecturer: "Dr. Budi Santoso"
            ),
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3056",
                subjectName: "Pengembangan Aplikasi Mobile",
                room: "Lab Mobile-03",
                startTime: dayDate(2, hour: 10, minute: 0),
                endTime: dayDate(2, hour: 11, minute: 40),
                lecturer: "Eko Wahyu Nugroho, S.Kom., M.Cs."
            ),
            // Thursday
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3024",
                subjectName: "Basis Data Lanjut",
                room: "Ruang 401-A",
                startTime: dayDate(3, hour: 9, minute: 0),
                endTime: dayDate(3, hour: 10, minute: 40),
                lecturer: "Prof. Sri Handayani"
            ),
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3067",
                subjectName: "Rekayasa Perangkat Lunak",
                room: "Ruang 203-D",
                startTime: dayDate(3, hour: 13, minute: 0),
                endTime: dayDate(3, hour: 14, minute: 40),
                lecturer: "Dr. Hendra Kusuma"
            ),
            // Friday
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3045",
                subjectName: "Kecerdasan Buatan",
                room: "Lab AI & Data Science",
                startTime: dayDate(4, hour: 7, minute: 30),
                endTime: dayDate(4, hour: 9, minute: 10),
                lecturer: "Dr. Rini Astuti"
            ),
            TimetableEntry(
                id: UUID(),
                subjectCode: "CS3078",
                subjectName: "Etika Profesi Teknologi",
                room: "Ruang 101-A",
                startTime: dayDate(4, hour: 10, minute: 0),
                endTime: dayDate(4, hour: 11, minute: 40),
                lecturer: "Drs. Wahyu Pratama, M.M."
            ),
        ]

        // Filter by date range (inclusive)
        return entries.filter { entry in
            entry.startTime >= start && entry.startTime < end
        }
        .sorted { $0.startTime < $1.startTime }
    }

    func save(_ entries: [TimetableEntry]) async throws {
        // No-op for mock
    }

    func deleteAll() async throws {
        // No-op for mock
    }
}
