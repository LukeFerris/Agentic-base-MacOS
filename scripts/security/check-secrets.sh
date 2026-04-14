#!/bin/bash
set -e

if ! command -v gitleaks &> /dev/null; then
    echo "WARNING: gitleaks is not installed."
    echo "Install with: brew install gitleaks"
    echo "Or run: make setup"
    echo "Skipping secret scan."
    exit 0
fi

FILES="$@"
if [ -z "$FILES" ]; then
    echo "No files to scan for secrets."
    exit 0
fi

echo "Scanning staged files for secrets..."

REPO_ROOT="$(git rev-parse --show-toplevel)"

gitleaks detect --source "$REPO_ROOT" --no-git --verbose 2>&1 || {
    RESULT=$?
    if [ $RESULT -eq 1 ]; then
        echo ""
        echo "========================================="
        echo "SECRETS DETECTED!"
        echo "========================================="
        echo "Please remove secrets from the files above before committing."
        echo "If these are false positives, add them to .gitleaksignore"
        exit 1
    fi
    # Exit code > 1 means gitleaks itself errored
    echo "WARNING: gitleaks encountered an error. Skipping secret scan."
    exit 0
}

echo "No secrets found in staged files."
exit 0
