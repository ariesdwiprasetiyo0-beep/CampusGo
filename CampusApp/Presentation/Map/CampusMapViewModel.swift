import Foundation
import SwiftUI
import _MapKit_SwiftUI
import MapKit
import Observation

// MARK: - CampusMapViewModel
@Observable
final class CampusMapViewModel {

    // MARK: - State
    var buildings: [CampusBuilding] = MockCampusBuildings.all
    var selectedBuildingID: UUID? = nil
    var searchText: String = ""
    var selectedCategory: BuildingCategory? = nil
    var isShowingList: Bool = false

    /// Camera position centered on UI campus.
    var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.3615, longitude: 106.8276),
            span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
        )
    )

    // MARK: - Derived

    var selectedBuilding: CampusBuilding? {
        guard let id = selectedBuildingID else { return nil }
        return buildings.first { $0.id == id }
    }

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

    // MARK: - Actions

    func select(_ building: CampusBuilding) {
        selectedBuildingID = building.id
        isShowingList = false
        withAnimation(.easeInOut(duration: 0.4)) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: building.latitude - 0.001,
                        longitude: building.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
                )
            )
        }
    }

    func selectByID(_ id: UUID?) {
        guard let id, let building = buildings.first(where: { $0.id == id }) else {
            selectedBuildingID = nil
            return
        }
        select(building)
    }

    func dismissSelection() {
        selectedBuildingID = nil
    }

    func resetCamera() {
        selectedBuildingID = nil
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
        selectedBuildingID = nil
    }
}
