import SwiftData

final class TimetableRepositoryImpl: TimetableRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchEntries(for week: DateInterval) async throws -> [TimetableEntry] {
        let descriptor = FetchDescriptor<TimetableEntrySD>(
            predicate: #Predicate {
                $0.startTime >= week.start && $0.startTime < week.end
            },
            sortBy: [SortDescriptor(\.startTime)]
        )
        let results = try modelContext.fetch(descriptor)
        return results.map { $0.toDomain() }
    }

    func save(_ entries: [TimetableEntry]) async throws {
        entries.forEach { entry in
            let model = TimetableEntrySD(from: entry)
            modelContext.insert(model)
        }
        try modelContext.save()
    }

    func deleteAll() async throws {
        try modelContext.delete(model: TimetableEntrySD.self)
        try modelContext.save()
    }
}
