.PHONY: setup build test test-coverage lint clean open generate help

SCHEME = Flow
PROJECT = Flow.xcodeproj
DERIVED_DATA = .derivedData

## Setup & generation

setup: ## Install all dependencies and configure the project
	@bash scripts/setup.sh

generate: ## Regenerate the Xcode project from project.yml
	@xcodegen generate

open: generate ## Open the project in Xcode
	@open $(PROJECT)

## Build & test

build: generate ## Build the project
	@bash scripts/build.sh

test: generate ## Run tests
	@xcodebuild test \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		-quiet

test-coverage: generate ## Run tests with coverage
	@bash scripts/test-coverage.sh

check-coverage: ## Check coverage thresholds for all source files
	@bash scripts/check-coverage.sh Flow/Sources/*.swift Flow/Sources/**/*.swift

## Code quality

lint: ## Run SwiftLint
	@swiftlint lint --config .swiftlint.yml --strict

lint-fix: ## Run SwiftLint with autocorrect
	@swiftlint lint --config .swiftlint.yml --fix

## Security

security-scan: ## Run all security scans
	@bash scripts/security/check-sast.sh Flow/Sources/*.swift Flow/Sources/**/*.swift
	@bash scripts/security/check-secrets.sh Flow/Sources/*.swift Flow/Sources/**/*.swift

## Cleanup

clean: ## Clean build artifacts
	@xcodebuild clean -project $(PROJECT) -scheme $(SCHEME) -quiet 2>/dev/null || true
	@rm -rf $(DERIVED_DATA)
	@rm -rf $(PROJECT)
	@echo "Cleaned build artifacts and generated project."

## Help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
