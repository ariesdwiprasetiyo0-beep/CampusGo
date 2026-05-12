# Installation Guide for XcodeGen

XcodeGen is a command-line tool that generates Xcode projects from a YAML specification.

## Quick Install

### Option 1: MacPorts
```bash
sudo port install xcodegen
```

### Option 2: Download Pre-built Binary (Recommended)
1. Visit: https://github.com/yonaskolb/XcodeGen/releases
2. Download `xcodegen.zip` for your platform (Apple Silicon: `xcodegen-2.35.0.zip`)
3. Unzip the file
4. Move to `/usr/local/bin`:
   ```bash
   unzip xcodegen.zip
   sudo mv xcodegen /usr/local/bin/
   sudo chmod +x /usr/local/bin/xcodegen
   ```
5. Verify installation:
   ```bash
   xcodegen version
   ```

### Option 3: Build from Source
```bash
git clone https://github.com/yonaskolb/XcodeGen.git
cd XcodeGen
make install
```

## Project Generation

### After Installing XcodeGen

```bash
cd /Users/training-25/Desktop/CampusGo

# Generate Xcode project
xcodegen generate

# Open the generated project
open CampusApp.xcodeproj
```

Or run the automated script:
```bash
bash generate.sh
```

## Configuration Files

- **project.yml** - XcodeGen specification (defines targets, schemes, settings)
- **generate.sh** - Automated setup script (requires XcodeGen installed)
- **generate-manual.sh** - Manual setup with installation instructions

## Project.yml Structure

```yaml
name: CampusApp                 # Project name
options:
  bundleIdPrefix: com.campusgo  # Bundle ID prefix
  deploymentTarget: iOS 17.0    # Minimum iOS version

targets:
  CampusApp:                    # Main app target
    type: application
    platform: iOS
  
  CampusAppTests:               # Test target
    type: unitTests
    platform: iOS

schemes:                        # Build schemes
  CampusApp:
    run:
    test:
    archive:
```

## What Gets Generated

- `CampusApp.xcodeproj/` - Xcode project directory
  - `project.pbxproj` - Project configuration
  - Build phases, targets, and schemes

## Regenerating After Changes

If you modify `project.yml`:
```bash
xcodegen generate
```

This will regenerate the `.pbxproj` file. **Note**: Custom changes made only in Xcode will be lost.

## Troubleshooting

### "command not found: xcodegen"
Make sure XcodeGen is installed and in your PATH:
```bash
which xcodegen
```

If not found, follow the installation steps above.

### "Invalid project.yml"
Validate the YAML syntax:
```bash
xcodegen generate --verbose
```

This will show detailed error messages.

### Permission Denied
If `xcodegen` command fails with permission denied:
```bash
chmod +x /usr/local/bin/xcodegen
```

---

*CampusApp XcodeGen Setup Guide*
