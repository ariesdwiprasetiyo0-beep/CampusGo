import Foundation
import CoreLocation

// MARK: - Building Category
enum BuildingCategory: String, CaseIterable, Identifiable, Hashable {
    case academic       = "Akademik"
    case library        = "Perpustakaan"
    case administration = "Administrasi"
    case sports         = "Olahraga"
    case worship        = "Ibadah"
    case health         = "Kesehatan"
    case dining         = "Kuliner"
    case dormitory      = "Asrama"
    case transportation = "Transportasi"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .academic:       return "building.columns.fill"
        case .library:        return "books.vertical.fill"
        case .administration: return "building.2.fill"
        case .sports:         return "sportscourt.fill"
        case .worship:        return "rays"
        case .health:         return "cross.case.fill"
        case .dining:         return "fork.knife"
        case .dormitory:      return "house.fill"
        case .transportation: return "tram.fill"
        }
    }
}

// MARK: - Campus Building
// Hashable + Equatable based on `id` only so MapKit's Map(selection:) works correctly.
struct CampusBuilding: Identifiable, Hashable {
    let id: UUID
    let name: String
    let shortName: String
    let category: BuildingCategory
    let latitude: Double
    let longitude: Double
    let description: String
    let facilities: [String]
    let floors: Int
    let openHours: String

    /// Convenience accessor returning a CLLocationCoordinate2D.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Only compare / hash by ID — coordinates are not Hashable on older OS.
    static func == (lhs: CampusBuilding, rhs: CampusBuilding) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
