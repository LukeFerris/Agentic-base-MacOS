# CLAUDE.md

## Project Overview

Flow - A native macOS application starter template built with SwiftUI, with built-in code quality and security tooling.

## Project Structure

- `Flow/Sources/` - Application source code (SwiftUI views)
- `Flow/Resources/` - Info.plist, asset catalogs, and other resources
- `Flow/Flow.entitlements` - App entitlements
- `FlowTests/` - XCTest unit tests
- `project.yml` - XcodeGen project definition (generates Flow.xcodeproj)
- `scripts/` - Build, test, coverage, and security scripts
- `.swiftlint.yml` - SwiftLint configuration

## Key Commands

```bash
make setup            # Install all dependencies and configure the project
make build            # Build the project
make test             # Run tests
make test-coverage    # Run tests with coverage
make check-coverage   # Check coverage thresholds
make lint             # Run SwiftLint (strict mode)
make lint-fix         # Run SwiftLint with autocorrect
make security-scan    # Run SAST and secret scanning
make open             # Open in Xcode
make generate         # Regenerate Xcode project from project.yml
make clean            # Clean build artifacts
make help             # Show all available commands
```

## Working Guidelines

1. You must generate a commit for every piece of completed work you do - ensuring the working directory is clean afterwards (no orphaned files)
2. Run `make generate` after modifying `project.yml` to regenerate the Xcode project
3. The Xcode project (Flow.xcodeproj) is generated and gitignored — never commit it

## Git Commit Rules

**CRITICAL: NEVER use `--no-verify` when committing.** Pre-commit hooks exist for security and code quality. If a commit fails due to pre-commit hooks:

1. Attempt to fix the issues in the staged files
2. If the issues cannot be resolved through code modifications, **stop and explain the situation to the user**
3. Do not bypass hooks under any circumstances - they are a security requirement
4. Do not change the git hooks that are in place
5. **You are responsible for fixing ALL linting, formatting, or other issues discovered during commit checks** - even if those issues exist in files you didn't modify or are unrelated to the work done in the current session. The goal is always a clean commit.

## Dependencies

- **Xcode 16+** with macOS 14.0+ SDK
- **XcodeGen** - Generates .xcodeproj from project.yml (`brew install xcodegen`)
- **SwiftLint** - Swift linting and style enforcement (`brew install swiftlint`)
- **Semgrep** - SAST scanning (`brew install semgrep`)
- **gitleaks** - Secret detection (`brew install gitleaks`)

Run `make setup` to install all dependencies automatically.

## Code Quality

- Never leave redundant code in the codebase - this is a greenfield project so we have no need to keep old code around
- All code must pass SwiftLint, security scans, and coverage thresholds before commit
- Coverage threshold: 75% line coverage for staged source files
