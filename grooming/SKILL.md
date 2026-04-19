---
name: grooming
description: Backlog refinement — pull upcoming beads from the backlog, have each persona evaluate readiness, size effort, identify dependencies, define acceptance criteria, and determine if items are sprint-ready.
when_to_use: backlog refinement, grooming, backlog grooming, sprint preparation, story refinement, sizing, estimation
user-invocable: true
---

# Backlog Grooming / Refinement

This is not planning. This is preparing work to BE planned. The goal is to take backlog items and make them sprint-ready: sized, dependencies identified, acceptance criteria defined, and every persona's concerns surfaced before the work enters a sprint.

## Process

### Step 1: Identify Items to Groom

Pull candidate items from the backlog:

```bash
bd ready                          # Unblocked items ready for work
bd list --status open -p 0        # Priority 0 items
bd list --status open -p 1        # Priority 1 items
bd list --status open -p 2        # Priority 2 items
bd stale                          # Items that may need re-evaluation
```

If the PO has specific items to groom, use those instead. Otherwise, work top-down by priority.

Present the candidate list to the PO and confirm which items to refine this session.

### Step 2: For Each Item, Spawn Parallel Agents

For each bead being groomed, spawn all 11 personas in parallel. Each evaluates the item from their domain:

**Each agent prompt:**
```
Read ~/.claude/skills/[persona]/SKILL.md for your domain scope.
Read ~/.claude/skills/_shared/engineering-discipline.md and ~/.claude/skills/_shared/conflict-resolution.md.

You are the [Persona]. We are grooming the following backlog item for sprint readiness.

Bead: [ID]
Title: [Title]
Description: [Description]
Priority: [Priority]
Type: [epic/feature/bug/task/chore]
Dependencies: [Any known dependencies]

Evaluate this item and respond with:

1. **Sprint-Ready?** [Yes / No — and why not]
2. **Effort from your domain**: [None / Small / Medium / Large] — what work does YOUR domain need to do for this item?
3. **Dependencies you see**: [What must happen before or alongside this work from your perspective?]
4. **Acceptance criteria from your domain**: [What does "done" look like from your perspective? Only add criteria relevant to your domain — don't repeat others]
5. **Concerns**: [Anything that makes this item risky, unclear, or likely to expand in scope]
6. **Questions for the PO**: [Anything you need clarified before this can be worked]

Be brief. If this item doesn't touch your domain, respond with:
"No concerns from [domain]. No effort required."
```

### Step 3: Synthesize Per Item

For each groomed item, combine all persona responses into a refinement summary:

```markdown
## Refinement: [Bead ID] — [Title]

### Sprint-Ready Verdict: [Yes / No]
[If No — what's missing before this can enter a sprint]

### Effort Assessment
| Persona | Effort | Notes |
|---------|--------|-------|
| Security Engineer | [None/S/M/L] | [Brief note] |
| IT Architect | [None/S/M/L] | [Brief note] |
| Project Manager | [None/S/M/L] | [Brief note] |
| Project Engineer | [None/S/M/L] | [Brief note] |
| UX Designer | [None/S/M/L] | [Brief note] |
| Code Reviewer | [None/S/M/L] | [Brief note] |
| Database Engineer | [None/S/M/L] | [Brief note] |
| SRE | [None/S/M/L] | [Brief note] |
| Observability Engineer | [None/S/M/L] | [Brief note] |
| QA Engineer | [None/S/M/L] | [Brief note] |
| Technical Writer | [None/S/M/L] | [Brief note] |

### Overall Size: [Small / Medium / Large / Epic — needs decomposition]

### Dependencies Identified
| Dependency | Raised By | Type | Status |
|-----------|-----------|------|--------|
| [What must happen first] | [Persona] | Blocks / Informs | [Exists as bead? / Needs creation] |

### Acceptance Criteria (Combined)
- [ ] [Criteria from persona — attributed]
- [ ] [Criteria from persona — attributed]
- [ ] [Criteria from persona — attributed]

### Concerns
| Concern | Raised By | Severity | Mitigation |
|---------|-----------|----------|-----------|
| [Scope risk, unclear requirement, etc.] | [Persona] | [High/Med/Low] | [What would address it] |

### Questions for the PO
| Question | Asked By | Impact if Unanswered |
|----------|----------|---------------------|
| [Question] | [Persona] | [Can't size / Can't start / Changes approach] |

### Recommended Actions Before Sprint
- [ ] [Create dependency bead: ...]
- [ ] [PO to clarify: ...]
- [ ] [Decompose into smaller items: ...]
- [ ] [Spike needed: ... (use /spike)]
```

### Step 4: Update Beads

For items that are now sprint-ready:
- Update the bead description with refined acceptance criteria
- Create dependency beads identified during grooming
- Link dependencies with `bd dep add`
- Update priority if the grooming revealed it should change

For items that are NOT sprint-ready:
- Add a comment noting what's blocking readiness
- Create any prerequisite beads (spikes, clarifications, design work)
- Link prerequisites as dependencies

### Step 5: Recommend Spikes

If any item has unknowns that can't be resolved in grooming, recommend a `/spike` with the specific question to answer and which personas should investigate.

## Rules

- **Grooming is not planning.** Don't assign work to sprints. Just make items ready to be planned
- **"I don't know" is a valid answer.** If a persona can't size an item because requirements are unclear, that's a finding — the item isn't sprint-ready until the question is answered
- **Decompose what's too big.** If the overall size is "Epic — needs decomposition," recommend breaking it into smaller beads before it enters a sprint
- **Don't groom more than 5-7 items per session.** Grooming has diminishing returns. Better to deeply refine 5 items than superficially touch 15
- **Dependencies are the most important output.** A sprint with hidden dependencies will fail. Surface every dependency and create the beads
- **Acceptance criteria are per-domain.** The engineer's "done" is different from the security engineer's "done" is different from the UX designer's "done." All are required
