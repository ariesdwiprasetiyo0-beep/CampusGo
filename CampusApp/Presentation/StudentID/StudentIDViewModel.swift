import Foundation
import Observation

@Observable
final class StudentIDViewModel {
    var student: Student?
    var isLoading = false
    var errorMessage: String?

    private let useCase: GetStudentProfileUseCase

    init(useCase: GetStudentProfileUseCase) {
        self.useCase = useCase
    }

    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            student = try await useCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
