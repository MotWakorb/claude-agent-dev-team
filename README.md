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

The result: when you run `/team-plan` or `/team-review`, six agents work in parallel, each bringing their genuine domain perspective, and the synthesis surfaces real conflicts for the Product Owner to decide — not smoothed-over consensus.

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
| **SRE** | `/sre` | Site reliability — SLOs, observability, incident response, capacity planning, on-call readiness. The person who gets paged at 3 AM and knows what to do |
| **QA Engineer** | `/qa-engineer` | Holistic test strategy, test environments, test data, performance testing, regression curation, chaos testing. Complements TDD with strategic quality thinking |
| **Technical Writer** | `/technical-writer` | Documentation as a product. API docs, runbooks, onboarding guides, architecture docs, changelogs. If it's not documented, it doesn't exist |

## Team Skills

| Skill | Command | Purpose |
|-------|---------|---------|
| **Team Plan** | `/team-plan` | Spawns all 10 personas in parallel to analyze a project brief. Surfaces conflicts, facilitates debate, produces unified plan with PO decision points |
| **Team Review** | `/team-review` | Spawns all 10 personas in parallel to review existing work. Consolidates findings, surfaces disagreements, produces prioritized action items |
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

Copy the skill directories into your Claude Code skills location:

```bash
# Personal skills (available across all projects)
cp -R _shared ~/.claude/skills/_shared
cp -R security-engineer ~/.claude/skills/security-engineer
cp -R it-architect ~/.claude/skills/it-architect
cp -R project-manager ~/.claude/skills/project-manager
cp -R project-engineer ~/.claude/skills/project-engineer
cp -R ux-designer ~/.claude/skills/ux-designer
cp -R code-reviewer ~/.claude/skills/code-reviewer
cp -R retro ~/.claude/skills/retro
cp -R team-plan ~/.claude/skills/team-plan
cp -R team-review ~/.claude/skills/team-review
cp -R database-engineer ~/.claude/skills/database-engineer
cp -R sre ~/.claude/skills/sre
cp -R qa-engineer ~/.claude/skills/qa-engineer
cp -R technical-writer ~/.claude/skills/technical-writer

# Create the retrospective directory
mkdir -p ~/retros
```

Or for project-specific use, copy into your project's `.claude/skills/` directory.

## Usage

```bash
# Invoke a single persona
/security-engineer Review the authentication module for vulnerabilities
/it-architect Design a system for real-time event processing
/project-manager Plan the next sprint based on the current backlog

# Run a full team planning session
/team-plan

# Run a full team review
/team-review

# End-of-session retrospective
/retro
```

### Quick vs Full Mode

Both `/team-plan` and `/team-review` support depth modes:
- **Quick**: Bullet points, top 2-3 conflicts, concise output
- **Full**: Complete structured output per each persona's format

## Customization

These skills are designed to be adapted:

- **Technology stack**: The engineer defaults to Node/React + Python + Terraform + Ansible. Change the defaults in `project-engineer/SKILL.md`
- **Frameworks**: Security references OWASP, NIST CSF, CIS, ISO 27001, SOC 2, Zero Trust. Add or remove in `security-engineer/SKILL.md`
- **Board tool**: The PM uses [beads](https://github.com/steveyegge/beads) (`bd`). Swap for your project management CLI tool in `project-manager/SKILL.md`
- **API conventions**: The code reviewer defines API naming, response envelopes, and versioning. Adjust in `code-reviewer/SKILL.md`
- **Design system**: The UX designer builds from scratch. If you use an existing design system, update `ux-designer/SKILL.md`

## Credits

The engineering discipline and identity primer approach was inspired by collaborative work with the dev community building effective agent-assisted development patterns.

## License

MIT
