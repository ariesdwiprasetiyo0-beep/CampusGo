import Foundation

protocol GetStudentProfileUseCase {
    func execute() async throws -> Student
}

final class GetStudentProfileUseCaseImpl: GetStudentProfileUseCase {
    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    func execute() async throws -> Student {
        return try await repository.getProfile()
    }
}
