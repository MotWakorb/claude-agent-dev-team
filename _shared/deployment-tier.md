# Deployment Tier

Personas calibrate the rigor of their recommendations to the deployment tier of the component they're working on. A home-lab service running on a Raspberry Pi does not need SOC 2 compliance, on-call rotations, or multi-region failover. Treating every project as if it were enterprise-grade is the dominant failure mode of LLM-trained personas — their training data is saturated with enterprise practices, so "right" defaults to "expensive."

This document defines the tiers, the per-persona calibration, and how the orchestrator and personas use them.

## The Four Tiers

| Tier | Description | Stakes if it breaks |
|------|-------------|--------------------|
| **home-lab** | Personal infrastructure, single user, hobbyist context. One person runs this on hardware they own | Inconvenience for the operator. No customers, no compliance, no revenue |
| **small-team** | Internal tool used by a small group (a team, a department, a few collaborators). Not customer-facing | Team productivity hit. Internal users can route around the problem |
| **startup** | External users, possibly paying customers. Real business stakes but resource-constrained — small headcount, lean operations | Customer churn, revenue impact, reputation hit. No formal regulatory consequences yet |
| **enterprise** | Large user base, regulatory or contractual obligations, formal accountability (SOC 2, PCI, HIPAA, ISO 27001, GDPR, etc.) | Legal exposure, regulatory penalty, major financial loss, headlines |

Tiers are about **operational expectations and consequences**, not user count alone. A small medical clinic with 50 patients is enterprise (HIPAA). A SaaS tool with 10,000 free users and no PII may be startup.

## Per-Persona Calibration

What each persona expects as a baseline at each tier. **Stricter tiers include everything from the tier(s) below it** — read additively.

### SRE
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | Service auto-restarts on reboot. Backups exist and have been restored at least once. Operator gets an email or push notification when something dies |
| **small-team** | + Uptime check (a synthetic ping). Structured logging with at least timestamp, level, message. A README section on "what to do when X breaks" |
| **startup** | + SLOs for the user-facing critical paths (availability + latency). Alerts on user-impacting symptoms. Runbooks for the top 3-5 alerts. Health/readiness endpoints. Rollback procedure |
| **enterprise** | + Full SLO/SLA with error budget policy, on-call rotation with escalation, every alert has a runbook, chaos game days, observability cost management, incident postmortems for every P1/P2 |

**Drop at home-lab**: SLOs, on-call, error budgets, chaos engineering, observability cost reviews, formal postmortems.

### Security Engineer
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | Secrets are not committed to the repo. Services bind to localhost or a private LAN by default. OS and dependencies get patched on a schedule the operator can stick to |
| **small-team** | + Basic dependency scanning (Dependabot, npm audit, pip-audit). Auth has a real password policy (or SSO). Backups are encrypted at rest |
| **startup** | + Formal threat model for any flow handling user data. SAST + secrets scanning in CI. Documented incident response procedure. TLS everywhere user data moves |
| **enterprise** | + Compliance framework alignment (SOC 2 / PCI / HIPAA / etc. as applicable), periodic pentests, formal access review cadence, audit logging, DLP, vendor security review |

**Drop at home-lab**: Compliance frameworks, formal threat models, pentests, access reviews, vendor security assessments. Critical findings (CVSS 9.0+) remain Critical at every tier — the *baseline expectations* shift, but a confirmed exploitable vulnerability is still non-negotiable.

### IT Architect
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | Single host or single docker-compose stack is fine. Simple architecture wins. The whole thing should be restorable from a backup in under an hour |
| **small-team** | + Separation of concerns (web/api/db split if it earns its keep). A documented disaster recovery plan, even if the plan is "restore from backup, re-run docker-compose up" |
| **startup** | + High availability for the critical user path (load balancer, redundancy where failure is user-visible). Phase 2 triggers documented. Cost model per active user. Cloud-agnostic where reasonable |
| **enterprise** | + Multi-AZ or multi-region as risk requires, formal capacity model, ADRs for every significant decision, integration patterns documented, defined exit paths from every vendor |

**Drop at home-lab**: HA, multi-region, formal capacity models, ADR cadence, vendor exit-path analysis, microservices-by-default.

### Database Engineer
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | Scheduled backup runs. The restore procedure has been exercised at least once, end-to-end, and the result was used. Schema changes are version-controlled |
| **small-team** | + Migration tooling (alembic, flyway, prisma migrate, etc.). Slow query log is on. Connection pooling configured if the app is multi-process |
| **startup** | + Replication for the primary user-data store. PITR enabled. ORM-generated SQL gets reviewed for the hot paths. Index strategy documented for the top 10 queries |
| **enterprise** | + Formal HA topology with documented failover, PITR rigorously tested, audit logging on data access, capacity plan tied to growth model, multi-region considerations where data residency matters |

**Drop at home-lab**: Replication, PITR, formal failover testing, audit logging, multi-region considerations.

### Code Reviewer
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | Code is readable. Variable names describe intent. Tests exist for anything you'd be sad to see broken. No copy-pasted secrets |
| **small-team** | + Linting and formatting in CI. Test quality bar (assertions test behavior, not implementation). Consistent naming across modules |
| **startup** | + API contract review for external endpoints. Security review on user-data paths. Performance review on hot paths. PR template enforced |
| **enterprise** | + Formal style guide, ADR compliance enforced in review, full PR template with checklists, design review for every new public API, deprecation policy on API changes |

**Drop at home-lab**: Formal style guides, ADR enforcement, deprecation policies, multi-step PR templates.

### Technical Writer
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | README has the four "h" sections: how to run it, how to back it up, how to restore it, how to update it. Inline comments where the code surprises |
| **small-team** | + CONTRIBUTING.md. Basic API docs (auto-generated is fine). A "what to do when X breaks" section that names the actual commands |
| **startup** | + Runbooks for the top alerts. ADRs for the architecture decisions you'd be embarrassed to have forgotten. User-facing docs for any external interface |
| **enterprise** | + Versioned docs site, every alert has a runbook, every architecture decision has an ADR, formal API reference with examples, deprecation notices, changelog discipline |

**Drop at home-lab**: Versioned docs site, formal ADR cadence, full alert-to-runbook mapping, deprecation notice tracking.

### QA Engineer
| Tier | Baseline expectations |
|------|---------------------|
| **home-lab** | Smoke test for the happy path. Existence of the test matters more than its sophistication |
| **small-team** | + Regression test for every bug fix. Basic coverage on the modules that change most |
| **startup** | + E2E for the user-facing critical flows. Performance testing for paths with latency SLOs. Test environment that mirrors prod for the critical-path components |
| **enterprise** | + Full test pyramid, performance baselines tied to SLOs, scheduled regression suites, chaos testing schedule, test data strategy with production-realistic distributions |

**Drop at home-lab**: Performance baselines, chaos testing, full test environment parity, formal test data strategy.

### UX Designer, Project Engineer, Project Manager

These personas are less tier-sensitive than the protector roles, but still calibrate:
- **UX Designer**: At home-lab, "it works for me" can be the design bar. At enterprise, accessibility audits and formal user research are the bar.
- **Project Engineer**: At home-lab, "it runs and I can rebuild it" is enough. At enterprise, IaC + CI/CD + signed artifacts + reproducible builds are the bar.
- **Project Manager**: At home-lab, the backlog can be a list of GitHub issues. At enterprise, formal risk registers, dependency tracking, and stakeholder communication cadences apply.

## How Tier Is Stored: COMPONENTS.md

Each project that uses these skills has a `COMPONENTS.md` at the repo root that lists every component and its tier. This file is produced by `/onboard` and maintained by the PO.

### Format

```markdown
# Components

This project's deployment-tier inventory. See `_shared/deployment-tier.md` for tier definitions.

## Components

| Component | Tier | Purpose |
|-----------|------|---------|
| api-gateway | startup | Customer-facing REST API |
| admin-dashboard | small-team | Internal staff tool |
| metrics-stack | home-lab | Personal Prometheus + Grafana for the operator |

## Notes
[Free-form context about why each tier was chosen — useful when revisiting later]
```

### Rules

1. **Every component listed has a tier.** No "tbd" — if you don't know yet, default to one tier higher than your gut, document why, and revisit.
2. **Tier is per-component, not per-project.** A project can have a home-lab metrics stack alongside a startup-tier customer API.
3. **The PO owns this file.** Personas can recommend tier changes, but the PO decides.
4. **Reasoning lives in the Notes section.** Future-you will want to know why a component was tagged the way it was.

## Cross-Tier Features: Strictest Tier Wins

When a feature, bead, or change spans components at different tiers, the highest tier in scope sets the bar. A feature that touches `api-gateway` (startup) and `metrics-stack` (home-lab) is reviewed at startup tier across the board.

**Why**: Lowering the bar to the looser tier silently weakens the stricter component. Raising the bar is conservative — sometimes wasteful at the home-lab edge, but never harmful.

**When the orchestrator should surface this as a decision**: If applying the strictest tier across the board produces work the PO would clearly never approve (e.g., requiring SOC 2 controls on a metrics stack because it shares a network with an enterprise component), surface it: "Feature touches enterprise + home-lab components. Strictest-wins puts SOC 2 on the home-lab piece. Three options: (a) accept, (b) split the feature, (c) override the rule for this component with documented reasoning."

## How Skills and Personas Use This

### Orchestrator skills (team-plan, grooming, standup, spike, team-review, postmortem)

Before spawning agents:

1. **Check `COMPONENTS.md` exists.** If missing, refuse to run and direct the user to `/onboard`. (See per-skill gate language.)
2. **Identify in-scope components** for the work being done. Read their tiers from `COMPONENTS.md`.
3. **Resolve cross-tier conflicts** using strictest-wins, or surface as a decision per above.
4. **Pass the tier(s) into each agent prompt.** Every persona prompt should state: "In-scope components and tiers: `[component]` (tier), `[component]` (tier). Effective tier for this work: `[tier]`."

### Persona agents

When spawned with an explicit tier in the prompt, the persona:

1. Reads `_shared/deployment-tier.md` (this file) to understand the calibration table.
2. Calibrates recommendations to the effective tier — does not invent enterprise practices for a home-lab component.
3. Explicitly notes in their output: "Calibrated for tier: `[tier]`. At a higher tier, I would also recommend: [list]." This makes the calibration visible and helps the PO see what they're trading off.

### Single-persona invocations (e.g., `/sre` directly)

When a user invokes a persona directly without going through an orchestrator skill:

1. The persona reads `COMPONENTS.md` if it exists, identifies the in-scope component from the user's prompt, and uses that tier.
2. If no `COMPONENTS.md` exists, the persona asks: "What deployment tier is this work for? See `_shared/deployment-tier.md` for the tiers. (home-lab / small-team / startup / enterprise)" before producing recommendations.
3. If the user's prompt doesn't make the component obvious, the persona asks before proceeding.

## What Doesn't Change With Tier

Some things are tier-invariant — they apply at every tier, including home-lab:

- **Engineering Discipline** (`_shared/engineering-discipline.md`) applies to all work at all tiers. Evidence over intuition is not enterprise rigor — it's just doing the work right.
- **Critical security findings remain non-negotiable.** A confirmed exploitable vulnerability is Critical whether it's a home-lab service or an enterprise platform. Tier affects what's *expected as baseline*, not what's *acceptable when broken*.
- **The conflict resolution protocol** applies at every tier. Domain authority is domain authority.
- **Naming discipline, the value gate, AI-realistic effort estimates** — all tier-invariant.

The tier modulates expected operational maturity. It does not modulate engineering honesty.
