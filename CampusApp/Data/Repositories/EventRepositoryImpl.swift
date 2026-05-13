import Foundation
import SwiftData

final class EventRepositoryImpl: EventRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchUpcoming(limit: Int) async throws -> [CampusEvent] {
        let now = Date()                          // capture dulu di luar #Predicate
        var descriptor = FetchDescriptor<CampusEventSD>(
            predicate: #Predicate<CampusEventSD> { $0.date >= now },
            sortBy: [SortDescriptor(\.date)]
        )
        descriptor.fetchLimit = limit             // set sebagai property, bukan parameter init
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
        for event in events {
            let model = CampusEventSD(from: event)
            modelContext.insert(model)
        }
        try modelContext.save()
    }
}
