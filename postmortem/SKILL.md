---
name: postmortem
description: Blameless incident postmortem — SRE-led structured analysis of what went wrong, why, and how to prevent recurrence. Pulls relevant personas for contributing factor analysis. Timeline-driven, evidence-based, action-oriented.
when_to_use: incident postmortem, outage review, post-incident review, blameless postmortem, incident analysis, root cause analysis
user-invocable: true
---

# Incident Postmortem

Blameless. The question is "what failed?" not "who failed?" If a human error caused the incident, the system that allowed the human error is the root cause. We fix systems, not blame people.

## Process

### Step 1: Gather the Facts

Before spawning any agents, establish the incident record. Ask the PO for what's known, and supplement with available evidence:

```markdown
## Incident Record

- **Incident ID**: [If tracked — bead ID, incident number]
- **Date/Time**: [When it started, when it was detected, when it was resolved]
- **Duration**: [Total time from start to resolution]
- **Severity**: [P1 / P2 / P3]
- **Impact**: [User-facing impact — quantified if possible. "500 users couldn't log in for 45 minutes" not "auth was down"]
- **Detection**: [How was it detected? Alert, user report, internal observation?]
- **Resolution**: [What fixed it? Rollback, config change, scaling, code fix?]
```

Also gather:
- Relevant logs, metrics, traces from the incident window
- Deploy history around the incident time
- Any changes (config, infrastructure, code) in the 24 hours before
- Alert history — what fired, what didn't fire that should have
- Communication history — who was notified, when, how

If evidence is available, read it. All of it. Do not theorize without evidence.

### Step 2: Build the Timeline

Construct a detailed timeline from the evidence. This is the backbone of the postmortem:

```markdown
### Timeline

| Time | Event | Source |
|------|-------|--------|
| HH:MM | [What happened] | [Log / metric / alert / human observation] |
| HH:MM | [What happened] | [Source] |
| HH:MM | **INCIDENT START** — [First user impact] | [Source] |
| HH:MM | [Detection — how was it noticed?] | [Alert / user report] |
| HH:MM | [First response action] | [Who / what] |
| HH:MM | [Diagnosis steps taken] | [Who / what] |
| HH:MM | [Mitigation applied] | [Who / what] |
| HH:MM | **INCIDENT RESOLVED** — [Impact ended] | [Source] |
| HH:MM | [Post-resolution verification] | [Who / what] |
```

Key metrics to note in the timeline:
- **Time to detect (TTD)**: How long from incident start to detection
- **Time to respond (TTR)**: How long from detection to first response action
- **Time to mitigate (TTM)**: How long from first response to user impact resolved
- **Total duration**: Start to resolution

### Step 3: Spawn Relevant Agents

Not all 11 personas are relevant to every incident. Select based on what the incident touched:

| If the incident involved... | Include... |
|---------------------------|-----------|
| Application code / logic error | Project Engineer, Code Reviewer |
| Database / data integrity | Database Engineer |
| Infrastructure / deployment | SRE, IT Architect |
| Security breach / vulnerability | Security Engineer |
| Observability gap (couldn't diagnose) | Observability Engineer |
| Missing / wrong documentation | Technical Writer |
| User-facing impact / UX failure | UX Designer |
| Test gap (should have been caught) | QA Engineer |
| Process failure (wrong prioritization) | Project Manager |

**Always include SRE** — they own incident response.
**Always include the persona(s) whose domain the root cause lives in.**

**IMPORTANT: All agents must be spawned as `general-purpose` type** (subagent_type: "general-purpose"). The persona identity comes from the prompt.

**Each agent prompt:**
```
Read ~/.claude/skills/[persona]/SKILL.md for your domain scope.
Read ~/.claude/skills/_shared/engineering-discipline.md.

You are the [Persona]. We are conducting a blameless postmortem for the following incident.

Incident Record:
[Paste incident record from Step 1]

Timeline:
[Paste timeline from Step 2]

Evidence:
[Paste or reference relevant logs, metrics, traces, deploy history]

From your domain perspective, analyze:

1. **Root Cause Contribution**: Did your domain contribute to this incident? Be honest — if a test gap, a missing alert, a bad schema migration, an insecure config, or a missing runbook contributed, say so
2. **Detection Assessment**: Could your domain have detected this earlier? Was there a missing metric, alert, test, or review that would have caught this?
3. **Response Assessment**: Did your domain's processes help or hinder the response? Was the runbook useful? Were the right tools available?
4. **Prevention**: What specific changes in your domain would prevent recurrence? Be concrete — not "improve monitoring" but "add alert on payment-service error rate > 0.5% with 5-minute window"
5. **Systemic Issues**: Does this incident reveal a pattern or systemic issue beyond the immediate root cause?

This is blameless. Do not blame individuals. Identify system failures — missing guardrails, absent tests, incomplete runbooks, gaps in review processes. If a human made an error, the question is "why did the system allow this error to reach production?"
```

### Step 4: Identify Root Cause and Contributing Factors

Synthesize the agent findings into a root cause analysis:

```markdown
### Root Cause
[The specific, technical root cause. One or two sentences. Not "human error" — what systemic failure allowed the error to happen?]

### Contributing Factors
| Factor | Domain | How It Contributed | Could Have Prevented? |
|--------|--------|-------------------|----------------------|
| [e.g., No integration test for this code path] | QA / Engineer | Bug reached production untested | Yes — test would have caught it |
| [e.g., Alert threshold too high] | Observability / SRE | Detection delayed by 15 minutes | Yes — lower threshold = faster detection |
| [e.g., Runbook outdated] | Technical Writer / SRE | Response slowed by incorrect steps | Partially — correct runbook = faster mitigation |
| [e.g., No migration rollback plan] | Database Engineer | Couldn't quickly revert | Yes — rollback plan = faster recovery |
```

### Step 5: What Went Well / What Went Wrong

```markdown
### What Went Well
- [Specific things that worked during detection, response, or recovery]
- [Good practices that should be reinforced]

### What Went Wrong
- [Specific things that failed, were missing, or slowed the response]
- [Not blame — systemic gaps]

### Where We Got Lucky
- [Things that could have made the incident worse but didn't — by luck, not by design]
- [These are the scariest findings — they reveal risks that haven't materialized yet]
```

### Step 6: Action Items

Every action item must be specific, owned, and tracked as a bead:

```markdown
### Action Items

#### Prevention (Prevent this specific incident from recurring)
| # | Action | Owner | Priority | Bead ID |
|---|--------|-------|----------|---------|
| 1 | [Specific technical change] | [Persona/role] | P0-P3 | [Create bead] |

#### Detection (Detect this class of incident faster)
| # | Action | Owner | Priority | Bead ID |
|---|--------|-------|----------|---------|
| 1 | [Alert, metric, test to add] | [Persona/role] | P0-P3 | [Create bead] |

#### Response (Respond to this class of incident better)
| # | Action | Owner | Priority | Bead ID |
|---|--------|-------|----------|---------|
| 1 | [Runbook, procedure, tooling] | [Persona/role] | P0-P3 | [Create bead] |

#### Systemic (Address patterns beyond this incident)
| # | Action | Owner | Priority | Bead ID |
|---|--------|-------|----------|---------|
| 1 | [Process, architecture, or practice change] | [Persona/role] | P0-P3 | [Create bead] |
```

### Step 7: Create Beads and Store Postmortem

1. Create beads for every action item with appropriate priority and type
2. Link action item beads to the incident bead (if one exists) as dependencies
3. Write the full postmortem to a file:
   - If a postmortem directory exists, write there
   - Otherwise, suggest a location to the PO

```markdown
## Postmortem: [Incident Title]

### Metadata
- **Date**: [Incident date]
- **Author**: [Who wrote this postmortem]
- **Severity**: [P1/P2/P3]
- **Duration**: [Total duration]
- **Impact**: [User-facing impact — quantified]
- **TTD / TTR / TTM**: [Time to detect / respond / mitigate]

### Summary
[3-4 sentences: what happened, what the impact was, what fixed it, and what we're doing to prevent recurrence]

### Timeline
[Full timeline from Step 2]

### Root Cause
[From Step 4]

### Contributing Factors
[From Step 4]

### What Went Well
[From Step 5]

### What Went Wrong
[From Step 5]

### Where We Got Lucky
[From Step 5]

### Action Items
[From Step 6 — all four categories]

### Lessons Learned
[Key takeaways that apply beyond this specific incident]

### Persona Perspectives
[Key findings from each persona that participated in the analysis]
```

## Rules

- **Blameless means blameless.** "Developer X pushed bad code" is blame. "The CI pipeline did not include an integration test for this code path, allowing the regression to reach production" is a systemic finding. Always the second form
- **Evidence-based.** Every root cause claim must reference evidence from the timeline — logs, metrics, deploys, alerts. "We think it was probably..." is not a root cause. "The deploy at 14:23 introduced a config change that reduced the connection pool, as shown in metric X" is a root cause
- **Action items are beads.** Every action item becomes a tracked bead with a priority and an owner. Postmortem action items that live only in a document never get done
- **"Where We Got Lucky" is mandatory.** This is the most valuable section. It reveals risks that are still active — things that could have made it worse but didn't, by luck not by design. These are future incidents waiting to happen
- **Not all personas every time.** An application bug postmortem doesn't need the UX designer. A data integrity incident doesn't need the observability engineer (unless the gap was in observability). Include who's relevant
- **Always include the SRE.** They own incident response and are always relevant
- **Postmortem immediately after resolution.** Run the postmortem as soon as the incident is resolved while all evidence is available. Don't defer it — context is richest right now
