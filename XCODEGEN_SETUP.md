# CampusApp — XcodeGen Configuration

This directory contains an XcodeGen configuration to generate the Xcode project for CampusApp.

## Requirements

- Xcode 15.0+
- Swift 5.9+
- iOS 17.0+ deployment target
- XcodeGen (`brew install xcodegen`)

## Project Structure

The `project.yml` file defines:
- **CampusApp** target: Main iOS application
- **CampusAppTests** target: Unit tests
- **Configurations**: Debug and Release builds
- **Schemes**: Run, Test, Profile, Archive schemes

## Generation

### Option 1: Automated Setup
```bash
bash generate.sh
```

This script will:
1. Check for XcodeGen installation
2. Install via Homebrew if missing
3. Generate the project
4. Open CampusApp.xcodeproj

### Option 2: Manual Generation
```bash
xcodegen generate
open CampusApp.xcodeproj
```

## Post-Generation Setup

After generating the Xcode project:

1. **Configure Development Team**
   - Open CampusApp.xcodeproj
   - Select CampusApp target
   - Go to Signing & Capabilities
   - Select your development team

2. **Configure API Endpoint** (optional)
   - Edit `CampusApp/Application/DIContainer.swift`
   - Update the API base URL:
   ```swift
   apiClient = APIClient(baseURL: URL(string: "https://your-api.edu/v1")!)
   ```

3. **Build and Run**
   - Select a simulator or device
   - Press Cmd+R to build and run

## Project Configuration Details

### Targets
- **CampusApp**: Main iOS app (iOS 17.0+)
- **CampusAppTests**: Unit tests with Swift Testing framework

### Schemes
- **CampusApp**: Default scheme with all run configurations
  - **Build**: Compiles all targets
  - **Run**: Debug configuration
  - **Test**: Runs CampusAppTests
  - **Profile**: Release configuration
  - **Archive**: Creates release build

### Build Settings
- **Swift Version**: 5.9
- **Deployment Target**: iOS 17.0
- **Code Sign Style**: Automatic
- **Optimization**: `-Onone` (Debug), `-O` (Release)

## Regenerating the Project

If you modify `project.yml`:
```bash
xcodegen generate
```

**Note**: XcodeGen will replace the `.pbxproj` file. Any custom build settings made in Xcode will be lost. Always edit `project.yml` and regenerate.

## References

- [XcodeGen Documentation](https://github.com/yonaskolb/XcodeGen)
- [Project.yml Specification](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md)

---

*Generated for CampusApp Clean Architecture project*
