import Foundation
import Observation

@Observable
final class TimetableViewModel {
    var entries: [TimetableEntry] = []
    var isLoading = false
    var errorMessage: String?

    private let useCase: FetchTimetableUseCase

    init(useCase: FetchTimetableUseCase) {
        self.useCase = useCase
    }

    func loadCurrentWeek() async {
        isLoading = true
        errorMessage = nil
        do {
            let calendar = Calendar.current
            let now = Date()
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let end = calendar.date(byAdding: .day, value: 7, to: start)!
            entries = try await useCase.execute(from: start, to: end)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
