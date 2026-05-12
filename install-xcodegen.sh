#!/bin/bash

# Install XcodeGen pre-built binary
set -e

XCODEGEN_VERSION="2.35.0"
XCODEGEN_URL="https://github.com/yonaskolb/XcodeGen/releases/download/${XCODEGEN_VERSION}/xcodegen.zip"
TEMP_DIR=$(mktemp -d)

echo "🚀 Installing XcodeGen ${XCODEGEN_VERSION}"
echo "=========================================="
echo ""

# Detect architecture
ARCH=$(uname -m)
echo "Architecture: $ARCH"

if [ "$ARCH" == "arm64" ]; then
    echo "✅ Apple Silicon detected"
else
    echo "⚠️  Intel Mac detected"
fi

echo ""
echo "Downloading XcodeGen..."
cd "$TEMP_DIR"

# Download with curl (verbose)
if curl -L -o xcodegen.zip "$XCODEGEN_URL"; then
    echo "✅ Download complete"
else
    echo "❌ Download failed"
    exit 1
fi

echo ""
echo "Extracting..."
unzip -q xcodegen.zip

if [ -f "xcodegen" ]; then
    echo "✅ Extracted successfully"
else
    echo "❌ Extraction failed"
    exit 1
fi

echo ""
echo "Installing to /usr/local/bin..."
sudo mv xcodegen /usr/local/bin/
sudo chmod +x /usr/local/bin/xcodegen

echo ""
echo "Verifying installation..."
if xcodegen version; then
    echo ""
    echo "✅ XcodeGen installed successfully!"
    echo ""
    echo "Next step:"
    echo "  cd /Users/training-25/Desktop/CampusGo"
    echo "  xcodegen generate"
else
    echo "❌ Installation verification failed"
    exit 1
fi

# Cleanup
rm -rf "$TEMP_DIR"
