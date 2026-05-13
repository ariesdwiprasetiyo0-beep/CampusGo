import SwiftUI
import MapKit

// MARK: - CampusMapView
struct CampusMapView: View {
    @State private var viewModel = CampusMapViewModel()
    // Map selection works with UUID (Hashable) — we map it back to a building via ViewModel
    @State private var mapSelection: UUID? = nil

    var body: some View {
        ZStack(alignment: .bottom) {

            // ── Map ───────────────────────────────────────────────────────────
            Map(position: $viewModel.cameraPosition, selection: $mapSelection) {
                ForEach(viewModel.filteredBuildings) { building in
                    Marker(
                        building.shortName,
                        systemImage: building.category.sfSymbol,
                        coordinate: building.coordinate
                    )
                    .tint(categoryTint(building.category))
                    .tag(building.id)
                }
                UserAnnotation()
            }
            .mapStyle(.standard(elevation: .realistic))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea(edges: .top)
            .onChange(of: mapSelection) { _, newID in
                viewModel.selectByID(newID)
            }

            // ── Overlay ───────────────────────────────────────────────────────
            VStack(spacing: 0) {
                searchAndFilterBar
                    .padding(.horizontal, 12)
                    .padding(.top, 12)

                Spacer()

                if let building = viewModel.selectedBuilding {
                    BuildingDetailCard(building: building) {
                        mapSelection = nil
                        viewModel.dismissSelection()
                    } onShowList: {
                        viewModel.isShowingList = true
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    buildingCountBadge
                        .padding(.bottom, 12)
                        .transition(.opacity)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.82), value: viewModel.selectedBuildingID)
        }
        .navigationTitle("Peta Kampus")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isShowingList = true
                } label: {
                    Label("Daftar Gedung", systemImage: "list.bullet")
                }
            }
            if viewModel.selectedBuildingID != nil || viewModel.selectedCategory != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        mapSelection = nil
                        viewModel.resetCamera()
                        viewModel.selectedCategory = nil
                        viewModel.searchText = ""
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingList) {
            BuildingListSheet(viewModel: viewModel) { building in
                mapSelection = building.id
                viewModel.select(building)
            }
        }
    }

    // MARK: - Search & Filter Bar
    private var searchAndFilterBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)

                TextField("Cari gedung kampus...", text: $viewModel.searchText)
                    .font(.subheadline)
                    .autocorrectionDisabled()
                    .submitLabel(.search)

                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CategoryMapChip(
                        label: "Semua",
                        icon: "map.fill",
                        isSelected: viewModel.selectedCategory == nil,
                        tint: .appAccent
                    ) {
                        viewModel.setCategory(nil)
                    }
                    ForEach(BuildingCategory.allCases) { category in
                        CategoryMapChip(
                            label: category.rawValue,
                            icon: category.sfSymbol,
                            isSelected: viewModel.selectedCategory == category,
                            tint: categoryTint(category)
                        ) {
                            viewModel.setCategory(
                                viewModel.selectedCategory == category ? nil : category
                            )
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
            }
        }
    }

    // MARK: - Building Count Badge
    private var buildingCountBadge: some View {
        let count = viewModel.filteredBuildings.count
        return Button {
            viewModel.isShowingList = true
        } label: {
            Label("\(count) gedung ditemukan", systemImage: "building.2")
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.regularMaterial, in: Capsule())
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Category → Tint
    private func categoryTint(_ category: BuildingCategory) -> Color {
        switch category {
        case .academic:       return .indigo
        case .library:        return .blue
        case .administration: return .gray
        case .sports:         return .green
        case .worship:        return .orange
        case .health:         return .red
        case .dining:         return .yellow
        case .dormitory:      return .teal
        case .transportation: return .purple
        }
    }
}

// MARK: - CategoryMapChip
struct CategoryMapChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                Text(label)
                    .font(.caption.weight(isSelected ? .semibold : .regular))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background(
                isSelected ? tint : Color(.systemBackground).opacity(0.9),
                in: Capsule()
            )
            .shadow(color: .black.opacity(0.07), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - BuildingDetailCard
struct BuildingDetailCard: View {
    let building: CampusBuilding
    let onDismiss: () -> Void
    let onShowList: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.appAccent.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: building.category.sfSymbol)
                        .font(.system(size: 20))
                        .foregroundStyle(Color.appAccent)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(building.name)
                        .font(.headline)
                        .lineLimit(2)
                    HStack(spacing: 4) {
                        Text(building.category.rawValue)
                        Text("·")
                        Text("\(building.floors) lantai")
                        Text("·")
                        Text(building.openHours)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            Text(building.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            if !building.facilities.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(building.facilities, id: \.self) { facility in
                            Label(facility, systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(.systemGray6), in: Capsule())
                        }
                    }
                }
            }

            Button {
                openMaps(for: building)
            } label: {
                Label("Petunjuk Arah", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.appAccent)
            .controlSize(.regular)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: -4)
    }

    private func openMaps(for building: CampusBuilding) {
        let placemark = MKPlacemark(coordinate: building.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = building.name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
}

// MARK: - BuildingListSheet
struct BuildingListSheet: View {
    let viewModel: CampusMapViewModel
    let onSelect: (CampusBuilding) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var localSearch = ""
    @State private var localCategory: BuildingCategory? = nil

    private var filtered: [CampusBuilding] {
        viewModel.buildings.filter { building in
            let matchesSearch = localSearch.isEmpty ||
                building.name.localizedCaseInsensitiveContains(localSearch) ||
                building.shortName.localizedCaseInsensitiveContains(localSearch) ||
                building.category.rawValue.localizedCaseInsensitiveContains(localSearch)
            let matchesCategory = localCategory == nil || building.category == localCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryChip(title: "Semua", isSelected: localCategory == nil, color: .appAccent) {
                                localCategory = nil
                            }
                            ForEach(BuildingCategory.allCases) { cat in
                                CategoryChip(title: cat.rawValue, isSelected: localCategory == cat, color: .appAccent) {
                                    localCategory = localCategory == cat ? nil : cat
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowInsets(.init())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }

                if filtered.isEmpty {
                    ContentUnavailableView.search(text: localSearch)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(filtered) { building in
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                onSelect(building)
                            }
                        } label: {
                            BuildingListRow(building: building)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(
                text: $localSearch,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Cari nama atau kategori gedung"
            )
            .navigationTitle("Semua Gedung")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Tutup") { dismiss() }
                }
            }
        }
    }
}

// MARK: - BuildingListRow
struct BuildingListRow: View {
    let building: CampusBuilding

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.appAccent.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: building.category.sfSymbol)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.appAccent)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(building.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Text(building.category.rawValue)
                    Text("·")
                    Text("\(building.floors) lantai")
                    Text("·")
                    Text(building.openHours)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(.tertiaryLabel))
        }
        .padding(.vertical, 2)
    }
}
