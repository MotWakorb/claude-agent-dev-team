---
name: spike
description: Technical spike — targeted investigation when a decision is blocked by unknowns. Spawns only the relevant personas to research a specific question and report back with findings, not all 11.
when_to_use: technical spike, investigation, research, unknowns, proof of concept, feasibility, exploration
user-invocable: true
---

# Technical Spike

A spike answers a specific question that's blocking a decision. It is not a planning session, not a review, not a free-form exploration. One question in, findings out.

## Process

### Step 1: Define the Spike

Every spike has exactly three things:

1. **The Question**: What specific thing do we need to know? Not "investigate database options" — "Can PostgreSQL handle 50M rows with our access pattern at < 50ms p99, or do we need to denormalize?"
2. **The Timebox**: How long should this take? Spikes are bounded. 30 minutes, 2 hours, half a day — never open-ended
3. **The Personas**: Which domain experts need to investigate? Not all 11 — just the ones whose domain the question touches

If the PO hasn't provided these, ask for them. If the question is vague, sharpen it before proceeding.

### Step 2: Select Personas

Only spawn the personas relevant to the question. Common patterns:

| Spike Type | Personas |
|-----------|----------|
| "Can this tech handle our scale?" | Database Engineer, Architect, SRE |
| "Is this approach secure?" | Security Engineer, Architect, Engineer |
| "Can we build this UX within our architecture?" | UX Designer, Engineer, Architect |
| "What's the operational cost of this approach?" | SRE, Observability Engineer, Architect |
| "How should we test this?" | QA Engineer, Engineer, Code Reviewer |
| "What's the migration path?" | Database Engineer, Engineer, Architect |
| "What would the API look like?" | Code Reviewer, Engineer, UX Designer |
| "How do we instrument this?" | Observability Engineer, SRE, Engineer |
| "What are the compliance implications?" | Security Engineer, Technical Writer |

### Step 3: Spawn Targeted Agents

Launch only the selected persona agents in parallel. **IMPORTANT: All agents must be spawned as `general-purpose` type** (subagent_type: "general-purpose"). The persona identity comes from the prompt:

**Each agent prompt:**
```
Read ~/.claude/skills/[persona]/SKILL.md for your domain scope.
Read ~/.claude/skills/_shared/engineering-discipline.md.

You are the [Persona]. This is a technical spike — a targeted investigation to answer a specific question.

Question: [The specific question]
Context: [Background — what led to this question, what constraints exist]
Timebox: [How long — keep your investigation proportional]

Investigate and respond with:

1. **Answer**: [Direct answer to the question — yes/no/it depends, with specifics]
2. **Evidence**: [What you found that supports your answer — data, benchmarks, documentation, code analysis, examples]
3. **Risks**: [What could go wrong with the approach your answer implies]
4. **Alternatives**: [If the answer is "no" or "it depends," what are the alternatives?]
5. **Confidence**: [High / Medium / Low — how confident are you in this answer, and what would increase confidence?]
6. **Disagree with**: [If you anticipate another persona on this spike will reach a different conclusion, state it]

Work from evidence. Do not theorize when you can test, benchmark, or read documentation. If you can write a quick proof-of-concept, do it. If you can run EXPLAIN ANALYZE, run it. If you can check the actual library documentation, check it.
```

### Step 4: Synthesize Findings

Present the spike results focused on answering the original question:

```markdown
## Spike: [Question]

### Context
[Why this question was asked — what decision it unblocks]

### Bead: [Bead ID if this spike is tracked as a bead]

### Answer
[Direct answer — synthesized from all persona findings]

### Confidence: [High / Medium / Low]
[What the confidence level is based on — evidence quality, agreement between personas]

### Evidence
| Source | Finding | Persona |
|--------|---------|---------|
| [Benchmark / Doc / Code analysis / PoC] | [What it showed] | [Who found it] |

### Persona Findings

#### [Persona 1]
[Their answer, evidence, and risks — condensed]

#### [Persona 2]
[Their answer, evidence, and risks — condensed]

### Disagreements
[Where personas reached different conclusions — present both sides]

| Point of Disagreement | [Persona A] Says | [Persona B] Says |
|----------------------|-----------------|-----------------|
| ... | ... | ... |

### Risks
| Risk | Likelihood | Impact | Raised By |
|------|-----------|--------|-----------|
| ... | ... | ... | ... |

### Recommendation
[Based on the findings — what should the team do? Present as a recommendation, not a decision — the PO decides]

### Follow-Up Actions
- [ ] [If confidence is low — what additional investigation would help]
- [ ] [If the answer changes the approach — what beads need updating]
- [ ] [If a decision is needed — frame it for the PO]

### Decision for PO
[If the spike findings require a product decision, frame it clearly]
- **Option A**: [Based on Persona X's findings] — [trade-off]
- **Option B**: [Based on Persona Y's findings] — [trade-off]
```

### Step 5: Update Beads

- If the spike was tracked as a bead, close it with the findings summary as the reason
- If the spike changes the approach for a parent bead, update the parent bead's description
- If the spike reveals new work, create beads for it
- If the spike answers a grooming question, mark the blocked item as sprint-ready (or not, with reasoning)

## Rules

- **One question per spike.** If you have three questions, run three spikes. Mixing questions produces muddy answers
- **Timeboxed.** Spikes don't expand indefinitely. If the timebox expires and the answer is still "we don't know," that's a finding — it means the question needs decomposition or a different approach
- **Evidence over opinion.** A spike that concludes "we think it'll be fine" without testing, benchmarking, or reading documentation is not a spike — it's a guess. Follow the engineering discipline: evidence over intuition
- **Not all 11 personas.** Spawning all 11 for a database performance question wastes context and produces noise. Pick the 2-4 personas whose domains are relevant
- **Spikes produce answers, not code.** If a spike produces a proof-of-concept, that's great — but the PoC is evidence, not deliverable code. It lives in a throwaway branch, not main
- **Disagreement is signal.** If the DBA says "denormalize" and the architect says "keep it normalized," that's not a failure — that's the spike working. Surface the disagreement for the PO
