---
name: grooming
description: Backlog refinement — pull upcoming beads from the backlog, have each persona evaluate readiness, size effort, identify dependencies, define acceptance criteria, and determine if items are ready to build.
when_to_use: backlog refinement, grooming, backlog grooming, preparation, story refinement, sizing, estimation
user-invocable: true
---

# Backlog Grooming / Refinement

This is not planning. This is preparing work to BE planned — but only work that delivers user value. Before an item gets sized, scoped, and handed to personas for evaluation, it passes through a user value gate. If we can't articulate who benefits and how we'll know, we don't refine it — we question whether it belongs on the board.

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

### Step 1.5: User Value Gate

Before spawning personas, evaluate each candidate item:

```markdown
## Value Gate: [Bead ID] — [Title]

- **Who benefits?** [Name the user, customer, or stakeholder — "the team" or "the codebase" are not valid answers unless tied to a downstream user impact]
- **What's the current pain?** [What problem does the user face today? Evidence: support tickets, error rates, user feedback, abandonment data, compliance deadline]
- **What changes for them?** [Concrete outcome — faster, fewer errors, new capability, risk removed]
- **How will we measure success?** [Metric, signal, or observable change]
- **What happens if we don't do this?** [User impact of inaction — not technical impact, user impact]
```

**Gate outcomes:**
- **Pass** — clear user value, proceed to persona evaluation
- **Reframe** — the work may be valid but the value statement is missing or vague. Rewrite the bead description with user value before proceeding. Common reframes: "Refactor X" → "Reduce page load time from 4s to 1s by refactoring X"; "Add monitoring" → "Detect checkout failures within 60s so users aren't stuck"
- **Challenge** — can't articulate user value. Ask the PO: "Why does this matter to users?" If the PO can answer, reframe and proceed. If not, recommend removing from the backlog or parking it until context changes
- **Kill** — the item creates work without user benefit. Recommend closing the bead with reason: "No demonstrated user value"

Items that don't pass the value gate don't get refined. Refining work that shouldn't exist produces noise, not clarity.

### Step 2: Spawn Parallel Agents — One Per Persona, All Items at Once

Spawn all 10 personas in parallel using the Agent tool, each evaluating **ALL items in a single pass**. This is batch mode — each persona is spawned once regardless of how many items are being groomed. **IMPORTANT: All agents must be spawned as `general-purpose` type** (subagent_type: "general-purpose").

**Each agent prompt:**
```
Read ~/.claude/skills/[persona]/SKILL.md for your domain scope.

You are the [Persona]. We are grooming the following backlog items for readiness.
Advocate for your domain with evidence. Flag concerns, not accommodations.

IMPORTANT: Your role is to assess feasibility and risk for work that delivers user value — not to generate additional work from your domain. If an item doesn't need your domain's involvement, say so. Do NOT invent domain tasks to justify your participation.

## Items to Evaluate

### Item 1
- Bead: [ID]
- Title: [Title]
- Description: [Description]
- User Value: [Who benefits and how — from the value gate]
- Success Signal: [How we'll know it worked]
- Priority: [Priority]
- Type: [epic/feature/bug/task/chore]
- Dependencies: [Any known dependencies]

### Item 2
[repeat for each item]

### Item N
[repeat for each item]

## Instructions

For EACH item above, respond with:

### [Item Title] (Bead [ID])
1. **Ready to Build?** [Yes / No — and why not]
2. **Does this deliver the stated user value?** [Yes / Partially / No — if not, what's missing to actually achieve the user outcome?]
3. **Effort from your domain**: [None / Small / Medium / Large] — what work does YOUR domain need to do for this item? Only include work that's necessary to deliver the user value — not domain best-practices that don't affect the outcome
4. **Dependencies you see**: [What must happen before or alongside this work from your perspective?]
5. **Acceptance criteria from your domain**: [What does "done" look like from your perspective? Tie criteria to the user outcome, not domain standards]
6. **Concerns**: [Anything that makes this item risky, unclear, or likely to expand in scope — especially concerns about whether the stated user value will actually be achieved]
7. **Questions for the PO**: [Anything you need clarified before this can be worked]
8. **Cross-item dependencies**: [Does this item depend on or conflict with another item in this batch?]

Be brief per item. If an item doesn't touch your domain, respond with:
"No concerns from [domain]. No effort required."

Do NOT suggest additional beads from your domain unless they directly serve the stated user value.
```

### Step 3: Synthesize Per Item

For each groomed item, combine all persona responses into a refinement summary:

```markdown
## Refinement: [Bead ID] — [Title]

### User Value: [Who benefits and how]
### Success Signal: [How we'll know it worked]

### Ready to Build: [Yes / No]
[If No — what's missing before this can be worked]

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
| QA Engineer | [None/S/M/L] | [Brief note] |
| Technical Writer | [None/S/M/L] | [Brief note] |

### Overall Size: [Small / Medium / Large / Epic — needs decomposition]

### Dependencies Identified
| Dependency | Raised By | Type | Status |
|-----------|-----------|------|--------|
| [What must happen first] | [Persona] | Blocks / Informs | [Exists as bead? / Needs creation] |

### Acceptance Criteria (Combined)
- [ ] **User outcome**: [The stated user value is delivered and measurable]
- [ ] [Criteria from persona — attributed, tied to user outcome]
- [ ] [Criteria from persona — attributed, tied to user outcome]

### Concerns
| Concern | Raised By | Severity | Mitigation |
|---------|-----------|----------|-----------|
| [Scope risk, unclear requirement, etc.] | [Persona] | [High/Med/Low] | [What would address it] |

### Questions for the PO
| Question | Asked By | Impact if Unanswered |
|----------|----------|---------------------|
| [Question] | [Persona] | [Can't size / Can't start / Changes approach] |

### Recommended Actions Before Starting
- [ ] [Create dependency bead: ...]
- [ ] [PO to clarify: ...]
- [ ] [Decompose into smaller items: ...]
- [ ] [Spike needed: ... (use /spike)]
```

After all per-item summaries, add a **Cross-Item Analysis** section:

```markdown
## Cross-Item Analysis

### Inter-Item Dependencies
| Item A | Item B | Relationship | Raised By |
|--------|--------|-------------|-----------|
| [Bead ID] | [Bead ID] | [A blocks B / Shared dependency / Conflict] | [Persona] |

### Recommended Sequencing
[If items should be worked in a specific order based on dependencies, state it here]
```

### Step 4: Update Beads

For items that are now ready to build:
- Update the bead description with refined acceptance criteria
- Create dependency beads identified during grooming
- Link dependencies with `bd dep add`
- Update priority if the grooming revealed it should change

For items that are NOT ready to build:
- Add a comment noting what's blocking readiness
- Create any prerequisite beads (spikes, clarifications, design work)
- Link prerequisites as dependencies

### Step 5: Recommend Spikes

If any item has unknowns that can't be resolved in grooming, recommend a `/spike` with the specific question to answer and which personas should investigate.

## Rules

- **Value first, domain second.** Every item must pass the user value gate before personas evaluate it. Domain expertise serves user needs — it doesn't generate them
- **Grooming is not planning.** Don't sequence work. Just make items ready to be worked
- **Grooming is not work creation.** Personas assess feasibility and risk of proposed work. They do not generate new beads from their domain unless those beads directly serve the stated user value
- **"I don't know" is a valid answer.** If a persona can't size an item because requirements are unclear, that's a finding — the item isn't ready to build until the question is answered
- **"Users don't need this" is a valid outcome.** If grooming reveals that an item's user value is weak or absent, recommend closing it. A smaller, focused backlog beats a large, unfocused one
- **Decompose what's too big.** If the overall size is "Epic — needs decomposition," recommend breaking it into smaller beads — each with its own user value statement
- **Depth over breadth.** If an item needs deep analysis, go deep. Don't rush through items to hit a count — thoroughly refined items are worth more than superficially touched ones
- **Dependencies are the most important output.** Work with hidden dependencies will fail. Surface every dependency and create the beads
- **Acceptance criteria serve the user outcome.** The first acceptance criterion is always the user value being delivered. Domain-specific criteria support that outcome — they don't stand alone
