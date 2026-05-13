import SwiftUI

// MARK: - TimetableView
struct TimetableView: View {
    @State private var viewModel: TimetableViewModel

    init(viewModel: TimetableViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    /// Group entries by their calendar day for section headers.
    private var groupedEntries: [(day: String, entries: [TimetableEntry])] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "id_ID")

        let grouped = Dictionary(grouping: viewModel.entries) { entry in
            calendar.startOfDay(for: entry.startTime)
        }

        return grouped
            .sorted { $0.key < $1.key }
            .map { (day: dateFormatter.string(from: $0.key).capitalized, entries: $0.value) }
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Memuat jadwal...")
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadCurrentWeek() }
                }
            } else if viewModel.entries.isEmpty {
                EmptyStateView(
                    message: "Tidak ada jadwal untuk minggu ini",
                    icon: "calendar.badge.exclamationmark"
                )
            } else {
                List {
                    ForEach(groupedEntries, id: \.day) { group in
                        Section(group.day) {
                            ForEach(group.entries) { entry in
                                TimetableRowView(entry: entry)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Jadwal Kuliah")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadCurrentWeek() }
    }
}

// MARK: - TimetableRowView
struct TimetableRowView: View {
    let entry: TimetableEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Subject name
            Text(entry.subjectName)
                .font(.headline)

            // Subject code badge
            CategoryBadge(title: entry.subjectCode, color: .appAccent)

            // Time range
            Label(timeRange, systemImage: "clock")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                // Room
                Label(entry.room, systemImage: "location")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // Lecturer
                Label(entry.lecturer, systemImage: "person")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }

    private var timeRange: String {
        let fmt = DateFormatter()
        fmt.timeStyle = .short
        return "\(fmt.string(from: entry.startTime)) – \(fmt.string(from: entry.endTime))"
    }
}
