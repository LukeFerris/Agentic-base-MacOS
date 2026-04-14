#!/bin/bash
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

# Always regenerate to pick up source file changes
if command -v xcodegen &> /dev/null; then
    cd "$REPO_ROOT" && xcodegen generate --quiet
else
    echo "ERROR: XcodeGen is not installed. Run 'make setup' to install."
    exit 1
fi

echo "Building Flow..."
xcodebuild \
    -project "$REPO_ROOT/Flow.xcodeproj" \
    -scheme Flow \
    -configuration Debug \
    -quiet \
    build

echo "Build succeeded."
