import SwiftUI

struct TimetableView: View {
    @State private var viewModel: TimetableViewModel

    init(viewModel: TimetableViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Memuat jadwal...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.loadCurrentWeek() }
                    }
                } else if viewModel.entries.isEmpty {
                    EmptyStateView(message: "Tidak ada jadwal minggu ini")
                } else {
                    List(viewModel.entries) { entry in
                        TimetableRowView(entry: entry)
                    }
                }
            }
            .navigationTitle("Jadwal Kuliah")
        }
        .task { await viewModel.loadCurrentWeek() }
    }
}

struct TimetableRowView: View {
    let entry: TimetableEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.subjectName)
                .font(.headline)
            HStack {
                Label(entry.subjectCode, systemImage: "book")
                Spacer()
                Label(entry.room, systemImage: "door.left.hand.open")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            HStack {
                Label(formattedTime(entry.startTime), systemImage: "clock")
                Spacer()
                Label(entry.lecturer, systemImage: "person")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
