.PHONY: help setup generate open build test clean lint format

help:
	@echo "CampusApp — Make Commands"
	@echo "========================="
	@echo ""
	@echo "Setup & Generation:"
	@echo "  make setup          - Install XcodeGen and generate project"
	@echo "  make generate       - Generate Xcode project from project.yml"
	@echo "  make open           - Open CampusApp.xcodeproj in Xcode"
	@echo ""
	@echo "Build & Test:"
	@echo "  make build          - Build CampusApp (Debug)"
	@echo "  make build-release  - Build CampusApp (Release)"
	@echo "  make test           - Run all tests"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean          - Remove build artifacts and .xcodeproj"
	@echo "  make clean-all      - Remove all build artifacts"
	@echo ""
	@echo "Code Quality:"
	@echo "  make format         - Format Swift files (requires swiftformat)"
	@echo "  make lint           - Lint Swift files (requires swiftlint)"
	@echo ""

setup:
	@echo "🚀 Setting up CampusApp..."
	@bash generate-manual.sh

generate:
	@echo "📦 Generating Xcode project..."
	@xcodegen generate
	@echo "✅ Project generated"

open:
	@echo "📂 Opening CampusApp.xcodeproj..."
	@open CampusApp.xcodeproj

build:
	@echo "🔨 Building CampusApp (Debug)..."
	@xcodebuild -scheme CampusApp -configuration Debug -derivedDataPath build

build-release:
	@echo "🔨 Building CampusApp (Release)..."
	@xcodebuild -scheme CampusApp -configuration Release -derivedDataPath build

test:
	@echo "🧪 Running tests..."
	@xcodebuild -scheme CampusApp -derivedDataPath build test

clean:
	@echo "🧹 Cleaning project artifacts..."
	@rm -rf build
	@rm -rf CampusApp.xcodeproj
	@xcodebuild clean -scheme CampusApp -configuration Debug 2>/dev/null || true
	@xcodebuild clean -scheme CampusApp -configuration Release 2>/dev/null || true
	@echo "✅ Cleaned"

clean-all: clean
	@echo "🧹 Removing all build artifacts..."
	@rm -rf ~/Library/Developer/Xcode/DerivedData/*CampusApp*
	@echo "✅ All cleaned"

format:
	@echo "📝 Formatting Swift code..."
	@find CampusApp -name "*.swift" -exec swiftformat {} \;
	@find CampusAppTests -name "*.swift" -exec swiftformat {} \;
	@echo "✅ Formatted"

lint:
	@echo "🔍 Linting Swift code..."
	@swiftlint lint CampusApp
	@swiftlint lint CampusAppTests
	@echo "✅ Linting complete"

# Info targets
info-version:
	@echo "Swift Version:"
	@swift --version
	@echo ""
	@echo "Xcode Version:"
	@xcodebuild -version

info-structure:
	@echo "Project Structure:"
	@find CampusApp -type f -name "*.swift" | sort
