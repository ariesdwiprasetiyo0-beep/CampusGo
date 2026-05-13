import Foundation
import MapKit
import Observation

// MARK: - CampusMapViewModel
@Observable
final class CampusMapViewModel {

    // MARK: - State
    var buildings: [CampusBuilding] = MockCampusBuildings.all
    var selectedBuilding: CampusBuilding? = nil
    var searchText: String = ""
    var selectedCategory: BuildingCategory? = nil
    var isShowingList: Bool = false

    /// Camera position centered on campus.
    var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.3615, longitude: 106.8276),
            span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
        )
    )

    // MARK: - Derived

    var filteredBuildings: [CampusBuilding] {
        buildings.filter { building in
            let matchesSearch = searchText.isEmpty ||
                building.name.localizedCaseInsensitiveContains(searchText) ||
                building.shortName.localizedCaseInsensitiveContains(searchText) ||
                building.category.rawValue.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil ||
                building.category == selectedCategory

            return matchesSearch && matchesCategory
        }
    }

    var searchSuggestions: [CampusBuilding] {
        guard !searchText.isEmpty else { return [] }
        return filteredBuildings.prefix(5).map { $0 }
    }

    // MARK: - Actions

    func select(_ building: CampusBuilding) {
        selectedBuilding = building
        isShowingList = false
        withAnimation(.easeInOut(duration: 0.4)) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: building.coordinate.latitude - 0.001,
                        longitude: building.coordinate.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
                )
            )
        }
    }

    func resetCamera() {
        selectedBuilding = nil
        withAnimation(.easeInOut(duration: 0.4)) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: -6.3615, longitude: 106.8276),
                    span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
                )
            )
        }
    }

    func setCategory(_ category: BuildingCategory?) {
        selectedCategory = category
        selectedBuilding = nil
    }
}
