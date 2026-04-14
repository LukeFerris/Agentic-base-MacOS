#!/bin/bash

echo "========================================="
echo "Installing Security Tools"
echo "========================================="
echo ""

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "ERROR: This template is for macOS only."
    exit 1
fi

if ! command -v brew &> /dev/null; then
    echo "ERROR: Homebrew is required. Install from https://brew.sh"
    exit 1
fi

# Install Semgrep
if command -v semgrep &> /dev/null; then
    echo "Semgrep is already installed"
    semgrep --version
else
    echo "Installing Semgrep..."
    brew install semgrep
    echo "Semgrep installed successfully"
fi

echo ""

# Install gitleaks
if command -v gitleaks &> /dev/null; then
    echo "gitleaks is already installed"
    gitleaks version
else
    echo "Installing gitleaks..."
    brew install gitleaks
    echo "gitleaks installed successfully"
fi

echo ""

# Install GitHub CLI
if command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is already installed"
    gh --version
else
    echo "Installing GitHub CLI..."
    brew install gh
    echo "GitHub CLI installed successfully"
fi

echo ""
echo "========================================="
echo "Security Tools Installation Complete"
echo "========================================="
echo ""
echo "Installed tools:"
echo "  - Semgrep (SAST)"
echo "  - gitleaks (secret scanning)"
echo "  - GitHub CLI (gh)"
echo ""
