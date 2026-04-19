# Claude Agent Dev Team

A set of Claude Code skills that simulate a full software development team with distinct professional personas. Each persona has domain expertise, professional biases, and the authority to disagree with the others. This is not a committee that politely agrees — it's a team that argues, commits, and ships.

## Why

LLMs have a tendency to "silently average" — producing safe, consensus-driven output that avoids conflict. In real teams, the best outcomes come from domain experts who advocate hard for their perspective, disagree openly, and then commit fully once a decision is made. 99% alignment, 1% vision.

This project creates that dynamic by giving each persona:
- **Domain authority** — each role owns their decisions within their expertise
- **Professional bias** — each role naturally advocates for and is skeptical of specific things
- **Known failure modes** — documented LLM tendencies (subsampling, theorizing before reading evidence, premature implementation) with corrective behaviors front-loaded
- **Conflict resolution protocol** — structured disagreement with clear escalation paths
- **A voice in retrospectives** — every persona evaluates the session through their lens

The result: when you run `/team-plan` or `/team-review`, ten agents work in parallel, each bringing their genuine domain perspective, and the synthesis surfaces real conflicts for the Product Owner to decide — not smoothed-over consensus.

## The Team

| Persona | Slash Command | Domain |
|---------|--------------|--------|
| **Security Engineer** | `/security-engineer` | AppSec, infrastructure/network security, multi-cloud, compliance (OWASP, NIST CSF, CIS, ISO 27001, SOC 2, Zero Trust). Quantified risk ratings — not everything is Critical |
| **IT Architect** | `/it-architect` | System design with Phase 1 (get started) and Phase 2 (scale properly). Hybrid multi-cloud, open-source first, no vendor lock-in, cost-aware. Microservices when justified, not by default |
| **Project Manager** | `/project-manager` | Agile Scrum Master. Sprint planning, backlog management, risk tracking using [beads](https://github.com/steveyegge/beads) (`bd`) for board/work management. The user is the Product Owner |
| **Project Engineer** | `/project-engineer` | Full-stack implementation. Node/React frontend, Python backend, Terraform IaC, Ansible config management, GitHub Actions CI/CD. TDD — tests first, always |
| **UX Designer** | `/ux-designer` | Web and mobile, customer-facing and internal. API-first design — every wireframe includes the API call that powers it. Builds design systems from scratch. Heuristic evaluation by default |
| **Code Reviewer** | `/code-reviewer` | Code quality authority and style guide owner. Reviews for test quality (#1), correctness, security, API design, maintainability, performance, style. Can block merges. Mentoring tone |
| **Database Engineer** | `/database-engineer` | Schema design, data modeling, query optimization, migration safety. Constraints belong in the database, not just the application. The person who asks "what happens at 50M rows?" |
| **SRE** | `/sre` | Site reliability AND observability platform — SLOs, instrumentation standards, metrics/logging/tracing, dashboards, alert design, incident response, capacity planning, on-call, chaos engineering, observability cost management. Builds and consumes the observability platform |
| **QA Engineer** | `/qa-engineer` | Holistic test strategy, test environments, test data, performance testing, regression curation, chaos testing. Complements TDD with strategic quality thinking |
| **Technical Writer** | `/technical-writer` | Documentation as a product. API docs, runbooks, onboarding guides, architecture docs, changelogs. If it's not documented, it doesn't exist |

## Team Skills

| Skill | Command | Purpose |
|-------|---------|---------|
| **Team Plan** | `/team-plan` | Spawns all 10 personas in parallel to analyze a project brief. Surfaces conflicts, facilitates debate, produces unified plan with PO decision points |
| **Team Review** | `/team-review` | Spawns all 10 personas in parallel to review existing work. Consolidates findings, surfaces disagreements, produces prioritized action items |
| **Standup** | `/standup` | Daily pulse — red/yellow/green across all 10 personas. Green stays silent. Blockers first, PO decisions surfaced |
| **Grooming** | `/grooming` | Backlog refinement — pull upcoming beads, each persona evaluates readiness, sizes effort, identifies dependencies, defines acceptance criteria |
| **Spike** | `/spike` | Targeted investigation — spawns only relevant personas to answer a specific question blocking a decision. Timeboxed, evidence-based |
| **Postmortem** | `/postmortem` | Blameless incident analysis — SRE-led, timeline-driven, evidence-based. Contributing factors from each relevant persona, action items tracked as beads |
| **Retrospective** | `/retro` | End-of-session retrospective. Honest assessment including PO feedback, agent self-critique, and each persona's perspective with disagreements |

## Shared Foundations

| File | Purpose |
|------|---------|
| `_shared/conflict-resolution.md` | How personas disagree and resolve conflicts. Domain authority, escalation to PO, disagree-and-commit protocol. Critical security findings are non-negotiable |
| `_shared/engineering-discipline.md` | Evidence over intuition. Verify before asserting. Completeness over sampling. Known failure modes. Naming discipline. One-way door protocol |

## Key Design Decisions

### Conflict Is Expected
Each persona has a "Professional Perspective" section that defines what they advocate for, what they're skeptical of, and when they should push back even if everyone else agrees. The security engineer fights for security. The PM fights for shipping. The UX designer fights for the user. These biases collide — by design.

### Security Escalation Tiers
- **Critical (9.0-10.0)**: Non-negotiable. PO cannot override. Work stops
- **High (7.0-8.9)**: Gets priority. PO sequences but can't defer indefinitely
- **Medium (4.0-6.9)**: PO weighs cost of fix against actual risk
- **Low/Informational (0.0-3.9)**: Lowest priority. Address when convenient

### Engineering Discipline (Identity Primer)
Front-loading known LLM failure modes into each persona produces significantly better session outcomes. The project engineer gets a deep version with explicit failure modes. All personas reference the shared principles. The cost of ~100 lines of context at session start is far cheaper than reworking things because the agent wouldn't follow instructions the first time.

### Tiered Security Scanning
- **Dev**: No scan gates. Move fast, break things
- **Preprod**: All scans must pass (SAST, DAST, SCA, IaC, secrets, containers). This is the gate
- **Prod**: Same artifact that passed preprod. Manual approval + smoke tests

### The PO Has Final Say (With One Exception)
The Product Owner makes all product and priority decisions. The one exception: Critical security findings are non-negotiable — no one overrides them, not even the PO.

## Installation

### Quick Install (recommended)

**macOS / Linux:**
```bash
git clone https://github.com/MotWakorb/claude-agent-dev-team.git
cd claude-agent-dev-team
./install.sh
```

**Windows (PowerShell 7+):**
```powershell
git clone https://github.com/MotWakorb/claude-agent-dev-team.git
cd claude-agent-dev-team
./install.ps1
```

This **symlinks** the skills into `~/.claude/skills/`. Updates are just:

```bash
cd claude-agent-dev-team
git pull
```

No re-install needed — symlinks pick up changes automatically.

> **Windows note:** Creating symlinks may require running as Administrator or enabling Developer Mode (Settings > Update & Security > For developers).

### Install Options

**Bash:**
```bash
./install.sh            # Symlink (default) — git pull updates automatically
./install.sh --copy     # Copy instead — for customization without affecting the repo
./install.sh --uninstall  # Remove all installed skills
./install.sh --help     # Show options
```

**PowerShell:**
```powershell
./install.ps1            # Symlink (default)
./install.ps1 -Copy      # Copy instead
./install.ps1 -Uninstall # Remove installed skills
```

### Manual Install

If you prefer to copy specific skills:

```bash
mkdir -p ~/.claude/skills
cp -R _shared ~/.claude/skills/_shared
cp -R security-engineer ~/.claude/skills/security-engineer
# ... copy whichever skills you want
mkdir -p ~/retros
```

### Project-Specific Install

To install for a single project instead of globally, copy into your project's `.claude/skills/` directory.

## Usage

### Individual Personas

Invoke any persona directly for domain-specific consultation:

```bash
/security-engineer Review the authentication module for vulnerabilities
/it-architect Design a system for real-time event processing
/project-manager Plan the next sprint based on the current backlog
/project-engineer Implement the user registration endpoint
/ux-designer Design the onboarding flow for new users
/code-reviewer Review this PR for quality and consistency
/database-engineer Design the schema for the orders system
/sre Define SLOs for the payment service
/observability-engineer Design the instrumentation plan for this service
/qa-engineer Create a test strategy for the checkout flow
/technical-writer Audit the documentation for the API
```

### Ceremonies

Use ceremonies to coordinate the full team:

```bash
/standup             # Daily pulse — red/yellow/green, blockers only
/grooming            # Refine backlog items for sprint readiness
/team-plan           # Full team planning for a new project or sprint
/spike               # Targeted investigation to unblock a decision
/team-review         # Full team review of existing work
/postmortem          # Blameless incident analysis
/retro               # End-of-session retrospective
```

### Ceremony Workflow

Here's when to use each ceremony in a typical project lifecycle:

```
Project Start
  └─ /team-plan (full) ─── Deep planning, all personas, architecture + security + UX + implementation
       └─ Creates initial epics and beads

Sprint Cycle
  ├─ /grooming ─────────── Refine upcoming backlog items before sprint planning
  ├─ /team-plan (quick) ── Sprint planning — commit work, identify dependencies
  ├─ /standup ──────────── Daily — red/yellow/green, blockers, PO decisions
  ├─ /spike ───────────── As needed — unblock decisions with targeted investigation
  ├─ /team-review ─────── Sprint review — evaluate what shipped
  └─ /retro ───────────── End of session — honest assessment, persona perspectives

When Things Break
  └─ /postmortem ────────── Blameless analysis, timeline, root cause, action items as beads
```

### Quick vs Full Mode

`/team-plan`, `/team-review`, and `/grooming` support depth modes:
- **Quick**: Bullet points, top 2-3 conflicts, concise output
- **Full**: Complete structured output per each persona's format

`/spike` always targets only relevant personas (2-4), not all 11.
`/standup` is always fast — green is silent.
`/postmortem` includes only personas relevant to the incident.

## How the Team Interacts

Every pair of personas (55 unique pairs across 11 personas) has documented bidirectional interactions. Each persona knows:
- What they own (domain authority)
- What other personas own (where to defer)
- Where they'll naturally disagree (professional bias)
- How to resolve conflicts (shared protocol)

### Key Tension Points

These are by design — the personas will argue about these:

| Tension | Personas | What They'll Argue About |
|---------|----------|------------------------|
| Security vs. Speed | Security ↔ PM, Engineer | How much security for Phase 1? Sprint scope vs. remediation |
| Complexity vs. Simplicity | Architect ↔ Engineer | Is this design over-engineered or appropriately future-proof? |
| Quality vs. Velocity | Code Reviewer ↔ Engineer, PM | Style blocks when the sprint is burning |
| User Experience vs. Constraints | UX ↔ Security, Architect, Engineer | Security friction, architectural limits, technical feasibility |
| Reliability vs. Features | SRE ↔ PM | Error budget spent — feature freeze or keep shipping? |
| Data Integrity vs. Speed | DBA ↔ Engineer, Architect | Normalize or denormalize? Migration safety vs. velocity |
| Observability Cost vs. Signal | Observability ↔ SRE | 100% trace sampling vs. budget |
| Test Coverage vs. Shipping | QA ↔ PM, Engineer | Performance testing before launch or after? |
| Documentation vs. "Later" | Technical Writer ↔ Everyone | Is docs part of done, or a follow-up that never happens? |

### RACI Matrix

R = Responsible (does the work), A = Accountable (final decision), C = Consulted (input before decision), I = Informed (notified after)

This matrix was reviewed by all personas in parallel. Contested decisions were resolved by the PO. The Observability Engineer was merged into the SRE — the SRE now owns the observability platform, instrumentation standards, and cost management in addition to reliability.

#### Design & Planning

| Activity | PO | PM | Arch | SecEng | Eng | UX | CR | DBA | SRE | QA | TW |
|----------|:--:|:--:|:----:|:------:|:---:|:--:|:--:|:---:|:---:|:--:|:--:|
| **Requirements & Scope** | A | R | C | C | I | C | I | C | I | C | C |
| **Architecture Design** | A | I | R | C | C | C | I | C | C | C | C |
| **Technology Selection** | A | C | R | C | C | C | C | C | C | C | I |
| **API Contract Design** | A | I | R | C | C | C | C | C | I | C | C |
| **ADRs** | A | C | R | C | C | I | C | C | C | I | C |
| **UX Design** | A | I | C | C | I | R | I | I | I | C | C |
| **Design System Definition** | A | I | C | C | C | R | C | I | I | I | C |
| **Schema / Data Modeling** | A | I | C | C | C | I | I | R | I | I | I |
| **DR/HA Design** | A | C | R | C | C | C | I | C | C | C | C |
| **Cost Modeling** | A | C | R | I | C | I | I | C | C | I | I |

#### Security & Compliance

| Activity | PO | PM | Arch | SecEng | Eng | UX | CR | DBA | SRE | QA | TW |
|----------|:--:|:--:|:----:|:------:|:---:|:--:|:--:|:---:|:---:|:--:|:--:|
| **Security Assessment** | A | I | C | R | C | I | C | C | C | I | C |
| **Threat Modeling** | A | I | C | R | C | I | I | C | I | C | C |
| **Compliance & Audit** | A | C | C | R | C | I | I | C | I | I | C |
| **Secrets Management** | I | C | C | A | R | I | C | I | C | I | C |
| **Security Scan Pipeline** | I | I | C | A | C | I | I | I | R | I | I |

#### Implementation & Quality

| Activity | PO | PM | Arch | SecEng | Eng | UX | CR | DBA | SRE | QA | TW |
|----------|:--:|:--:|:----:|:------:|:---:|:--:|:--:|:---:|:---:|:--:|:--:|
| **Implementation** | A | I | C | C | R | C | C | C | C | C | I |
| **Code Review** | I | I | I | C | C | C | R | C | C | I | I |
| **TDD / Unit+Integration Tests** | I | I | I | C | R | I | C | C | I | C | I |
| **Test Strategy** | A | I | C | C | C | I | C | C | C | R | I |
| **Test Environment Management** | I | C | C | C | C | I | I | C | C | R | I |
| **Test Data Strategy** | I | I | I | C | C | I | I | C | I | R | I |
| **Performance Testing** | I | I | C | C | C | I | I | C | C | R | I |
| **Chaos / Resilience Testing** | I | C | C | C | C | I | I | C | R | C | C |

#### Infrastructure & Operations

| Activity | PO | PM | Arch | SecEng | Eng | UX | CR | DBA | SRE | QA | TW |
|----------|:--:|:--:|:----:|:------:|:---:|:--:|:--:|:---:|:---:|:--:|:--:|
| **IaC (Terraform/Ansible)** | A | I | R | C | R | I | I | I | C | C | C |
| **CI/CD — Build & Deploy** | I | C | C | C | R | I | C | C | R | C | I |
| **CI/CD — Test Gates** | I | I | I | C | C | I | C | I | C | R | I |
| **Deployment** | A | C | C | C | R | C | C | C | R | C | C |
| **Database Migration** | A | I | C | C | C | I | C | R | C | C | C |
| **Backup & Recovery** | A | C | C | C | C | I | I | R | C | C | C |
| **Capacity Planning** | A | C | C | I | C | I | I | C | R | I | I |

#### Observability & Reliability

| Activity | PO | PM | Arch | SecEng | Eng | UX | CR | DBA | SRE | QA | TW |
|----------|:--:|:--:|:----:|:------:|:---:|:--:|:--:|:---:|:---:|:--:|:--:|
| **Observability Design** | A | I | C | C | C | C | C | C | R | C | I |
| **Observability Platform & Standards** | I | I | C | C | C | C | C | C | R | C | C |
| **SLO Definition** | A | I | C | C | C | C | I | I | R | I | C |
| **Alert / Runbook Design** | I | I | C | C | C | I | I | I | R | I | C |
| **Incident Response** | I | C | C | R | C | C | I | C | R | I | C |
| **Postmortem** | I | C | C | R | C | I | I | C | R | C | C |

#### Process & Documentation

| Activity | PO | PM | Arch | SecEng | Eng | UX | CR | DBA | SRE | QA | TW |
|----------|:--:|:--:|:----:|:------:|:---:|:--:|:--:|:---:|:---:|:--:|:--:|
| **Sprint Planning** | A | R | I | I | C | I | I | C | C | C | C |
| **Backlog Grooming** | A | R | C | C | C | C | C | C | C | C | C |
| **Release Management** | A | R | C | C | C | C | C | I | R | C | C |
| **Risk Management** | A | R | C | C | C | I | I | I | C | I | I |
| **Documentation** | I | I | C | C | C | C | C | C | C | C | R |
| **Documentation Audit** | I | C | I | I | I | C | I | I | I | I | R |
| **Onboarding Guide** | I | C | C | C | C | C | C | C | C | C | R |

**Key principles:**
- **PO is Accountable** for all product decisions — requirements, scope, architecture, deployment, risk acceptance
- **PM is Responsible** for process — sprint planning, grooming, release management, risk management
- **Domain experts are Responsible** for their domain — Security owns assessments and threat modeling, DBA owns schema and backups, SRE owns incidents and capacity, QA owns test strategy and environments
- **Architect is Responsible** for API contract design, ADRs, DR/HA design, cost modeling, and co-R on IaC
- **Security Engineer is Accountable** for secrets management and the scan pipeline — sets policy, others implement
- **Activities are split where co-ownership was contested** — CI/CD (Build & Deploy vs. Test Gates), Test Strategy vs. TDD/Unit+Integration
- **Everyone is Consulted** during grooming — every persona evaluates backlog items
- **Implementation involves the whole team** — DBA, SRE, UX, ObsEng, QA, and CR are all Consulted, not just Informed

### Conflict Resolution

All conflicts follow the shared protocol (`_shared/conflict-resolution.md`):
1. **Domain authority decides within their domain** — Security on risk, Architect on design, Code Reviewer on quality
2. **Cross-domain conflicts escalate to the PO** — the PO weighs trade-offs and decides
3. **Critical security findings are non-negotiable** — no one overrides, not even the PO
4. **Disagree and commit is documented** — the ADR or bead captures what, who, and why

## Customization

These skills are designed to be adapted. If you install with `--copy`, you can modify freely. If you install with symlinks (default), fork the repo first or copy individual skills you want to customize.

### What to Customize

| What | Where | Why |
|------|-------|-----|
| **Technology stack** | `project-engineer/SKILL.md` | Default is Node/React + Python + Terraform + Ansible. Change to your stack |
| **Security frameworks** | `security-engineer/SKILL.md` | Default is OWASP, NIST CSF, CIS, ISO 27001, SOC 2, Zero Trust. Add HIPAA, PCI-DSS, GDPR, etc. |
| **Board tool** | `project-manager/SKILL.md` | Default is [beads](https://github.com/steveyegge/beads) (`bd`). Swap for Jira CLI, Linear, GitHub Issues, etc. |
| **API conventions** | `code-reviewer/SKILL.md` | Default is REST with snake_case, versioned URLs, standard envelopes. Adjust for GraphQL, gRPC, etc. |
| **Design system** | `ux-designer/SKILL.md` | Default is build-from-scratch. Point to your existing design system |
| **Observability stack** | `observability-engineer/SKILL.md` | Default evaluates per-project. Set your standard stack (Datadog, Grafana Cloud, etc.) |
| **Database preferences** | `database-engineer/SKILL.md` | Default is PostgreSQL-primary. Adjust for your data platform |
| **Retro location** | `retro/SKILL.md` | Default is `~/retros/`. Change to your preferred location |
| **Conflict resolution** | `_shared/conflict-resolution.md` | Adjust domain authority boundaries, security escalation tiers, or the disagree-and-commit protocol |
| **Engineering discipline** | `_shared/engineering-discipline.md` | Add your own known failure modes, naming conventions, or principles |

### Adding New Personas

To add a new persona, create a directory with a `SKILL.md`:

```
~/.claude/skills/my-persona/SKILL.md
```

Follow the pattern established by existing personas:
1. YAML frontmatter (`name`, `description`, `when_to_use`, `user-invocable: true`)
2. Reference the shared engineering discipline and conflict resolution protocol
3. Define the persona's domain, philosophy, and methodology
4. Add a Professional Perspective section (what they advocate for, what they're skeptical of)
5. Add a Conflict Resolution section with domain-specific guidance
6. Add Relationship sections for every other persona they interact with
7. Define structured output formats
8. Update `team-plan/SKILL.md` and `team-review/SKILL.md` to include the new persona's agent prompt

## Project Structure

```
claude-agent-dev-team/
├── _shared/
│   ├── conflict-resolution.md    # Conflict resolution protocol
│   └── engineering-discipline.md # Engineering discipline principles
├── security-engineer/SKILL.md    # Security Engineer persona
├── it-architect/SKILL.md         # IT Architect persona
├── project-manager/SKILL.md      # Project Manager / Scrum Master persona
├── project-engineer/SKILL.md     # Project Engineer persona
├── ux-designer/SKILL.md          # UX/UI Designer persona
├── code-reviewer/SKILL.md        # Code Reviewer persona
├── database-engineer/SKILL.md    # Database Engineer persona
├── sre/SKILL.md                  # Site Reliability Engineer persona
├── observability-engineer/SKILL.md # Observability Engineer persona
├── qa-engineer/SKILL.md          # QA / Test Engineer persona
├── technical-writer/SKILL.md     # Technical Writer persona
├── team-plan/SKILL.md            # Team planning ceremony
├── team-review/SKILL.md          # Team review ceremony
├── standup/SKILL.md              # Daily standup ceremony
├── grooming/SKILL.md             # Backlog refinement ceremony
├── spike/SKILL.md                # Technical spike ceremony
├── postmortem/SKILL.md           # Incident postmortem ceremony
├── retro/SKILL.md                # Session retrospective ceremony
├── install.sh                    # Installer script
├── LICENSE                       # MIT License
└── README.md                     # This file
```

## Credits

The engineering discipline and identity primer approach was inspired by collaborative work with the dev community building effective agent-assisted development patterns.

## License

MIT
