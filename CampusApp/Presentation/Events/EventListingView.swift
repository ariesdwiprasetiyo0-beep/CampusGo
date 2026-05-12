import SwiftUI

struct EventListingView: View {
    @State private var viewModel: EventListingViewModel

    init(viewModel: EventListingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Memuat event...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.loadUpcomingEvents() }
                    }
                } else if viewModel.events.isEmpty {
                    EmptyStateView(message: "Tidak ada event yang akan datang")
                } else {
                    List(viewModel.events) { event in
                        EventCardView(event: event)
                    }
                }
            }
            .navigationTitle("Event")
        }
        .task { await viewModel.loadUpcomingEvents() }
    }
}

struct EventCardView: View {
    let event: CampusEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.headline)
            Text(event.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack {
                Label(formattedDate(event.date), systemImage: "calendar")
                Spacer()
                Label(event.location, systemImage: "location")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            HStack {
                Label(event.category.rawValue, systemImage: "tag")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
