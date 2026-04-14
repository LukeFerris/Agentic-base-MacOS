#!/bin/bash
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
DERIVED_DATA="$REPO_ROOT/.derivedData"

# Always regenerate to pick up source file changes
if command -v xcodegen &> /dev/null; then
    cd "$REPO_ROOT" && xcodegen generate --quiet
else
    echo "ERROR: XcodeGen is not installed. Run 'make setup' to install."
    exit 1
fi

echo "Running tests with coverage..."
xcodebuild test \
    -project "$REPO_ROOT/Flow.xcodeproj" \
    -scheme Flow \
    -configuration Debug \
    -derivedDataPath "$DERIVED_DATA" \
    -enableCodeCoverage YES \
    2>&1

echo ""
echo "Tests passed with coverage data collected."
echo "Coverage data stored in: $DERIVED_DATA"
