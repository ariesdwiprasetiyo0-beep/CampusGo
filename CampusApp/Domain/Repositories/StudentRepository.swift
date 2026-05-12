import Foundation

protocol StudentRepository {
    func getProfile() async throws -> Student
    func saveProfile(_ student: Student) async throws
}
