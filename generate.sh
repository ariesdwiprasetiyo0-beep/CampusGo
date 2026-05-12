#!/bin/bash

# XcodeGen Project Generation Script
# Generates CampusApp Xcode project from project.yml

set -e

echo "🚀 CampusApp XcodeGen Setup"
echo "================================"

# Check if XcodeGen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "❌ XcodeGen not found. Installing via Homebrew..."
    brew install xcodegen
else
    echo "✅ XcodeGen is installed"
    xcodegen version
fi

# Generate Xcode project
echo ""
echo "📦 Generating Xcode project from project.yml..."
xcodegen generate

echo ""
echo "✅ Project generated successfully!"
echo "📂 Opening CampusApp.xcodeproj..."
open CampusApp.xcodeproj

echo ""
echo "================================"
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Select a team in Build Settings if needed"
echo "2. Configure API base URL in DIContainer.swift"
echo "3. Build and run the app: Cmd+R"
