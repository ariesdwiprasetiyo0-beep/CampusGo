import Foundation
import Observation

@Observable
final class EventListingViewModel {
    var events: [CampusEvent] = []
    var isLoading = false
    var errorMessage: String?

    private let useCase: GetEventsUseCase

    init(useCase: GetEventsUseCase) {
        self.useCase = useCase
    }

    func loadUpcomingEvents() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await useCase.execute(upcoming: 10)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
