# Light Agentic Template

A lightweight starter repo for building fullstack TypeScript applications on AWS. The goal is simple: get a React frontend and Node.js API running with security and quality guardrails enforced from the first commit, so you (or an AI coding agent) can iterate fast without cutting corners.

## What's in the box

### Application

- **Frontend** (`packages/frontend`) — React + Vite + Tailwind CSS. A single-page hello world that calls the backend API.
- **Backend** (`packages/backend`) — AWS Lambda function bundled with esbuild. A simple REST API with a `/hello` endpoint and a service layer pattern for business logic.

### Infrastructure

All infrastructure is defined as Terraform in `deployment/`. A single `yarn deploy` stands up:

- **S3 bucket** for static frontend assets
- **CloudFront distribution** with HTTPS and SPA routing
- **Lambda function** for the API
- **API Gateway** (REST) with CORS support
- **IAM roles** with least-privilege policies

Environment IDs and project names are auto-generated on first deploy and persisted to `terraform.tfvars` (gitignored) so subsequent deploys are stable.

### Security and quality guardrails

Every commit runs through a pre-commit hook chain via Husky + lint-staged:

| Check | Tool | What it catches |
|-------|------|-----------------|
| Secret detection | secretlint | API keys, tokens, credentials in source |
| Static analysis (SAST) | Semgrep | OWASP Top 10, TypeScript-specific vulnerabilities |
| Linting | ESLint | Code quality, complexity limits, max file/function size, JSDoc requirements |
| Dependency scanning (SCA) | OSV-Scanner | Known vulnerabilities in lockfile dependencies |
| Build verification | `yarn build` | TypeScript and bundling errors |
| Test suite | Vitest | Failing tests with coverage reporting |
| Coverage thresholds | Custom script | Per-file minimums: 75% statements, 60% branches, 75% functions, 75% lines |

None of these can be skipped — `--no-verify` is explicitly banned in the project conventions.

### Claude Code integration

The repo is designed to work well with AI coding agents, particularly Claude Code:

- **SessionStart hooks** (`.claude/settings.json`) automatically install security tools (Semgrep, OSV-Scanner, GitHub CLI), infrastructure tools (Terraform, AWS CLI), and run `yarn install` when a session begins.
- **CLAUDE.md** defines behavioral constraints: commit every piece of work, never bypass hooks, fix all lint/security issues even in files you didn't touch.
- **LLM-friendly error messages** in deploy scripts provide structured diagnostics so the agent can self-correct without human intervention.

## Getting started

### Prerequisites

- Node.js 20+
- Yarn 1.x
- AWS CLI configured with credentials (`aws configure`)
- Terraform 1.5+

If you're using Claude Code, the SessionStart hooks will install Terraform, AWS CLI, and security tools automatically.

### Install and build

```bash
yarn install
yarn build
```

### Run locally

```bash
yarn dev          # Start Vite dev server for frontend
yarn test         # Run tests in watch mode
yarn test:run     # Run tests once
```

### Deploy

```bash
yarn deploy            # Deploy everything (first time: creates all AWS resources)
yarn deploy:frontend   # Rebuild and upload frontend to S3 + invalidate CloudFront
yarn deploy:api        # Rebuild and update Lambda function code
```

On first run, `yarn deploy` initialises Terraform, creates all resources, uploads the frontend, and prints the live URLs. Subsequent runs apply only what changed.

### Verify setup

```bash
bash scripts/verify-setup.sh
```

Checks that all config files, npm dependencies, external tools, and git hooks are correctly installed.

## Project structure

```
.claude/settings.json              Claude Code session hooks
.husky/pre-commit                  Git pre-commit hook (lint-staged)
deployment/
  main.tf                          AWS infrastructure (S3, CloudFront, Lambda, API Gateway)
  variables.tf                     Configurable parameters (region, memory, timeout)
  outputs.tf                       Deployment outputs (URLs, resource names)
packages/
  frontend/                        React + Vite + Tailwind
  backend/                         AWS Lambda API (esbuild-bundled)
scripts/
  deploy/
    deploy-all.sh                  Full infrastructure + app deployment
    deploy-frontend.sh             Frontend-only deployment
    deploy-api.sh                  API-only deployment
  security/
    install-security-tools.sh      Installs Semgrep, OSV-Scanner, GitHub CLI
    check-sast.sh                  Runs Semgrep SAST on staged files
    check-dependencies.sh          Runs OSV-Scanner on lockfiles
  install-infra-tools.sh           Installs Terraform + AWS CLI
  check-staged-coverage.mjs        Per-file coverage threshold enforcement
  verify-setup.sh                  Validates the full hook chain
```

## Commands reference

| Command | Description |
|---------|-------------|
| `yarn build` | Build frontend and backend |
| `yarn dev` | Start frontend dev server |
| `yarn test` | Run tests in watch mode |
| `yarn test:run` | Run tests once |
| `yarn test:coverage` | Run tests with coverage report |
| `yarn lint` | Run ESLint |
| `yarn type-check` | TypeScript type checking |
| `yarn deploy` | Deploy everything to AWS |
| `yarn deploy:frontend` | Deploy frontend only |
| `yarn deploy:api` | Deploy API only |
