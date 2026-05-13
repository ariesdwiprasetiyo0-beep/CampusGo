import SwiftData
import Foundation

final class TimetableRepositoryImpl: TimetableRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchEntries(from start: Date, to end: Date) async throws -> [TimetableEntry] {
        let descriptor = FetchDescriptor<TimetableEntrySD>(
            predicate: #Predicate<TimetableEntrySD> {
                $0.startTime >= start && $0.startTime < end
            },
            sortBy: [SortDescriptor(\.startTime)]
        )
        let results = try modelContext.fetch(descriptor)
        return results.map { $0.toDomain() }
    }

    func save(_ entries: [TimetableEntry]) async throws {
        for entry in entries {
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
