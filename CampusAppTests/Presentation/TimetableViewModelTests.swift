import Testing
@testable import CampusApp

@Suite("TimetableViewModel")
struct TimetableViewModelTests {

    @Test("Loads entries successfully")
    async func loadsEntriesSuccessfully() async {
        let mockEntry = TimetableEntry(
            id: UUID(),
            subjectCode: "CS101",
            subjectName: "Programming Basics",
            room: "A101",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            lecturer: "Dr. Smith"
        )
        let mockRepository = MockTimetableRepository(stubbedEntries: [mockEntry])
        let useCase = FetchTimetableUseCaseImpl(repository: mockRepository)
        let viewModel = TimetableViewModel(useCase: useCase)

        #expect(viewModel.isLoading == false)
        #expect(viewModel.entries.isEmpty)

        await viewModel.loadCurrentWeek()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.entries.count == 1)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Handles loading errors")
    async func handlesLoadingErrors() async {
        let mockRepository = MockTimetableRepository(shouldFail: true)
        let useCase = FetchTimetableUseCaseImpl(repository: mockRepository)
        let viewModel = TimetableViewModel(useCase: useCase)

        await viewModel.loadCurrentWeek()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }
}
