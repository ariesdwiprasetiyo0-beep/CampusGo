import SwiftUI

// MARK: - EventListingView
struct EventListingView: View {
    @State private var viewModel: EventListingViewModel
    @State private var selectedCategory: EventCategory? = nil
    @State private var searchText = ""

    init(viewModel: EventListingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    private var filteredEvents: [CampusEvent] {
        var events = viewModel.events

        if let cat = selectedCategory {
            events = events.filter { $0.category == cat }
        }

        if !searchText.isEmpty {
            events = events.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }

        return events
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Memuat event...")
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadUpcomingEvents() }
                }
            } else if viewModel.events.isEmpty {
                EmptyStateView(
                    message: "Tidak ada event yang akan datang",
                    icon: "ticket"
                )
            } else {
                eventList
            }
        }
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadUpcomingEvents() }
    }

    // MARK: - Event List
    private var eventList: some View {
        List {
            // Category filter — scrollable chips inside a listRowBackground-free row
            Section {
                categoryPicker
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }

            if filteredEvents.isEmpty {
                ContentUnavailableView.search(text: searchText.isEmpty ? selectedCategory?.displayName ?? "" : searchText)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(filteredEvents) { event in
                    EventRowView(event: event)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Cari event atau lokasi")
        .animation(.default, value: filteredEvents.map(\.id))
    }

    // MARK: - Category Picker (segmented-style chips)
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    title: "Semua",
                    isSelected: selectedCategory == nil,
                    color: .appAccent
                ) {
                    withAnimation { selectedCategory = nil }
                }
                ForEach(EventCategory.allCases, id: \.self) { cat in
                    CategoryChip(
                        title: cat.displayName,
                        isSelected: selectedCategory == cat,
                        color: cat.color
                    ) {
                        withAnimation {
                            selectedCategory = selectedCategory == cat ? nil : cat
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - CategoryChip
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : color)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? color : color.opacity(0.1), in: Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - EventRowView
struct EventRowView: View {
    let event: CampusEvent

    private var formattedDateTime: String {
        event.date.formatted(date: .abbreviated, time: .shortened)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Category + Date header row
            HStack {
                CategoryBadge(title: event.category.displayName, color: event.category.color)
                Spacer()
                Text(formattedDateTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Title
            Text(event.title)
                .font(.headline)
                .lineLimit(2)

            // Description
            Text(event.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .lineSpacing(2)

            // Location
            Label(event.location, systemImage: "mappin.and.ellipse")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - EventCategory Extensions
extension EventCategory: CaseIterable {
    static var allCases: [EventCategory] {
        [.orientation, .academic, .cultural, .sports]
    }

    var displayName: String {
        switch self {
        case .orientation: return "Orientasi"
        case .academic:    return "Akademik"
        case .cultural:    return "Budaya"
        case .sports:      return "Olahraga"
        }
    }

    /// System-native colors that adapt to Dark Mode.
    var color: Color {
        switch self {
        case .orientation: return .indigo
        case .academic:    return .blue
        case .cultural:    return .purple
        case .sports:      return .green
        }
    }
}
