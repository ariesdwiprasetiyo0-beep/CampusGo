# CampusApp — iOS Clean Architecture Project

This is a complete implementation of the Campus App using **Clean Architecture** with SwiftUI, following the technical specification.

## Project Structure

```
CampusApp/
├── Application/              # Entry point & DI
│   ├── CampusApp.swift
│   ├── AppCoordinator.swift
│   └── DIContainer.swift
│
├── Presentation/             # SwiftUI UI layer
│   ├── Timetable/
│   ├── Events/
│   ├── StudentID/
│   └── Shared/
│
├── Domain/                   # Pure business logic
│   ├── Entities/
│   ├── UseCases/
│   └── Repositories/         # Protocol definitions only
│
├── Data/                     # Implementation layer
│   ├── Repositories/         # Concrete implementations
│   ├── Network/              # API client & DTOs
│   ├── SwiftData/            # SwiftData models
│   └── CoreData/             # CoreData setup
│
└── CampusAppTests/           # Unit tests & mocks
    ├── Domain/
    ├── Mocks/
    └── Presentation/
```

## Architecture Principles

✅ **Dependency Rule**: Dependencies point inward. Presentation and Data both depend on Domain, but Domain is independent.

✅ **Separation of Concerns**: Each layer has a single responsibility.

✅ **Testability**: All business logic is testable through use cases with mock repositories.

✅ **No Frameworks in Domain**: Domain layer uses only Foundation.

## Sprint 1 Features (Must Have)

- [x] Personal timetable view
- [x] Event listings
- [x] Student ID card display
- [x] Foundation architecture & DI

## Setup & Configuration

### Prerequisites
- iOS 17+ (for SwiftUI @Observable)
- Xcode 15+
- Swift 5.9+

### API Configuration
Update the base URL in `DIContainer.swift`:
```swift
apiClient = APIClient(baseURL: URL(string: "https://api.campus.edu/v1")!)
```

### Persistence
- **SwiftData**: Timetable, Events (lightweight, auto-migrating)
- **CoreData**: Student profile, Tickets (critical data, with Keychain for sensitive fields)

## Testing

Run tests using Xcode Test Navigator or:
```bash
xcodebuild test -scheme CampusApp
```

Example test files:
- `FetchTimetableUseCaseTests.swift` — Use case unit tests
- `TimetableViewModelTests.swift` — ViewModel tests with mocks

## Next Steps (Sprint 2+)

- IT Helpdesk ticket submission
- Club & society directory
- Fee payment status view
- Enhanced authentication

---

*This project follows the specifications in `ios-clean-architecture-campus-app.md`*
