import Testing
@testable import CampusApp

@Suite("FetchTimetableUseCase")
struct FetchTimetableUseCaseTests {

    @Test("Returns cached entries when available")
    func returnsCachedEntries() async throws {
        let mockEntry = TimetableEntry(
            id: UUID(),
            subjectCode: "CS101",
            subjectName: "Programming Basics",
            room: "A101",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            lecturer: "Dr. Smith"
        )
        let mock = MockTimetableRepository(stubbedEntries: [mockEntry])
        let useCase = FetchTimetableUseCaseImpl(repository: mock)
        let week = DateInterval(start: Date(), duration: 604800)
        let result = try await useCase.execute(for: week)
        #expect(result.count == 1)
        #expect(result.first?.subjectCode == "CS101")
    }

    @Test("Throws error when repository fails")
    async func throwsErrorOnFailure() async {
        let mock = MockTimetableRepository(shouldFail: true)
        let useCase = FetchTimetableUseCaseImpl(repository: mock)
        let week = DateInterval(start: Date(), duration: 604800)
        await #expect(throws: Error.self) {
            try await useCase.execute(for: week)
        }
    }
}
