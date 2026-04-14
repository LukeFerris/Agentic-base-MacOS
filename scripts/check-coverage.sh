#!/bin/bash
set -e

# Coverage thresholds (percentage)
LINE_THRESHOLD=75
FUNCTION_THRESHOLD=75

REPO_ROOT="$(git rev-parse --show-toplevel)"
DERIVED_DATA="$REPO_ROOT/.derivedData"

STAGED_FILES="$@"
if [ -z "$STAGED_FILES" ]; then
    echo "No files to check coverage for."
    exit 0
fi

# Filter to only source files (not tests)
SOURCE_FILES=""
for FILE in $STAGED_FILES; do
    if [[ "$FILE" != *"Tests"* ]] && [[ "$FILE" == *"Flow/Sources"* ]]; then
        SOURCE_FILES="$SOURCE_FILES $FILE"
    fi
done

if [ -z "$SOURCE_FILES" ]; then
    echo "No source files to check coverage for (only test files staged)."
    exit 0
fi

echo "Checking coverage for staged source files..."

# Find the latest xccov report
XCRESULT=$(find "$DERIVED_DATA" -name "*.xcresult" -type d 2>/dev/null | head -1)

if [ -z "$XCRESULT" ]; then
    echo ""
    echo "========================================="
    echo "ERROR: No coverage report found!"
    echo "========================================="
    echo "Coverage report is required for commits."
    echo "The test-coverage script should have generated it."
    exit 1
fi

FAILURES=0
PASSED=0

for FILE in $SOURCE_FILES; do
    FILENAME=$(basename "$FILE")

    # Get coverage for this file from xccov
    COVERAGE_LINE=$(xcrun xccov view --report "$XCRESULT" --json 2>/dev/null | \
        python3 -c "
import json, sys
data = json.load(sys.stdin)
for target in data.get('targets', []):
    for source_file in target.get('files', []):
        if source_file.get('name', '') == '$FILENAME':
            pct = source_file.get('lineCoverage', 0) * 100
            print(f'{pct:.1f}')
            sys.exit(0)
print('NOT_FOUND')
" 2>/dev/null || echo "NOT_FOUND")

    if [ "$COVERAGE_LINE" = "NOT_FOUND" ]; then
        echo "  - $FILE: not found in coverage report (may not be imported by any test)"
        continue
    fi

    COVERAGE_INT=$(echo "$COVERAGE_LINE" | python3 -c "import sys; print(int(float(sys.stdin.readline())))")

    if [ "$COVERAGE_INT" -lt "$LINE_THRESHOLD" ]; then
        echo "  FAIL $FILE: ${COVERAGE_LINE}% (threshold: ${LINE_THRESHOLD}%)"
        FAILURES=1
    else
        echo "  PASS $FILE: ${COVERAGE_LINE}%"
        PASSED=$((PASSED + 1))
    fi
done

if [ $FAILURES -ne 0 ]; then
    echo ""
    echo "========================================="
    echo "COVERAGE THRESHOLDS NOT MET!"
    echo "========================================="
    echo "Line coverage threshold: ${LINE_THRESHOLD}%"
    echo ""
    echo "Please add tests to improve coverage for the failing files."
    exit 1
fi

echo ""
echo "All staged files meet coverage thresholds."
exit 0
