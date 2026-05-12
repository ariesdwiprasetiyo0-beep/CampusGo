import Foundation

protocol TicketRepository {
    func submit(_ ticket: HelpTicket) async throws -> HelpTicket
    func fetchAll() async throws -> [HelpTicket]
}
