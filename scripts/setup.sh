#!/bin/bash
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

echo "========================================="
echo "Flow - Project Setup"
echo "========================================="
echo ""

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "ERROR: Homebrew is required. Install from https://brew.sh"
    exit 1
fi

# Install XcodeGen
if command -v xcodegen &> /dev/null; then
    echo "XcodeGen is already installed"
else
    echo "Installing XcodeGen..."
    brew install xcodegen
fi

# Install SwiftLint
if command -v swiftlint &> /dev/null; then
    echo "SwiftLint is already installed"
else
    echo "Installing SwiftLint..."
    brew install swiftlint
fi

# Install security tools
echo ""
"$REPO_ROOT/scripts/security/install-security-tools.sh"

# Install git hooks
echo ""
echo "Installing git hooks..."
mkdir -p "$REPO_ROOT/.git/hooks"
ln -sf "$REPO_ROOT/scripts/hooks/pre-commit" "$REPO_ROOT/.git/hooks/pre-commit"
echo "Git hooks installed."

# Generate Xcode project
echo ""
echo "Generating Xcode project..."
cd "$REPO_ROOT" && xcodegen generate
echo "Xcode project generated."

echo ""
echo "========================================="
echo "Setup Complete"
echo "========================================="
echo ""
echo "You can now:"
echo "  make build       - Build the project"
echo "  make test        - Run tests"
echo "  make lint        - Run SwiftLint"
echo "  make open        - Open in Xcode"
echo "  make help        - See all commands"
echo ""
