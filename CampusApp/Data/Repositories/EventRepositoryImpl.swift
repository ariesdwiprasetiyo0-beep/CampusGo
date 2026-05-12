import SwiftData

final class EventRepositoryImpl: EventRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchUpcoming(limit: Int) async throws -> [CampusEvent] {
        let descriptor = FetchDescriptor<CampusEventSD>(
            predicate: #Predicate {
                $0.date >= Date()
            },
            sortBy: [SortDescriptor(\.date)],
            fetchLimit: limit
        )
        let results = try modelContext.fetch(descriptor)
        return results.map { $0.toDomain() }
    }

    func fetchAll() async throws -> [CampusEvent] {
        let descriptor = FetchDescriptor<CampusEventSD>(
            sortBy: [SortDescriptor(\.date)]
        )
        let results = try modelContext.fetch(descriptor)
        return results.map { $0.toDomain() }
    }

    func save(_ events: [CampusEvent]) async throws {
        events.forEach { event in
            let model = CampusEventSD(from: event)
            modelContext.insert(model)
        }
        try modelContext.save()
    }
}
