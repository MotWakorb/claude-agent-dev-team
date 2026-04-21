---
name: standup
description: Daily standup — parallel status check across all personas using red/yellow/green scale. Leads with blockers. Green personas stay silent. Fast, focused, action-oriented.
when_to_use: standup, daily standup, status check, daily sync, what's blocked, where are we
user-invocable: true
---

# Daily Standup

Fast. Focused. Blockers first. If everything is green, say so and move on. This is not a planning session, not a review, not a retro. This is "where are we, what's stuck, what does the PO need to know right now."

## Process

### Step 0: Check the Board

Run these commands to get the current state:

```bash
bd status          # Overall project health
bd blocked         # What's stuck and why
bd ready           # What's unblocked and ready to work
bd stale           # What hasn't been touched recently
bd list --status in_progress  # What's actively being worked
```

If no beads database exists, skip to Step 1 and work from conversation context.

### Step 1: Phase 1 — Lightweight Triage (All 10 Voices)

Launch all 10 persona agents simultaneously using the Agent tool. **IMPORTANT: All agents must be spawned as `general-purpose` type** (subagent_type: "general-purpose"). Each agent loads ONLY their identity file — not the full persona. This is a triage, not a deep dive:

**Each agent prompt:**
```
Read ~/.claude/skills/[persona]/identity.md for your domain scope and standup triggers.

You are the [Persona]. This is a daily standup triage — be brief.
Advocate for your domain with evidence. Flag concerns, not accommodations.

Current board state:
[paste bd status/blocked/ready/stale output]

Project context:
[brief description of current sprint/project state from conversation]

Rate your domain status:

- RED: Something is actively blocked, broken, or at risk. The PO needs to know NOW
- YELLOW: A concern is developing. Not blocked yet, but heading that way without action
- GREEN: No concerns from your domain. Everything is on track

Rules:
- If you are GREEN, respond with ONLY: "GREEN — no concerns"
- If you are YELLOW, respond in 2-3 sentences: what the concern is and what would prevent it from going red
- If you are RED, respond with: what's blocked/broken, what the impact is, and what you need to unblock it

Do NOT pad your response. Do NOT list what's going well. The standup only cares about problems and risks.
```

### Step 2: Phase 2 — Deep Assessment (Non-Green Only)

After Phase 1, identify which personas reported RED or YELLOW. **Only for those personas**, spawn a second round of agents that load the **full persona SKILL.md** to provide deeper analysis:

**Each Phase 2 agent prompt:**
```
Read ~/.claude/skills/[persona]/SKILL.md for your full domain expertise.

You are the [Persona]. You flagged a [RED/YELLOW] concern in standup triage:
"[paste their Phase 1 response]"

Advocate for your domain with evidence. Flag specific disagreements with other personas if relevant.

Current board state:
[paste bd status/blocked/ready/stale output]

Project context:
[brief description of current sprint/project state from conversation]

Provide a deeper assessment (still concise — 5-8 sentences max):
1. What specifically is the issue? Name beads, files, systems, or metrics
2. What is the impact if unaddressed?
3. What concrete action resolves or mitigates this?
4. Does this conflict with or depend on another persona's domain?
```

**If ALL personas report GREEN in Phase 1, skip Phase 2 entirely.**

### Step 3: Synthesize — Exception-Based Reporting

After both phases complete, present ONLY the non-green statuses. This is exception-based reporting — silence is good news.

**Output format:**

```markdown
## Standup — [Date]

### Board Snapshot
- **In Progress**: [count]
- **Blocked**: [count] 
- **Ready**: [count]
- **Stale**: [count] (not updated in [threshold])

### RED — Immediate Attention
[If any persona reported RED, present their Phase 2 deep assessment]

#### [Persona Name] — RED
[What's blocked/broken, impact, what's needed to unblock — from Phase 2]

### YELLOW — Developing Concerns  
[If any persona reported YELLOW, present their Phase 2 assessment]

#### [Persona Name] — YELLOW
[Concern, trajectory, what prevents it from going red — from Phase 2]

### GREEN — All Clear
[List personas that reported green — one line]
[Persona 1], [Persona 2], [Persona 3], ...

### Blocked Beads
[From bd blocked output — if any]
| Bead ID | Title | Blocked By | Action Needed |
|---------|-------|-----------|---------------|
| ... | ... | ... | ... |

### Stale Beads
[From bd stale output — if any warrant attention]
| Bead ID | Title | Last Updated | Assigned To |
|---------|-------|-------------|-------------|
| ... | ... | ... | ... |

### PO Decisions Needed
[If any RED/YELLOW items require a PO decision, list them here]
| Decision | Context | Urgency | Raised By |
|----------|---------|---------|-----------|
| ... | ... | Today / This Sprint | [Persona] |
```

### Step 4: Done

That's it. No discussion, no deep dive, no planning. If a RED or YELLOW item needs a deeper conversation, suggest the appropriate follow-up:
- Architecture concern → `/it-architect`
- Security concern → `/security-engineer`
- Full team discussion → `/team-review`
- Sprint replanning needed → `/project-manager`

The standup identifies problems. Other skills solve them.

## What Each Persona Checks

Quick reference for what each persona evaluates during standup:

| Persona | RED if... | YELLOW if... |
|---------|----------|-------------|
| **Security Engineer** | Critical/High finding unresolved, security scan failures blocking preprod, active vulnerability | Medium finding aging, scan coverage gaps developing, upcoming compliance deadline |
| **IT Architect** | Architectural decision blocking implementation, design not keeping pace with sprint | ADR pending that blocks future work, tech debt accumulating, scaling concern emerging |
| **Project Manager** | Sprint goal at risk, multiple items blocked, velocity significantly below commitment | Scope creep detected, carry-over items accumulating, risk register item materializing |
| **Project Engineer** | Build broken, deployment pipeline failing, blocked on dependency, critical bug in progress | Test failures in CI, IaC drift detected, technical debt slowing implementation |
| **UX Designer** | Design deliverable blocking implementation, critical usability issue in shipped feature | Design debt accumulating, component spec gaps, accessibility regression |
| **Code Reviewer** | PRs blocked on review, critical quality issue in merged code, style guide violation pattern | Review queue growing, test quality declining across PRs, naming drift emerging |
| **Database Engineer** | Migration failed/blocked, query performance degraded in production, data integrity issue | Slow queries trending worse, index gaps on growing tables, migration plan missing |
| **SRE** | SLO breach, active incident, error budget exhausted, alerting gap discovered, instrumentation broken, can't diagnose production issues, cardinality explosion | Error budget burning faster than expected, capacity approaching limits, runbook gaps, dashboard rot, alert fatigue increasing, observability cost trending above budget |
| **QA Engineer** | Test environment down, flaky tests blocking CI, critical test gap discovered | Test coverage declining, performance testing overdue, test data stale |
| **Technical Writer** | Runbook missing for active alert, API docs don't match implementation, onboarding broken | Docs aging, changelog not updated, architecture docs drifting from reality |

## Rules

- **Standups are fast.** If it takes more than 5 minutes to read the output, it's too long
- **Green is silent.** Don't list what's going well. The PO's attention is for problems
- **Red is specific.** "Things are concerning" is not a standup report. Name the bead, the blocker, the impact
- **Yellow is actionable.** "I'm a bit worried" is not a standup report. State the concern and what prevents it from becoming red
- **No solutioning in standup.** Identify the problem, suggest the follow-up skill, move on
- **Board is truth.** If the board says everything is in progress but nothing has moved in 3 days, that's a YELLOW at minimum — from the PM if nobody else
