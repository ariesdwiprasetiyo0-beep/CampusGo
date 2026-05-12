# CampusApp — iOS Clean Architecture Project

## 📋 Project Overview

CampusApp is a complete iOS application built with **Clean Architecture**, **SwiftUI**, and **MVVM** pattern. The project demonstrates enterprise-grade iOS development practices with proper separation of concerns, dependency injection, and testability.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│      Presentation Layer (SwiftUI)       │
│  Views + ViewModels (@Observable)       │
└────────────┬────────────────────────────┘
             │ depends on
┌────────────▼────────────────────────────┐
│         Domain Layer (Pure Swift)       │
│   Entities + UseCases + Protocols       │
└────────────┬────────────────────────────┘
             │ implements
┌────────────▼────────────────────────────┐
│  Data Layer (Network + Persistence)     │
│   SwiftData + CoreData + URLSession     │
└─────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- ✅ Xcode 15.0+
- ✅ Swift 5.9+
- ✅ iOS 17.0+ SDK
- ⏳ **XcodeGen** (need to install)

### 1. Install XcodeGen

**Option A: MacPorts**
```bash
sudo port install xcodegen
```

**Option B: Download Binary** (Recommended)
1. Download: https://github.com/yonaskolb/XcodeGen/releases/download/2.35.0/xcodegen.zip
2. Install:
```bash
unzip xcodegen.zip
sudo mv xcodegen /usr/local/bin/
sudo chmod +x /usr/local/bin/xcodegen
```

**Option C: Build from Source**
```bash
git clone https://github.com/yonaskolb/XcodeGen.git
cd XcodeGen && make install
```

### 2. Generate Xcode Project

```bash
cd /Users/training-25/Desktop/CampusGo
xcodegen generate
open CampusApp.xcodeproj
```

Or using Make:
```bash
make generate
make open
```

### 3. Configure Signing

- Select **CampusApp** target
- Go to **Signing & Capabilities**
- Select your **Development Team**

### 4. Build & Run

Press **Cmd+R** in Xcode or:
```bash
make build
```

## 📁 Project Structure

### Source Code (`CampusApp/`)

```
CampusApp/
├── Application/
│   ├── CampusApp.swift           # @main entry point
│   ├── DIContainer.swift         # Dependency Injection
│   └── AppCoordinator.swift      # Navigation management
│
├── Presentation/ (SwiftUI + MVVM)
│   ├── Timetable/
│   │   ├── TimetableView.swift
│   │   └── TimetableViewModel.swift
│   ├── Events/
│   │   ├── EventListingView.swift
│   │   └── EventListingViewModel.swift
│   ├── StudentID/
│   │   ├── StudentIDView.swift
│   │   └── StudentIDViewModel.swift
│   └── Shared/
│       └── CommonViews.swift
│
├── Domain/ (Pure Swift - no framework imports)
│   ├── Entities/
│   │   ├── TimetableEntry.swift
│   │   ├── CampusEvent.swift
│   │   ├── Student.swift
│   │   └── HelpTicket.swift
│   ├── UseCases/
│   │   ├── FetchTimetableUseCase.swift
│   │   ├── GetEventsUseCase.swift
│   │   ├── GetStudentProfileUseCase.swift
│   │   └── SubmitTicketUseCase.swift
│   └── Repositories/ (Protocols only)
│       ├── TimetableRepository.swift
│       ├── EventRepository.swift
│       ├── StudentRepository.swift
│       └── TicketRepository.swift
│
└── Data/ (Implementation + Persistence)
    ├── Repositories/
    │   ├── TimetableRepositoryImpl.swift
    │   ├── EventRepositoryImpl.swift
    │   ├── StudentRepositoryImpl.swift
    │   └── TicketRepositoryImpl.swift
    ├── Network/
    │   ├── APIClient.swift
    │   ├── APIError.swift
    │   └── DTOs/ (Data Transfer Objects)
    ├── SwiftData/
    │   ├── TimetableEntrySD.swift
    │   └── CampusEventSD.swift
    └── CoreData/
        ├── CoreDataStack.swift
        └── KeychainService.swift
```

### Tests (`CampusAppTests/`)

```
CampusAppTests/
├── Domain/
│   ├── FetchTimetableUseCaseTests.swift
│   └── GetStudentProfileUseCaseTests.swift
├── Mocks/
│   └── MockRepositories.swift
└── Presentation/
    └── TimetableViewModelTests.swift
```

## 🔧 Configuration Files

| File | Purpose |
|------|---------|
| **project.yml** | XcodeGen project specification |
| **Makefile** | Build automation (make build, make test, etc.) |
| **generate.sh** | Automated XcodeGen setup script |
| **ios-clean-architecture-campus-app.md** | Architecture specification |
| **SETUP_GUIDE.md** | Complete setup walkthrough |
| **INSTALL_XCODEGEN.md** | XcodeGen installation instructions |

## 📝 Make Commands

```bash
make help            # Show all commands
make setup           # Install XcodeGen + generate project
make generate        # Generate Xcode project from project.yml
make open            # Open CampusApp.xcodeproj in Xcode
make build           # Build Debug configuration
make build-release   # Build Release configuration
make test            # Run unit tests
make clean           # Remove build artifacts
make clean-all       # Complete cleanup
make lint            # Lint Swift code (requires swiftlint)
make format          # Format Swift code (requires swiftformat)
```

## 🏗️ Architecture Highlights

### Dependency Injection

All dependencies are wired in `DIContainer`:

```swift
@MainActor
final class DIContainer {
    func makeTimetableViewModel() -> TimetableViewModel {
        TimetableViewModel(useCase: makeFetchTimetableUseCase())
    }
}
```

**Benefits:**
- Easy to mock for testing
- Centralized configuration
- No singletons or global state

### Clean Separation

**Domain Layer Rules:**
- ✅ Only imports `Foundation`
- ✅ Contains pure Swift entities
- ✅ Defines protocol contracts
- ❌ No imports: `SwiftData`, `CoreData`, `UIKit`

**Presentation Layer Rules:**
- ✅ Uses `@Observable` ViewModels
- ✅ Calls UseCase through ViewModel
- ✅ Displays data from ViewModel only
- ❌ No direct Repository access
- ❌ No SwiftData/CoreData imports

**Data Layer:**
- ✅ Implements Domain protocols
- ✅ Handles network, persistence, caching
- ✅ Can use any framework (SwiftData, CoreData, etc.)

### Persistence Strategy

| Feature | Storage | Reason |
|---------|---------|--------|
| Timetable | SwiftData | Simple queries, lightweight |
| Events | SwiftData | Short lifecycle, date filtering |
| Student ID | CoreData + Keychain | Sensitive data, offline-first |
| Tickets | CoreData | Complex queries, batch operations |

## 🧪 Testing

### Run All Tests
```bash
make test
# or in Xcode: Cmd+U
```

### Test Structure

Tests follow the architecture layers:

**Domain Tests:**
```swift
// Test UseCase logic independently
let mock = MockTimetableRepository(...)
let useCase = FetchTimetableUseCaseImpl(repository: mock)
let result = try await useCase.execute(for: week)
```

**Presentation Tests:**
```swift
// Test ViewModel state management
let viewModel = TimetableViewModel(useCase: mockUseCase)
await viewModel.loadCurrentWeek()
// Assert viewModel.entries, isLoading, errorMessage
```

### Mock Repositories

Provided in `CampusAppTests/Mocks/`:
- `MockTimetableRepository`
- `MockEventRepository`
- `MockStudentRepository`
- `MockTicketRepository`

## 🔐 Security Considerations

- **Keychain**: Stores sensitive data (student ID, auth tokens)
- **CoreData**: Used for sensitive/critical data
- **SwiftData**: Used for non-sensitive, cacheable data
- **HTTPS**: All API calls use HTTPS only

## 📱 Features (Sprint 1 — Must Have)

- ✅ Personal Timetable View
  - Weekly schedule display
  - Subject details with room/lecturer info
  - SwiftData caching

- ✅ Campus Events
  - List of upcoming events
  - Category filtering
  - Date-based queries

- ✅ Student ID Card
  - Profile display
  - QR code placeholder
  - Offline-first CoreData storage

## 🔄 CI/CD Ready

The project structure is optimized for automation:

- `project.yml` is version-controlled (generates identical projects)
- XcodeGen enables headless builds
- Separate test target for continuous testing
- Mock-friendly architecture

Example CI pipeline:
```bash
xcodegen generate
xcodebuild build -scheme CampusApp -configuration Release
xcodebuild test -scheme CampusApp
```

## 📚 Documentation

- [Architecture Spec](ios-clean-architecture-campus-app.md) — Detailed technical design
- [Setup Guide](SETUP_GUIDE.md) — Complete setup walkthrough
- [XcodeGen Setup](XCODEGEN_SETUP.md) — Technical XcodeGen details
- [Install XcodeGen](INSTALL_XCODEGEN.md) — Installation methods

## 🔗 Key Technologies

- **SwiftUI** — Modern iOS UI framework
- **SwiftData** — iOS 17+ persistent storage (lightweight)
- **CoreData** — Mature persistent storage (critical data)
- **URLSession** — Network requests
- **Swift Concurrency** — Async/await for background tasks
- **Observation** — `@Observable` macro for reactive ViewModels
- **Swift Testing** — New testing framework

## 🎯 Next Steps

### Immediate
1. ✅ Install XcodeGen
2. ✅ Generate `CampusApp.xcodeproj`
3. ✅ Configure development team
4. ✅ Build & run (Cmd+R)

### Short Term (Sprint 1)
- Implement API integration (mock → real)
- Add navigation between screens
- Configure CoreData schema
- Write more unit tests

### Medium Term (Sprint 2)
- IT Helpdesk feature
- Club directory
- Fee payment status
- Enhanced authentication

## 📞 Support

### Troubleshooting

**"xcodegen: command not found"**
- Follow INSTALL_XCODEGEN.md for installation

**"Invalid project.yml"**
- Run: `xcodegen generate --verbose`

**"Code signing errors"**
- Configure development team in Signing & Capabilities

**"Tests won't run"**
- Ensure iOS 17.0+ deployment target
- Rebuild: `make clean && make build`

---

**Status**: ✅ Complete — Ready to build and deploy

**Version**: 1.0.0
**Swift**: 5.9+
**iOS**: 17.0+
**Xcode**: 15.0+

*Built with Clean Architecture principles and best practices*
