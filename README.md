# Flow

A native macOS application starter template built with SwiftUI, with built-in code quality and security tooling.

## Features

- **SwiftUI** native macOS application
- **Pre-commit hooks** enforcing code quality, test coverage, and security scanning
- **XcodeGen** for diff-friendly, generated Xcode projects
- **SwiftLint** for consistent Swift code style
- **Semgrep** SAST scanning for security vulnerabilities
- **gitleaks** secret detection to prevent credential leaks
- **Code coverage** thresholds enforced on every commit

## Quick Start

```bash
# Clone and setup
git clone <repo-url> flow
cd flow
make setup

# Open in Xcode
make open

# Or build from command line
make build
make test
```

## Requirements

- macOS 14.0+
- Xcode 16+
- Homebrew (for installing tooling)

All other dependencies are installed automatically by `make setup`.

## Project Structure

```
Flow/
├── Sources/                 # Application source code
│   ├── FlowApp.swift        # App entry point
│   └── ContentView.swift    # Main view
├── Resources/
│   └── Info.plist           # App metadata
└── Flow.entitlements        # App entitlements

FlowTests/                   # Unit tests
scripts/                     # Build, test, and CI scripts
project.yml                  # XcodeGen project definition
.swiftlint.yml               # SwiftLint configuration
Makefile                     # Common commands
```

## Pre-commit Checks

Every commit automatically runs:

1. **Secret scanning** (gitleaks) — prevents committing credentials
2. **SAST scanning** (semgrep) — catches security vulnerabilities
3. **SwiftLint** — enforces code style and quality
4. **Build** — ensures the project compiles
5. **Tests with coverage** — runs the full test suite
6. **Coverage threshold** — verifies staged files meet 75% line coverage

## Available Commands

Run `make help` to see all available commands:

| Command | Description |
|---------|-------------|
| `make setup` | Install dependencies and configure the project |
| `make build` | Build the project |
| `make test` | Run tests |
| `make test-coverage` | Run tests with code coverage |
| `make check-coverage` | Check coverage thresholds |
| `make lint` | Run SwiftLint |
| `make lint-fix` | Run SwiftLint with autocorrect |
| `make security-scan` | Run SAST and secret scanning |
| `make open` | Open in Xcode |
| `make generate` | Regenerate Xcode project |
| `make clean` | Clean build artifacts |
