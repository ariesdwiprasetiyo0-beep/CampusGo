import Foundation

// MARK: - Mock Student Repository
final class MockStudentRepository: StudentRepository {

    func getProfile() async throws -> Student {
        // Simulate a short network delay
        try await Task.sleep(for: .milliseconds(800))

        return Student(
            studentID: "2106731234",
            fullName: "Andi Kurniawan Wijaya",
            faculty: "Fakultas Ilmu Komputer",
            program: "Teknik Informatika",
            photoURL: URL(string: "https://i.pravatar.cc/300?img=33"),
            isActive: true
        )
    }

    func saveProfile(_ student: Student) async throws {
        // No-op for mock
    }
}
