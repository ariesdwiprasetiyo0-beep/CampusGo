import Foundation

protocol SubmitTicketUseCase {
    func execute(_ ticket: HelpTicket) async throws -> HelpTicket
}

final class SubmitTicketUseCaseImpl: SubmitTicketUseCase {
    private let repository: TicketRepository

    init(repository: TicketRepository) {
        self.repository = repository
    }

    func execute(_ ticket: HelpTicket) async throws -> HelpTicket {
        return try await repository.submit(ticket)
    }
}
