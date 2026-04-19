---
name: onboard
description: Project onboarding — spawns all 10 personas to assess an existing project cold. Reads the codebase, docs, infrastructure, and git history, then produces a baseline assessment with gaps, risks, and an initial backlog.
when_to_use: onboarding, new project, project assessment, baseline, first look, getting started, project health check
user-invocable: true
---

# Project Onboarding

This skill brings the full team up to speed on an existing project they've never seen. Each persona assesses the project from their domain, producing a baseline understanding with gaps, risks, and recommendations. This is a first-contact assessment — comprehensive, honest, and actionable.

## Process

### Step 0: Gather Project Context

Before spawning agents, collect what's available:

**Project structure:**
```bash
find . -type f -name "*.md" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" -o -name "*.tf" -o -name "*.py" -o -name "*.ts" -o -name "*.js" | head -100
```

**Documentation (read, not just list):**
```bash
cat README.md 2>/dev/null
cat CLAUDE.md 2>/dev/null
cat CONTRIBUTING.md 2>/dev/null
cat DEVELOPMENT.md 2>/dev/null
cat SECURITY.md 2>/dev/null
cat CHANGELOG.md 2>/dev/null | head -50
ls docs/ adrs/ docs/adrs/ runbooks/ 2>/dev/null
```

**Git history — activity, contributors, releases:**
```bash
git log --oneline -20 2>/dev/null
git shortlog -sn --since="3 months ago" 2>/dev/null
git tag -l --sort=-version:refname | head -10 2>/dev/null
```

**Stack — packages, toolchain versions:**
```bash
cat package.json 2>/dev/null | head -40
cat pyproject.toml 2>/dev/null | head -40
cat requirements.txt 2>/dev/null | head -20
cat go.mod 2>/dev/null | head -10
cat .tool-versions .nvmrc .python-version mise.toml 2>/dev/null
```

**Infrastructure & service topology (read, not just list):**
```bash
cat docker-compose*.yml 2>/dev/null
cat Dockerfile* 2>/dev/null
ls -la terraform/ infrastructure/ deploy/ ansible/ 2>/dev/null
cat .env.example 2>/dev/null
```

**CI/CD (read full workflows):**
```bash
cat .github/workflows/*.yml 2>/dev/null
```

**Database — schema, ORM, migrations:**
```bash
ls -la migrations/ alembic/ 2>/dev/null
cat schema.sql schema.prisma 2>/dev/null | head -50
find . -name "models.py" -o -name "*.entity.ts" -o -name "schema.prisma" 2>/dev/null | head -10
```

**Security — secrets, scanning, auth:**
```bash
ls -la .env .env.* secrets/ vault/ 2>/dev/null
grep -r "SAST\|DAST\|SCA\|security\|trivy\|semgrep\|bandit\|gitleaks" .github/workflows/ 2>/dev/null
```

**Testing — config, fixtures, coverage:**
```bash
ls -la tests/ test/ __tests__/ spec/ 2>/dev/null
cat pytest.ini jest.config.* playwright.config.* .coveragerc 2>/dev/null | head -30
ls -la fixtures/ factories/ conftest.py k6/ locust/ 2>/dev/null
```

**Observability — monitoring, alerting config:**
```bash
cat prometheus.yml alertmanager.yml otel-collector-config.yaml 2>/dev/null | head -30
ls -la grafana/ 2>/dev/null
grep -rl "health\|readiness\|liveness" --include="*.py" --include="*.ts" --include="*.js" | head -5 2>/dev/null
```

**Code quality — linting, formatting, PR templates:**
```bash
cat .eslintrc* .prettierrc* ruff.toml .editorconfig 2>/dev/null | head -30
cat pyproject.toml 2>/dev/null | grep -A 20 "\[tool.ruff\]"
cat .github/pull_request_template.md 2>/dev/null
```

**Design system — frontend artifacts:**
```bash
ls -la storybook/ 2>/dev/null
find . -name "*.stories.*" -o -name "tokens.json" -o -name "theme.ts" 2>/dev/null | head -10
```

**Documentation site:**
```bash
cat mkdocs.yml docusaurus.config.js conf.py 2>/dev/null | head -20
```

**Task runners:**
```bash
cat Makefile justfile 2>/dev/null | head -30
```

**Beads:**
```bash
bd status 2>/dev/null
bd list --status open 2>/dev/null | head -20
```

Collect what's available. **Read files, don't just check existence** — the content is what agents need. Missing items are findings in themselves.

### Step 1: Determine Depth

**Quick mode** — high-level assessment, 30-minute read:
- Each agent produces a status (Green/Yellow/Red) + top 3 findings
- Output is a concise project health scorecard

**Full mode** — deep assessment, thorough analysis:
- Each agent does a complete domain review
- Output is a comprehensive baseline document with detailed findings

Default to **quick** for initial orientation. Use **full** when making investment decisions or before a major project phase.

### Step 2: Spawn Parallel Agents

Launch all 10 persona agents simultaneously. Each gets the project context gathered in Step 0.

#### Security Engineer Agent
```
Read ~/.claude/skills/security-engineer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the Security Engineer. You are seeing this project for the first time. Assess it from a security perspective.

Depth: [quick|full]

Project Context:
[paste gathered context from Step 0]

Assess:
- Attack surface — what's exposed? APIs, endpoints, authentication mechanisms, exposed ports, CORS config
- Dependency health — run vulnerability checks if possible (npm audit, pip-audit, trivy). Known CVEs?
- Security scanning — is SAST/DAST/SCA in the CI/CD pipeline? What tools, what's missing?
- Secrets management — hardcoded credentials? .env files committed? Vault integration?
- Authentication/authorization — how is it implemented? Session management? Any obvious gaps?
- Compliance posture — any regulatory requirements visible? Which frameworks apply?
- Data handling — PII, encryption at rest/transit, data classification, security headers

Rate: RED (active vulnerabilities or critical gaps) / YELLOW (concerns developing) / GREEN (reasonably secure)
```

#### IT Architect Agent
```
Read ~/.claude/skills/it-architect/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the IT Architect. You are seeing this project for the first time. Assess the architecture.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- Architecture style — monolith, microservices, serverless? Is it appropriate for the problem?
- Technology choices — are they portable? Open-source? Vendor lock-in risks? Exit paths?
- API surface — what APIs exist? Versioned? OpenAPI spec? Data flow between components?
- Scalability path — can this handle 10x? Where are the bottlenecks?
- Operational model — IaC, CI/CD, observability, deployment strategy
- Cost model — any obvious cost inefficiencies?
- Phase assessment — is this Phase 1 (getting started) or Phase 2 (scaling)?
- Single points of failure — what breaks if one component goes down?
- ADR inventory — do architectural decision records exist? Are they current?

Rate: RED / YELLOW / GREEN
```

#### Project Manager Agent
```
Read ~/.claude/skills/project-manager/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the Project Manager. You are seeing this project for the first time. Assess delivery health.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- Project organization — is work tracked? Beads, issues, board?
- Backlog health — is there a backlog? Is it groomed? Stale items?
- Velocity signals — git commit frequency, PR merge rate, release cadence, release tags
- Risk visibility — any documented risks? Any obvious undocumented ones?
- Team structure — who's contributing? Bus factor? Stakeholder map?
- Process — any visible ceremonies, conventions, or workflow? CONTRIBUTING.md?
- Documentation of decisions — ADRs, meeting notes, design docs?
- Release history — git tags, versioning convention, release cadence

Rate: RED / YELLOW / GREEN
```

#### Project Engineer Agent
```
Read ~/.claude/skills/project-engineer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the Project Engineer. You are seeing this project for the first time. Assess implementation quality.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- Stack — languages, frameworks, versions. Are they current? Toolchain version management (.tool-versions, .nvmrc)?
- Code organization — project structure, module boundaries, separation of concerns, monorepo vs. polyrepo
- Test coverage — unit, integration, E2E. TDD evidence? Test quality?
- CI/CD — pipeline exists? What does it run? Security scans? Deployment automation?
- IaC — Terraform, Ansible, or manual? State management?
- Developer experience — can you set up locally? docker-compose? Makefile/justfile? README setup instructions actually work?
- Technical debt signals — TODO comments, disabled tests, workarounds, version pinning
- Build tooling — task runners, code generation, build artifacts

Rate: RED / YELLOW / GREEN
```

#### UX Designer Agent
```
Read ~/.claude/skills/ux-designer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the UX Designer. You are seeing this project for the first time. Assess user experience.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- User-facing interfaces — web, mobile, API, CLI? What exists?
- Design system — is there one? Storybook, design tokens, component library? What CSS approach?
- Accessibility — any evidence of accessibility consideration?
- Error handling UX — loading states, error states, empty states present?
- API design — if API-first, are the contracts clean? Swagger/OpenAPI?
- User documentation — does the end user have docs, help, onboarding?
- Responsive/cross-platform — if web, is it responsive? If multi-platform, consistent?
- Note: if no user-facing interface exists (API-only/backend), focus on API ergonomics and developer experience instead

Rate: RED / YELLOW / GREEN
```

#### Code Reviewer Agent
```
Read ~/.claude/skills/code-reviewer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the Code Reviewer. You are seeing this project for the first time. Assess code quality and standards.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- Code style consistency — linting configured (.eslintrc, ruff.toml, .prettierrc)? Formatting enforced? .editorconfig?
- Naming conventions — consistent? Self-describing? Any drift?
- Test quality — meaningful assertions? Anti-patterns? Flaky tests?
- API conventions — naming, response structure, error handling, versioning
- PR practices — branch strategy, review requirements, merge policy, PR templates?
- Dependencies — up to date? Unnecessary? Duplicated functionality?
- Code comments — "why" comments or noise? Missing context on complex logic?
- Branch protection — configured? What blocks merge?

Rate: RED / YELLOW / GREEN
```

#### Database Engineer Agent
```
Read ~/.claude/skills/database-engineer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the Database Engineer. You are seeing this project for the first time. Assess the data layer.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- Database engine(s) — what's used? Check docker-compose services and connection strings. Appropriate for the workload?
- Schema design — normalized? Constraints in the database? Foreign keys? Read ORM model files
- Migrations — tooling, versioning, reversibility? Any pending?
- ORM usage — if present, is it generating efficient SQL? ORM configuration?
- Indexing — coverage based on visible query patterns?
- Backup/recovery — any evidence of backup strategy?
- Data volume — any signals about scale? Growth trajectory?
- Database connection patterns — pooling configured? Connection management?

Rate: RED / YELLOW / GREEN
```

#### SRE Agent
```
Read ~/.claude/skills/sre/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the SRE. You are seeing this project for the first time. Assess operational readiness.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- SLOs — defined? Measured? Error budgets? Check for SLO definition files
- Observability — metrics, logging, tracing present? Structured? Correlated? Check for prometheus.yml, alertmanager.yml, OTel config
- Instrumentation standards — metric naming, log format, cardinality management?
- Alerting — alerts configured? Runbooks exist? Alert fatigue? Check for alerting rules
- Deployment — health checks, readiness probes, graceful shutdown, rollback? Grep for health endpoints
- Dashboards — Grafana provisioning files? Dashboard-as-code?
- Capacity — resource sizing, auto-scaling, headroom?
- Incident preparedness — on-call, escalation, postmortem process? Status page?
- Observability cost — any signals about data volume, retention, cost?

Rate: RED / YELLOW / GREEN
```

#### QA Engineer Agent
```
Read ~/.claude/skills/qa-engineer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the QA Engineer. You are seeing this project for the first time. Assess test strategy.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- Test pyramid — shape? Inverted? Missing layers? Check test config files (pytest.ini, jest.config)
- Test environments — local, CI, preprod, performance? Parity with prod?
- Test data — production snapshots, synthetic, hardcoded fixtures? Check fixtures/, factories/, conftest.py
- Performance testing — evidence of load testing (k6/, locust/)? Baselines established?
- Flaky tests — any visible? Skipped tests? Disabled tests?
- Coverage — configured? Reports available? What's the coverage?
- Regression strategy — curated suite or accumulated? Run frequency?
- CI test integration — tests in pipeline? What blocks merge?

Rate: RED / YELLOW / GREEN
```

#### Technical Writer Agent
```
Read ~/.claude/skills/technical-writer/SKILL.md and ~/.claude/skills/_shared/engineering-discipline.md.

You are the Technical Writer. You are seeing this project for the first time. Assess documentation.

Depth: [quick|full]

Project Context:
[paste gathered context]

Assess:
- README — exists? Current? Actually read it — do the setup instructions work, or is it a stub?
- API documentation — exists? Swagger endpoint? Accurate? Docs site (mkdocs, docusaurus, sphinx)?
- Architecture docs — exist? Current? Diagrams? Do they match the actual architecture?
- Runbooks — exist? Tested? Cover all alerts?
- Onboarding guide — can a new person get productive from the docs alone?
- Changelog — exists? Maintained? Follows Keep a Changelog?
- Code comments — sample 2-3 complex files. "Why" comments or noise?
- ADRs — exist? Current? Referenced? Produce an inventory
- CONTRIBUTING.md — exists? Covers branching, PR process, conventions?
- Documentation site — configured? Deployed? Current?
- Produce a documentation inventory as a first-class artifact for the onboarding report

Rate: RED / YELLOW / GREEN
```

### Step 3: Produce the Baseline Assessment

Synthesize all 10 agent assessments into a unified onboarding report.

```markdown
# Project Onboarding: [Project Name]

## Date: [Date]
## Assessed By: Security Engineer, IT Architect, Project Manager, Project Engineer, UX Designer, Code Reviewer, Database Engineer, SRE, QA Engineer, Technical Writer
## Depth: [Quick | Full]

## Health Scorecard

| Domain | Persona | Status | Top Concern |
|--------|---------|:------:|-------------|
| Security | Security Engineer | [R/Y/G] | [One-line summary] |
| Architecture | IT Architect | [R/Y/G] | [One-line summary] |
| Delivery | Project Manager | [R/Y/G] | [One-line summary] |
| Implementation | Project Engineer | [R/Y/G] | [One-line summary] |
| User Experience | UX Designer | [R/Y/G] | [One-line summary] |
| Code Quality | Code Reviewer | [R/Y/G] | [One-line summary] |
| Data Layer | Database Engineer | [R/Y/G] | [One-line summary] |
| Operations | SRE | [R/Y/G] | [One-line summary] |
| Testing | QA Engineer | [R/Y/G] | [One-line summary] |
| Documentation | Technical Writer | [R/Y/G] | [One-line summary] |

## Critical Findings (RED items)
[Any domain that rated RED — full details, immediate action required]

## Concerns (YELLOW items)
[Any domain that rated YELLOW — developing issues that need attention]

## What's Working Well (GREEN items)
[Domains that are healthy — credit what's done well]

## Documentation Inventory

This is a cross-cutting reference — every persona needs to know what docs exist.

| Document | Location | Status | Notes |
|----------|----------|--------|-------|
| README | ./README.md | [Current / Stale / Missing] | [Has setup instructions? / Stub?] |
| API Reference / Swagger | [path or URL] | [Current / Stale / Missing] | ... |
| Architecture Overview | [path] | [Current / Stale / Missing] | ... |
| ADRs | [path] | [X found / Missing] | ... |
| Onboarding Guide | [path] | [Current / Stale / Missing] | ... |
| Runbooks | [path] | [X found / Missing] | ... |
| Changelog | ./CHANGELOG.md | [Current / Stale / Missing] | ... |
| Contributing Guide | ./CONTRIBUTING.md | [Current / Stale / Missing] | ... |
| Security Policy | ./SECURITY.md | [Current / Stale / Missing] | ... |
| Developer Guide | [path] | [Current / Stale / Missing] | ... |
| Design System Docs | [path] | [Current / Stale / Missing] | ... |
| Docs Site | [mkdocs.yml / docusaurus / etc.] | [Exists / Missing] | ... |

## ADR Inventory

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [ADR-001] | ... | [Accepted / Superseded / Missing] | ... |
| ... or "No ADRs found" | | | |

## Cross-Domain Findings
[Issues flagged by multiple personas — these are the strongest signals]

| Finding | Flagged By | Impact |
|---------|-----------|--------|
| ... | [Multiple personas] | ... |

## Conflicts Between Personas
[Where personas disagree about the project state — surface both perspectives]

## Recommended First Actions
| # | Action | Priority | Owner | Rationale |
|---|--------|----------|-------|-----------|
| 1 | ... | P0-P3 | [Persona] | ... |
| 2 | ... | P0-P3 | [Persona] | ... |

## PO Decisions Needed
[If the assessment reveals decisions that need PO input before work begins]

| Decision | Context | Options |
|----------|---------|---------|
| ... | ... | ... |
```

### Step 4: Set Up Project Infrastructure

If beads is not initialized:
```bash
bd init
```

Create initial beads from the critical and high-priority findings:
- RED findings → Priority 0-1 beads
- YELLOW findings → Priority 2 beads
- GREEN items → No beads needed

### Step 5: Recommend Next Steps

Based on the assessment, recommend which ceremony to run next:
- Many RED findings → `/team-review` in full mode to deep-dive
- Architecture concerns → `/spike` with Architect + relevant personas
- Backlog empty → `/team-plan` to create the roadmap
- Everything green → Start building, use `/standup` daily

## Rules

- **This is a first impression, not a verdict.** The team is seeing the project cold. Findings may be wrong — context the team doesn't have yet may explain things that look like problems
- **Missing things are findings.** No tests, no docs, no CI/CD, no SLOs — these are not "not applicable," they are gaps
- **Credit what's done well.** An onboarding report that only lists problems is demoralizing and incomplete. Acknowledge good work explicitly
- **Cross-domain signals are strongest.** When the Security Engineer and the Code Reviewer independently flag the same issue, that's a higher-confidence finding than either alone
- **Don't prescribe solutions in onboarding.** Identify problems and recommend the right ceremony to solve them. The onboarding report says "what is" — the team-plan says "what to do about it"
