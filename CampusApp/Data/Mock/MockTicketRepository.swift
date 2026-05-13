import Foundation

// MARK: - Mock Ticket Repository
final class MockTicketRepository: TicketRepository {

    private var tickets: [HelpTicket] = []

    func submit(_ ticket: HelpTicket) async throws -> HelpTicket {
        try await Task.sleep(for: .milliseconds(500))
        tickets.append(ticket)
        return ticket
    }

    func fetchAll() async throws -> [HelpTicket] {
        try await Task.sleep(for: .milliseconds(400))
        return tickets
    }
}
