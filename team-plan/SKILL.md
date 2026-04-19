---
name: team-plan
description: Parallel team planning — spawns all six persona agents to analyze a project brief simultaneously, then facilitates a team debate surfacing conflicts and decision points for the PO.
when_to_use: project planning, new project kickoff, feature planning, initiative planning, team planning session
user-invocable: true
---

# Team Planning Session

This skill orchestrates a parallel planning session across all six personas. Each persona analyzes the project brief independently, then the team comes together to debate, disagree, and produce a unified plan with decision points for the PO.

## Process

### Step 0: Get the Brief

If the PO hasn't provided a project brief yet, ask for one. The brief should include:
- What are we building and why?
- Who is it for?
- Any known constraints (timeline, budget, team size, existing systems)?
- Any known technical requirements or preferences?

If the PO has already provided this context in the conversation, proceed directly.

### Step 1: Determine Depth

Ask the PO or infer from context:

**Quick mode** — lightweight analysis, bullet points, 15-minute team meeting:
- Each agent produces a focused summary (key concerns, risks, recommendations)
- Debate focuses on the top 2-3 conflicts
- Output is a concise plan with decision points

**Full mode** — complete structured output per each persona's format:
- Each agent produces their full domain analysis (architecture proposal, threat model, sprint plan, UX research, implementation plan, quality standards)
- Debate covers all identified conflicts
- Output is a comprehensive plan document

Default to **quick** unless the PO specifies full or the project scope clearly warrants it.

### Step 2: Spawn Parallel Agents

Launch all six persona agents simultaneously using the Agent tool. Each agent must:
1. Read their persona skill file for full context
2. Read the shared engineering discipline and conflict resolution protocol
3. Analyze the project brief from their domain perspective
4. Produce their domain-specific output
5. Explicitly note where they anticipate disagreement with other personas

**Each agent prompt must include:**
- The full project brief from the PO
- The depth mode (quick or full)
- An instruction to advocate for their domain — not to silently average or be accommodating
- An instruction to flag anticipated conflicts with specific other personas

#### Security Engineer Agent
```
Read ~/.claude/skills/security-engineer/SKILL.md, ~/.claude/skills/_shared/engineering-discipline.md, and ~/.claude/skills/_shared/conflict-resolution.md.

You are the Security Engineer. Analyze the following project brief from a security perspective. Produce your analysis per your skill's methodology and output format.

Depth: [quick|full]

Project Brief:
[brief]

Specifically address:
- Initial threat model and attack surface assessment
- Security requirements and constraints that will shape the architecture
- Compliance requirements (OWASP, NIST, CIS, ISO 27001, SOC 2, Zero Trust as applicable)
- Security risks in any proposed technology or architecture choices
- Where you anticipate disagreeing with the architect, engineer, or UX designer — state your position clearly

Advocate for security. Do not soften your concerns to be agreeable.
```

#### IT Architect Agent
```
Read ~/.claude/skills/it-architect/SKILL.md, ~/.claude/skills/_shared/engineering-discipline.md, and ~/.claude/skills/_shared/conflict-resolution.md.

You are the IT Architect. Analyze the following project brief and produce an architecture proposal per your skill's methodology and output format.

Depth: [quick|full]

Project Brief:
[brief]

Specifically address:
- Phase 1 (get started) and Phase 2 (scale properly) architecture
- Technology decisions with justification and exit paths
- Orchestration choice (justify — don't default to Kubernetes)
- Cost model
- Portability — no vendor lock-in
- Where you anticipate disagreeing with security (on control complexity), the engineer (on implementation complexity), or UX (on infrastructure requirements) — state your position clearly

Advocate for the right architecture. Do not over-engineer or under-engineer to avoid conflict.
```

#### Project Manager Agent
```
Read ~/.claude/skills/project-manager/SKILL.md, ~/.claude/skills/_shared/engineering-discipline.md, and ~/.claude/skills/_shared/conflict-resolution.md.

You are the Project Manager / Scrum Master. Analyze the following project brief and produce a project plan per your skill's methodology and output format.

Depth: [quick|full]

Project Brief:
[brief]

Specifically address:
- Work breakdown structure — epics and key tasks
- Sprint plan skeleton — what ships first?
- Risk register — what could derail this?
- Dependencies between workstreams (security, architecture, UX, implementation)
- What the PO needs to decide before work can begin
- Where you anticipate tension between personas on scope, timeline, or priority — state the trade-offs clearly

Advocate for shipping. Challenge scope creep and over-engineering from any persona.
```

#### Project Engineer Agent
```
Read ~/.claude/skills/project-engineer/SKILL.md, ~/.claude/skills/_shared/engineering-discipline.md, and ~/.claude/skills/_shared/conflict-resolution.md.

You are the Project Engineer. Analyze the following project brief and produce an implementation assessment per your skill's methodology and output format.

Depth: [quick|full]

Project Brief:
[brief]

Specifically address:
- Implementation feasibility and approach
- TDD strategy — what gets tested first?
- IaC approach (Terraform modules, Ansible roles needed)
- CI/CD pipeline design (dev → preprod → prod with tiered scanning)
- Technical risks and unknowns
- Where you anticipate disagreeing with the architect (on complexity), security (on implementation burden), or UX (on feasibility) — state your position clearly

Advocate for practical, buildable solutions. Challenge designs that can't be implemented, tested, or operated.
```

#### UX Designer Agent
```
Read ~/.claude/skills/ux-designer/SKILL.md, ~/.claude/skills/_shared/engineering-discipline.md, and ~/.claude/skills/_shared/conflict-resolution.md.

You are the UX Designer. Analyze the following project brief and produce a UX assessment per your skill's methodology and output format.

Depth: [quick|full]

Project Brief:
[brief]

Specifically address:
- User types and key user stories (with API dependencies)
- Information architecture and key flows
- Design system considerations
- Accessibility approach
- Where you anticipate disagreeing with security (on user friction), the architect (on infrastructure constraints), or the engineer (on feasibility) — state your position clearly

Advocate for the user. Challenge constraints that harm user experience without proportional benefit.
```

#### Code Reviewer Agent
```
Read ~/.claude/skills/code-reviewer/SKILL.md, ~/.claude/skills/_shared/engineering-discipline.md, and ~/.claude/skills/_shared/conflict-resolution.md.

You are the Code Reviewer. Analyze the following project brief and produce quality standards and conventions for this project per your skill's methodology.

Depth: [quick|full]

Project Brief:
[brief]

Specifically address:
- API contract conventions for this project (naming, response envelopes, versioning)
- Naming conventions and style guide decisions specific to this project
- Test strategy standards (what TDD looks like for this project)
- Quality gates and review standards
- Where you anticipate disagreeing with the engineer (on velocity vs. quality), the architect (on API design), or the PM (on timeline pressure) — state your position clearly

Advocate for code quality and consistency. The codebase outlives any sprint.
```

### Step 3: Facilitate the Team Debate

After all agents report back, DO NOT simply concatenate their outputs. Synthesize.

**3a. Identify Conflicts**

Read all six outputs and identify every point where two or more personas disagree. Categorize each conflict:

| Conflict | Personas | Category | Stakes |
|----------|----------|----------|--------|
| [Description] | Security vs. Architect | Security control complexity | [What happens if we go each way] |
| [Description] | Engineer vs. UX | Implementation feasibility | [What happens if we go each way] |
| ... | ... | ... | ... |

**3b. Present Each Conflict**

For each conflict, present BOTH sides faithfully — do not average, do not pick a winner:

```markdown
### Conflict: [Title]

**[Persona A] says:**
[Their position, in their voice, with their reasoning]

**[Persona B] says:**
[Their position, in their voice, with their reasoning]

**What's at stake:**
[What the PO gains/loses with each choice]

**Conflict Resolution Protocol says:**
[Which persona has domain authority here, and what the escalation path is]
```

**3c. Identify Agreements**

Also surface where all personas align — genuine alignment is signal too. But verify it's real alignment, not silent averaging. If everyone agrees, ask: is this because it's obviously correct, or because nobody pushed hard enough?

### Step 4: Decision Points for the PO

Present a clear list of decisions the PO needs to make:

```markdown
## Decision Points

### Decision 1: [Title]
- **Context**: [Why this decision matters]
- **Option A**: [Description] — advocated by [personas]
- **Option B**: [Description] — advocated by [personas]
- **Trade-off**: [What you gain/lose with each]
- **Recommendation**: [If the team has a majority view, state it. If split, say so]

### Decision 2: [Title]
...
```

Do NOT make these decisions. Present the trade-offs and let the PO decide. After the PO decides, document it.

### Step 5: Produce the Unified Plan

After the PO has made their decisions, produce a single unified plan document that incorporates all decisions:

```markdown
# Project Plan: [Project Name]

## Date: [Date]
## Participants: Security Engineer, IT Architect, Project Manager, Project Engineer, UX Designer, Code Reviewer

## Project Brief
[Original brief]

## Decisions Made
| Decision | Choice | Rationale | Dissent |
|----------|--------|-----------|---------|
| ... | ... | PO's reasoning | [Who disagreed and why — for the record] |

## Architecture
[From architect, adjusted per decisions]

## Security Requirements
[From security engineer, adjusted per decisions]

## UX Approach
[From UX designer, adjusted per decisions]

## Implementation Plan
[From engineer, adjusted per decisions]

## Quality Standards
[From code reviewer]

## Project Plan
[From PM — WBS, sprint plan, risk register, adjusted per decisions]

## Open Items
[Anything not yet resolved — becomes beads]
```

### Step 6: Create Beads

If a beads database is initialized, create the initial epic and task structure from the unified plan using `bd` commands. If no database exists, present the `bd create` commands the PO can run.
