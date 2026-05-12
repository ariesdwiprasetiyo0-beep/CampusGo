import Foundation

class MockTimetableRepository: TimetableRepository {
    var stubbedEntries: [TimetableEntry] = []
    var shouldFail = false

    func fetchEntries(for week: DateInterval) async throws -> [TimetableEntry] {
        if shouldFail {
            throw NSError(domain: "Mock", code: -1)
        }
        return stubbedEntries
    }

    func save(_ entries: [TimetableEntry]) async throws {
        if shouldFail {
            throw NSError(domain: "Mock", code: -1)
        }
        stubbedEntries = entries
    }

    func deleteAll() async throws {
        if shouldFail {
            throw NSError(domain: "Mock", code: -1)
        }
        stubbedEntries = []
    }
}

class MockEventRepository: EventRepository {
    var stubbedEvents: [CampusEvent] = []
    var shouldFail = false

    func fetchUpcoming(limit: Int) async throws -> [CampusEvent] {
        if shouldFail {
            throw NSError(domain: "Mock", code: -1)
        }
        return Array(stubbedEvents.prefix(limit))
    }

    func fetchAll() async throws -> [CampusEvent] {
        if shouldFail {
            throw NSError(domain: "Mock", code: -1)
        }
        return stubbedEvents
    }

    func save(_ events: [CampusEvent]) async throws {
        if shouldFail {
            throw NSError(domain: "Mock", code: -1)
        }
        stubbedEvents = events
    }
}

class MockStudentRepository: StudentRepository {
    var stubbedStudent: Student?
    var shouldFail = false

    func getProfile() async throws -> Student {
        if shouldFail {
            throw StudentError.notFound
        }
        return stubbedStudent ?? Student(
            studentID: "12345",
            fullName: "Test Student",
            faculty: "Engineering",
            program: "Computer Science",
            photoURL: nil,
            isActive: true
        )
    }

    func saveProfile(_ student: Student) async throws {
        if shouldFail {
            throw StudentError.saveFailed
        }
        stubbedStudent = student
    }
}

class MockTicketRepository: TicketRepository {
    var stubbedTickets: [HelpTicket] = []
    var shouldFail = false

    func submit(_ ticket: HelpTicket) async throws -> HelpTicket {
        if shouldFail {
            throw TicketError.submitFailed
        }
        stubbedTickets.append(ticket)
        return ticket
    }

    func fetchAll() async throws -> [HelpTicket] {
        if shouldFail {
            throw TicketError.fetchFailed
        }
        return stubbedTickets
    }
}

class MockAPIClient: APIClient {
    var shouldFail = false

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
        super.init(baseURL: URL(string: "https://mock.api.com")!)
    }
}
