#!/bin/bash

# Manual XcodeGen Installation & Project Generation
# For environments without Homebrew

set -e

PROJECT_DIR=$(pwd)
XCODEGEN_VERSION="2.35.0"
XCODEGEN_URL="https://github.com/yonaskolb/XcodeGen/releases/download/${XCODEGEN_VERSION}/xcodegen.zip"

echo "🚀 CampusApp XcodeGen Setup (No Homebrew)"
echo "=========================================="

# Check if Xcode is available
if ! command -v xcode-select &> /dev/null; then
    echo "❌ Xcode Command Line Tools not found"
    echo "Install via: xcode-select --install"
    exit 1
fi

echo "✅ Xcode Command Line Tools found"

# Method 1: Try XcodeGen via SPM (Swift Package Manager)
echo ""
echo "📦 Attempting to build XcodeGen from source via SPM..."

if ! command -v xcodegen &> /dev/null; then
    echo ""
    echo "⚠️  XcodeGen not installed globally"
    echo ""
    echo "INSTALLATION OPTIONS:"
    echo "====================="
    echo ""
    echo "Option 1: Using MacPorts (if installed)"
    echo "  sudo port install xcodegen"
    echo ""
    echo "Option 2: Download Pre-built Binary"
    echo "  URL: https://github.com/yonaskolb/XcodeGen/releases"
    echo "  1. Download xcodegen.zip for your platform"
    echo "  2. Unzip and place 'xcodegen' in /usr/local/bin"
    echo "  3. chmod +x /usr/local/bin/xcodegen"
    echo ""
    echo "Option 3: Build from Source"
    echo "  git clone https://github.com/yonaskolb/XcodeGen.git"
    echo "  cd XcodeGen"
    echo "  make install"
    echo ""
    echo "After installation, run:"
    echo "  cd ${PROJECT_DIR}"
    echo "  xcodegen generate"
    echo "  open CampusApp.xcodeproj"
    exit 1
fi

echo "✅ XcodeGen found!"

# Generate Xcode project
echo ""
echo "📋 Generating Xcode project from project.yml..."
xcodegen generate

if [ -d "CampusApp.xcodeproj" ]; then
    echo ""
    echo "✅ Xcode project generated successfully!"
    echo "📂 Project structure created at: ${PROJECT_DIR}/CampusApp.xcodeproj"
    echo ""
    echo "Next steps:"
    echo "1. Open in Xcode:"
    echo "   open CampusApp.xcodeproj"
    echo ""
    echo "2. Configure signing:"
    echo "   - Select CampusApp target"
    echo "   - Go to Signing & Capabilities"
    echo "   - Select your development team"
    echo ""
    echo "3. Update API URL in DIContainer.swift if needed"
    echo ""
    echo "4. Build & Run (Cmd+R)"
else
    echo "❌ Project generation failed"
    exit 1
fi
