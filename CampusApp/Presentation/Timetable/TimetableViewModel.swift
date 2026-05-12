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
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            let week = DateInterval(start: startOfWeek, end: endOfWeek)
            entries = try await useCase.execute(for: week)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
