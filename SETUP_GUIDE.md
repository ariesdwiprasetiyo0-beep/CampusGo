# CampusApp — Complete Setup Guide

## Prerequisites

✅ **Already Available:**
- Xcode Command Line Tools
- Swift 5.9+ (verified: 6.3.1)
- iOS 17.0+ SDK

✅ **Required for Project Generation:**
- XcodeGen (command-line tool)

## Installation Steps

### Step 1: Install XcodeGen

Choose one method:

#### **Method A: MacPorts** (if installed)
```bash
sudo port install xcodegen
```

#### **Method B: Download Pre-built Binary** (Recommended)
1. Download from: https://github.com/yonaskolb/XcodeGen/releases/download/2.35.0/xcodegen.zip
2. Install:
```bash
unzip xcodegen.zip
sudo mv xcodegen /usr/local/bin/
sudo chmod +x /usr/local/bin/xcodegen
xcodegen version  # Verify
```

#### **Method C: Build from Source**
```bash
git clone https://github.com/yonaskolb/XcodeGen.git
cd XcodeGen
make install
```

### Step 2: Generate Xcode Project

Navigate to the project directory:
```bash
cd /Users/training-25/Desktop/CampusGo
```

Generate the project:
```bash
xcodegen generate
```

Or use the convenience script:
```bash
bash generate.sh
```

Or use Make:
```bash
make generate
```

### Step 3: Open in Xcode

```bash
open CampusApp.xcodeproj
```

Or via Make:
```bash
make open
```

## Post-Generation Configuration

### Configure Development Team

1. Open `CampusApp.xcodeproj`
2. Select **CampusApp** target
3. Go to **Signing & Capabilities** tab
4. Select your **Team** from the dropdown
5. Accept any prompts about provisioning profiles

### Update API Endpoint (Optional)

Edit `CampusApp/Application/DIContainer.swift`:
```swift
apiClient = APIClient(
    baseURL: URL(string: "https://your-api.campus.edu/v1")!
)
```

### Configure Code Signing (If Needed)

In Xcode:
1. Preferences → Accounts → Add your Apple ID
2. Select team from the dropdown
3. Auto-manage signing enabled

## Build & Run

### Using Xcode
1. Select **CampusApp** scheme
2. Choose simulator/device
3. Press **Cmd+R** to build and run

### Using Command Line

Build:
```bash
make build
```

Build Release:
```bash
make build-release
```

Run Tests:
```bash
make test
```

## Project Structure

```
CampusApp/
├── Application/
│   ├── CampusApp.swift           # @main entry point
│   ├── DIContainer.swift         # Dependency injection
│   └── AppCoordinator.swift      # Navigation
│
├── Presentation/                 # SwiftUI views
│   ├── Timetable/
│   ├── Events/
│   ├── StudentID/
│   └── Shared/
│
├── Domain/                       # Business logic
│   ├── Entities/
│   ├── UseCases/
│   └── Repositories/
│
└── Data/                         # Data layer
    ├── Repositories/
    ├── Network/
    ├── SwiftData/
    └── CoreData/

CampusAppTests/
├── Domain/
├── Mocks/
└── Presentation/
```

## Configuration Files

| File | Purpose |
|------|---------|
| `project.yml` | XcodeGen specification |
| `Makefile` | Common build commands |
| `generate.sh` | Automated generation script |
| `XCODEGEN_SETUP.md` | Detailed XcodeGen setup |
| `INSTALL_XCODEGEN.md` | Installation instructions |

## Useful Make Commands

```bash
# View all commands
make help

# Setup (install + generate)
make setup

# Generate project
make generate

# Open in Xcode
make open

# Build
make build
make build-release

# Test
make test

# Clean
make clean
make clean-all

# Code quality
make lint
make format
```

## File Generation Summary

After running `xcodegen generate`, the following structure is created:

### New Files
- `CampusApp.xcodeproj/` — Xcode project file
- `project.pbxproj` — Project configuration inside xcodeproj

### Existing Files (Not Modified)
- `CampusApp/` — Source code
- `CampusAppTests/` — Test code
- `project.yml` — XcodeGen configuration

## Next Steps

1. ✅ Install XcodeGen
2. ✅ Run `xcodegen generate`
3. ✅ Open `CampusApp.xcodeproj`
4. ✅ Configure development team
5. ✅ Build & run with **Cmd+R**

## Troubleshooting

### "xcodegen: command not found"
XcodeGen is not installed. Follow Step 1 above.

### "Invalid project.yml"
Run with verbose output:
```bash
xcodegen generate --verbose
```

### Project won't build
1. Verify Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```
2. Check deployment target matches iOS 17.0+
3. Verify signing team is configured

### Tests won't run
1. Ensure CampusAppTests target is selected
2. Run via Xcode: **Cmd+U**
3. Or command line: `make test`

---

*For detailed XcodeGen documentation, see: https://github.com/yonaskolb/XcodeGen*
