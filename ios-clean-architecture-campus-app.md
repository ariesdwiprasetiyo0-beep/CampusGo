# iOS Clean Architecture — Campus App

> Dokumen arsitektur teknis untuk pengembangan Campus App berbasis SwiftUI dengan pendekatan Clean Architecture dan prioritas fitur MoSCoW.

---

## Daftar Isi

1. [Gambaran Arsitektur](#gambaran-arsitektur)
2. [Layer Breakdown](#layer-breakdown)
   - [Presentation Layer](#presentation-layer)
   - [Domain Layer](#domain-layer)
   - [Data Layer](#data-layer)
3. [Struktur Folder Xcode](#struktur-folder-xcode)
4. [Persistence Strategy — SwiftData vs CoreData](#persistence-strategy)
5. [Dependency Injection](#dependency-injection)
6. [Sprint Mapping (MoSCoW)](#sprint-mapping)
7. [Contoh Kode](#contoh-kode)

---

## Gambaran Arsitektur

Campus App menggunakan **Clean Architecture** dengan tiga layer utama. Aturan inti: *dependency hanya boleh mengarah ke dalam* — Presentation dan Data keduanya bergantung pada Domain, tapi Domain tidak tahu apa-apa tentang kedua layer lain.

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│    SwiftUI Views + ViewModels (MVVM)    │
└────────────────┬────────────────────────┘
                 │ depends on
┌────────────────▼────────────────────────┐
│              Domain Layer               │
│   Entities · UseCases · Protocols       │
│        Pure Swift — zero deps           │
└────────────────┬────────────────────────┘
                 │ implements
┌────────────────▼────────────────────────┐
│              Data Layer                 │
│  Repositories · Network · Persistence  │
│    SwiftData + CoreData + URLSession    │
└─────────────────────────────────────────┘
```

---

## Layer Breakdown

### Presentation Layer

Menggunakan **SwiftUI + MVVM** dengan `@Observable` (iOS 17+). Setiap fitur memiliki View dan ViewModel sendiri. Routing dikelola oleh `AppCoordinator` menggunakan `NavigationStack`.

**Komponen:**

| Komponen | Deskripsi |
|---|---|
| `*View.swift` | SwiftUI views, hanya UI logic |
| `*ViewModel.swift` | `@Observable` class, memanggil UseCase |
| `AppCoordinator` | Mengelola NavigationStack, routing antar screen |
| `DIContainer` | Composition root, inject semua dependensi |

**Aturan ketat:**
- View tidak boleh memanggil Repository secara langsung
- ViewModel tidak boleh import `SwiftData` atau `CoreData`
- Semua state di ViewModel, bukan di View

---

### Domain Layer

Layer paling murni. **Tidak ada** `import UIKit`, `import SwiftData`, `import CoreData`. Hanya boleh `import Foundation` untuk tipe standar seperti `Date`, `UUID`.

#### Entities

```swift
// Murni Swift struct — tidak ada annotation persistence
struct TimetableEntry: Identifiable, Equatable {
    let id: UUID
    let subjectCode: String
    let subjectName: String
    let room: String
    let startTime: Date
    let endTime: Date
    let lecturer: String
}

struct CampusEvent: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let location: String
    let category: EventCategory
}

struct Student: Equatable {
    let studentID: String
    let fullName: String
    let faculty: String
    let program: String
    let photoURL: URL?
    let isActive: Bool
}

struct HelpTicket: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var category: TicketCategory
    var status: TicketStatus
    let createdAt: Date
}
```

#### Use Case Protocols

Setiap use case adalah **protocol dengan satu method** `execute()`. Pattern ini memudahkan unit testing dengan mock.

```swift
protocol FetchTimetableUseCase {
    func execute(for week: DateInterval) async throws -> [TimetableEntry]
}

protocol GetEventsUseCase {
    func execute(upcoming limit: Int) async throws -> [CampusEvent]
}

protocol GetStudentProfileUseCase {
    func execute() async throws -> Student
}

protocol SubmitTicketUseCase {
    func execute(_ ticket: HelpTicket) async throws -> HelpTicket
}
```

#### Repository Protocols

```swift
protocol TimetableRepository {
    func fetchEntries(for week: DateInterval) async throws -> [TimetableEntry]
    func save(_ entries: [TimetableEntry]) async throws
    func deleteAll() async throws
}

protocol EventRepository {
    func fetchUpcoming(limit: Int) async throws -> [CampusEvent]
    func fetchAll() async throws -> [CampusEvent]
    func save(_ events: [CampusEvent]) async throws
}

protocol StudentRepository {
    func getProfile() async throws -> Student
    func saveProfile(_ student: Student) async throws
}

protocol TicketRepository {
    func submit(_ ticket: HelpTicket) async throws -> HelpTicket
    func fetchAll() async throws -> [HelpTicket]
}
```

---

### Data Layer

Implementasi nyata dari semua protocol Domain. Layer ini boleh menggunakan framework apapun: SwiftData, CoreData, URLSession, Keychain, dll.

#### Network (URLSession)

```swift
final class APIClient {
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest(baseURL: baseURL)
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }
        return try decoder.decode(T.self, from: data)
    }
}
```

#### DTO — Data Transfer Objects

DTOs adalah struct Codable yang memetakan JSON dari API ke domain entity. Domain tidak pernah tahu bentuk JSON.

```swift
struct TimetableEntryDTO: Codable {
    let id: String
    let subject_code: String
    let subject_name: String
    let room: String
    let start_time: String
    let end_time: String
    let lecturer_name: String
}

extension TimetableEntryDTO {
    func toDomain() -> TimetableEntry {
        TimetableEntry(
            id: UUID(uuidString: id) ?? UUID(),
            subjectCode: subject_code,
            subjectName: subject_name,
            room: room,
            startTime: ISO8601DateFormatter().date(from: start_time) ?? Date(),
            endTime: ISO8601DateFormatter().date(from: end_time) ?? Date(),
            lecturer: lecturer_name
        )
    }
}
```

---

## Struktur Folder Xcode

```
CampusApp/
├── Application/
│   ├── CampusApp.swift           # @main entry point
│   ├── AppCoordinator.swift      # NavigationStack routing
│   └── DIContainer.swift         # Composition root
│
├── Presentation/
│   ├── Timetable/                # 🔴 Must Have — Sprint 1
│   │   ├── TimetableView.swift
│   │   ├── TimetableViewModel.swift
│   │   └── TimetableRowView.swift
│   ├── Events/                   # 🔴 Must Have — Sprint 1
│   │   ├── EventListingView.swift
│   │   ├── EventListingViewModel.swift
│   │   └── EventCardView.swift
│   ├── StudentID/                # 🔴 Must Have — Sprint 1
│   │   ├── StudentIDView.swift
│   │   ├── StudentIDViewModel.swift
│   │   └── QRCodeView.swift
│   ├── Helpdesk/                 # 🟡 Should Have — Sprint 2
│   │   ├── HelpdeskView.swift
│   │   └── HelpdeskViewModel.swift
│   ├── Clubs/                    # 🟡 Should Have — Sprint 2
│   │   ├── ClubDirectoryView.swift
│   │   └── ClubDirectoryViewModel.swift
│   ├── FeePayment/               # 🟡 Should Have — Sprint 2
│   │   ├── FeeStatusView.swift
│   │   └── FeeStatusViewModel.swift
│   ├── Cafeteria/                # 🟢 Could Have — Sprint 3+
│   │   ├── CafeteriaMenuView.swift
│   │   └── CafeteriaViewModel.swift
│   ├── ShuttleTracker/           # 🟢 Could Have — Sprint 3+
│   │   └── ShuttleTrackerView.swift
│   └── Shared/
│       ├── LoadingView.swift
│       ├── ErrorView.swift
│       └── EmptyStateView.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── TimetableEntry.swift
│   │   ├── CampusEvent.swift
│   │   ├── Student.swift
│   │   ├── HelpTicket.swift
│   │   ├── Club.swift
│   │   └── FeeStatus.swift
│   ├── UseCases/
│   │   ├── FetchTimetableUseCase.swift
│   │   ├── FetchTimetableUseCaseImpl.swift
│   │   ├── GetEventsUseCase.swift
│   │   ├── GetEventsUseCaseImpl.swift
│   │   ├── GetStudentProfileUseCase.swift
│   │   ├── GetStudentProfileUseCaseImpl.swift
│   │   └── SubmitTicketUseCase.swift
│   └── Repositories/             # Protocols only — no implementation
│       ├── TimetableRepository.swift
│       ├── EventRepository.swift
│       ├── StudentRepository.swift
│       ├── TicketRepository.swift
│       └── ClubRepository.swift
│
├── Data/
│   ├── Repositories/
│   │   ├── TimetableRepositoryImpl.swift   # SwiftData
│   │   ├── EventRepositoryImpl.swift        # SwiftData
│   │   ├── StudentRepositoryImpl.swift      # CoreData + Keychain
│   │   ├── TicketRepositoryImpl.swift       # URLSession
│   │   └── ClubRepositoryImpl.swift         # SwiftData
│   ├── Network/
│   │   ├── APIClient.swift
│   │   ├── Endpoint.swift
│   │   ├── APIError.swift
│   │   └── DTOs/
│   │       ├── TimetableEntryDTO.swift
│   │       ├── CampusEventDTO.swift
│   │       └── StudentDTO.swift
│   ├── SwiftData/
│   │   ├── TimetableEntrySD.swift    # @Model
│   │   ├── CampusEventSD.swift       # @Model
│   │   └── ClubSD.swift              # @Model
│   └── CoreData/
│       ├── CampusApp.xcdatamodeld
│       ├── CoreDataStack.swift
│       ├── StudentEntity+CoreData.swift
│       └── KeychainService.swift
│
└── CampusAppTests/
    ├── Domain/
    │   ├── FetchTimetableUseCaseTests.swift
    │   └── GetStudentProfileUseCaseTests.swift
    ├── Mocks/
    │   ├── MockTimetableRepository.swift
    │   ├── MockEventRepository.swift
    │   └── MockStudentRepository.swift
    └── Presentation/
        └── TimetableViewModelTests.swift
```

---

## Persistence Strategy

### Aturan pemilihan: SwiftData vs CoreData

| Kriteria | SwiftData | CoreData |
|---|---|---|
| Minimum iOS | 17+ | 13+ |
| Sintaks | `@Model` macro, bersih | `NSManagedObject`, verbose |
| Complex query | Terbatas (`#Predicate`) | Powerful (`NSPredicate`) |
| Migration | Otomatis (`VersionedSchema`) | Manual (Mapping Model) |
| Batch operations | Belum optimal | `NSBatchDeleteRequest` efisien |
| Offline-first | Baik untuk data ringan | Lebih andal untuk data kritikal |

### Keputusan per fitur

| Fitur | Storage | Alasan |
|---|---|---|
| Timetable | **SwiftData** | Query sederhana, sync berkala, model kecil |
| Events / O-Week | **SwiftData** | Lifecycle pendek, query by date cukup |
| Club directory | **SwiftData** | Read-heavy, model relatif sederhana |
| Noticeboard | **SwiftData** | Konten dinamis, tidak butuh batch ops |
| Student ID | **CoreData + Keychain** | Data sensitif, harus offline-first 100% |
| Fee payment status | **CoreData** | Query complex, audit trail, history |
| Helpdesk tickets | **CoreData** | Butuh batch sync, status tracking |

### SwiftData — contoh implementasi

```swift
// Data/SwiftData/TimetableEntrySD.swift
import SwiftData

@Model
final class TimetableEntrySD {
    var id: UUID
    var subjectCode: String
    var subjectName: String
    var room: String
    var startTime: Date
    var endTime: Date
    var lecturer: String

    init(from domain: TimetableEntry) {
        self.id = domain.id
        self.subjectCode = domain.subjectCode
        self.subjectName = domain.subjectName
        self.room = domain.room
        self.startTime = domain.startTime
        self.endTime = domain.endTime
        self.lecturer = domain.lecturer
    }

    func toDomain() -> TimetableEntry {
        TimetableEntry(
            id: id,
            subjectCode: subjectCode,
            subjectName: subjectName,
            room: room,
            startTime: startTime,
            endTime: endTime,
            lecturer: lecturer
        )
    }
}
```

```swift
// Data/Repositories/TimetableRepositoryImpl.swift
import SwiftData

final class TimetableRepositoryImpl: TimetableRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchEntries(for week: DateInterval) async throws -> [TimetableEntry] {
        let descriptor = FetchDescriptor<TimetableEntrySD>(
            predicate: #Predicate {
                $0.startTime >= week.start && $0.startTime < week.end
            },
            sortBy: [SortDescriptor(\.startTime)]
        )
        let results = try modelContext.fetch(descriptor)
        return results.map { $0.toDomain() }
    }

    func save(_ entries: [TimetableEntry]) async throws {
        entries.forEach { entry in
            let model = TimetableEntrySD(from: entry)
            modelContext.insert(model)
        }
        try modelContext.save()
    }

    func deleteAll() async throws {
        try modelContext.delete(model: TimetableEntrySD.self)
        try modelContext.save()
    }
}
```

### CoreData — contoh implementasi

```swift
// Data/CoreData/CoreDataStack.swift
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack(name: "CampusApp")

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init(name: String) {
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData load failed: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
}
```

```swift
// Data/Repositories/StudentRepositoryImpl.swift
import CoreData

final class StudentRepositoryImpl: StudentRepository {
    private let context: NSManagedObjectContext
    private let keychain: KeychainService

    init(context: NSManagedObjectContext, keychain: KeychainService) {
        self.context = context
        self.keychain = keychain
    }

    func getProfile() async throws -> Student {
        let request = NSFetchRequest<StudentEntity>(entityName: "StudentEntity")
        request.fetchLimit = 1
        let results = try context.fetch(request)
        guard let entity = results.first else {
            throw StudentError.notFound
        }
        return entity.toDomain()
    }

    func saveProfile(_ student: Student) async throws {
        let entity = StudentEntity(context: context)
        entity.studentID = student.studentID
        entity.fullName = student.fullName
        entity.faculty = student.faculty
        entity.program = student.program
        entity.isActive = student.isActive
        // Data sensitif disimpan di Keychain, bukan CoreData
        if let photoURL = student.photoURL {
            try keychain.save(photoURL.absoluteString, for: "student_photo_url")
        }
        try context.save()
    }
}
```

---

## Dependency Injection

Semua dependensi didaftarkan di `DIContainer` saat app launch. ViewModel menerima use case melalui initializer — tidak ada singleton global selain container itu sendiri.

```swift
// Application/DIContainer.swift
import SwiftData

@MainActor
final class DIContainer {

    // MARK: - Infrastructure

    let modelContainer: ModelContainer
    let coreDataStack: CoreDataStack
    let apiClient: APIClient
    let keychainService: KeychainService

    // MARK: - Init

    init() throws {
        modelContainer = try ModelContainer(for:
            TimetableEntrySD.self,
            CampusEventSD.self,
            ClubSD.self
        )
        coreDataStack = CoreDataStack(name: "CampusApp")
        apiClient = APIClient(baseURL: URL(string: "https://api.campus.edu/v1")!)
        keychainService = KeychainService()
    }

    // MARK: - Repositories

    func makeTimetableRepository() -> TimetableRepository {
        TimetableRepositoryImpl(modelContext: modelContainer.mainContext)
    }

    func makeEventRepository() -> EventRepository {
        EventRepositoryImpl(modelContext: modelContainer.mainContext)
    }

    func makeStudentRepository() -> StudentRepository {
        StudentRepositoryImpl(
            context: coreDataStack.viewContext,
            keychain: keychainService
        )
    }

    // MARK: - Use Cases

    func makeFetchTimetableUseCase() -> FetchTimetableUseCase {
        FetchTimetableUseCaseImpl(
            repository: makeTimetableRepository(),
            apiClient: apiClient
        )
    }

    func makeGetStudentProfileUseCase() -> GetStudentProfileUseCase {
        GetStudentProfileUseCaseImpl(repository: makeStudentRepository())
    }

    // MARK: - ViewModels

    func makeTimetableViewModel() -> TimetableViewModel {
        TimetableViewModel(useCase: makeFetchTimetableUseCase())
    }

    func makeStudentIDViewModel() -> StudentIDViewModel {
        StudentIDViewModel(useCase: makeGetStudentProfileUseCase())
    }
}
```

---

## Sprint Mapping

### Sprint 1 — Foundation & Must Have (2 minggu)

**Goal:** Core app usable — mahasiswa bisa lihat jadwal, event, dan ID card.

| User Story | Fitur | Story Points | Notes |
|---|---|---|---|
| CG5-2 | Personal timetable sync | 8 | API integration + SwiftData cache |
| CG5-3 | Event listings O-Week | 5 | List + detail view |
| CG5-5 | Student ID card display | 5 | QR code + offline CoreData |
| — | DIContainer + AppCoordinator | 3 | Foundation wajib sprint 1 |
| — | APIClient + error handling | 3 | Shared infrastructure |

**Total:** ~24 SP

### Sprint 2 — Should Have (2 minggu)

**Goal:** App lebih lengkap, mahasiswa bisa handle masalah IT dan cek keuangan.

| User Story | Fitur | Story Points | Notes |
|---|---|---|---|
| — | IT helpdesk ticket submission | 8 | Form + API submit |
| — | Club & society directory | 5 | SwiftData + search |
| — | Fee payment status | 8 | CoreData + complex query |
| — | Peer connection / profil | 8 | Auth integration |

**Total:** ~29 SP

### Sprint 3+ — Could Have & Future

| Fitur | Priority | Notes |
|---|---|---|
| Cafeteria menu & daily specials | Could Have | Simple API, low risk |
| Campus shuttle tracker | Could Have | Real-time, butuh WebSocket |
| Student noticeboard | Could Have | CMS integration |
| Library booking integration | Won't Have (this time) | External dependency, risky |

---

## Contoh Kode

### ViewModel — pattern standar

```swift
// Presentation/Timetable/TimetableViewModel.swift
import Observation

@Observable
final class TimetableViewModel {
    var entries: [TimetableEntry] = []
    var isLoading = false
    var errorMessage: String?

    private let useCase: FetchTimetableUseCase

    init(useCase: FetchTimetableUseCase) {
        self.useCase = useCase
    }

    func loadCurrentWeek() async {
        isLoading = true
        errorMessage = nil
        do {
            let week = DateInterval(
                start: Calendar.current.startOfWeek(for: Date()),
                duration: 7 * 24 * 3600
            )
            entries = try await useCase.execute(for: week)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
```

### View — clean SwiftUI

```swift
// Presentation/Timetable/TimetableView.swift
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
```

### Unit test — dengan mock repository

```swift
// CampusAppTests/Domain/FetchTimetableUseCaseTests.swift
import Testing

@Suite("FetchTimetableUseCase")
struct FetchTimetableUseCaseTests {

    @Test("Returns cached entries when API unavailable")
    func returnsCachedEntries() async throws {
        let mock = MockTimetableRepository(
            stubbedEntries: [.fixture(subjectCode: "CS101")]
        )
        let useCase = FetchTimetableUseCaseImpl(
            repository: mock,
            apiClient: MockAPIClient(shouldFail: true)
        )
        let week = DateInterval(start: Date(), duration: 604800)
        let result = try await useCase.execute(for: week)
        #expect(result.first?.subjectCode == "CS101")
    }
}
```

---

## Catatan Penting

### Aturan yang tidak boleh dilanggar

1. **Domain tidak boleh import SwiftData/CoreData** — pelanggaran ini merusak testability
2. **View tidak boleh mengakses Repository langsung** — semua lewat ViewModel → UseCase
3. **Setiap `@Model` dan `NSManagedObject` harus punya `.toDomain()` mapper** — DTOs dan persistence models tidak boleh bocor ke atas
4. **ViewModel harus bisa di-init dengan mock** — constructor injection, bukan singleton

### Tips deployment

- Gunakan `ModelContainer` preview untuk SwiftUI Previews
- Pisahkan `ModelContainer` production dan in-memory untuk testing
- Keychain items harus menggunakan `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` untuk student ID

---

*Dokumen ini dibuat berdasarkan backlog prioritas MoSCoW campus app — CG5 sprint planning.*
