---
name: retro
description: End-of-session retrospective capturing what went well, what the PO could improve, what the agent got wrong, and what would make the project better — with input from every persona that participated.
when_to_use: end of session, retrospective, session review, lessons learned
user-invocable: true
---

# Session Retrospective

Write a retrospective for the current session. Be honest — the PO can take meaningful feedback and expects it.

## Process

1. Review the full conversation to understand what happened this session
2. Identify which personas were invoked or relevant (even if not explicitly called via `/skill`)
3. Gather each persona's perspective on the session
4. Write the retrospective file
5. If relevant, update memory with durable lessons learned

## Output Location

Write the retrospective to `~/retros/` named `YYYY-MM-DD-HH_(three-word-topic).md`.

## Format

### Header

Begin the file with a level-1 heading derived from the filename (underscore replaced with ` — `). Immediately under the heading, bullet the session metadata:

```markdown
# 2026-04-19-14 — three-word-topic

- **ModelID**: [full model identifier including suffix]
- **TurnCount**: [total user + assistant messages in conversation]
- **ContextUsed**: [percentage estimate of context window consumed]
- **Personas Active**: [list of personas invoked or consulted during session]
- **Beads Touched**: [bead IDs created/updated/closed, or "None"]
```

**TurnCount:** Count all user and assistant messages in the conversation. This is a critical metric — failure modes surface late in sessions, not early. The turn count contextualizes when corrections occurred.

**ContextUsed:** Estimate from available signals — conversation length, tool call volume, file reads. Be honest about the estimate.

### Section 1: What We Did Well Together

One thing — with a concrete moment from the session. Not "good collaboration" — name the specific exchange, decision, or outcome that worked.

### Section 2: What the PO Could Improve

One thing the PO did that made the work harder, slower, or lower quality — even slightly. This is the hardest section to write honestly and the most valuable one. Be specific. Reference the moment. The PO asked for this feedback because they want to improve.

Examples of real feedback, not softened generalizations:
- "The PO changed direction on X after we'd already implemented Y — earlier framing of the constraint would have saved the rework"
- "The PO provided requirements for the security engineer and architect in the same message, which created ambiguity about which persona should lead"
- "The PO answered a clarifying question with 'just do whatever makes sense' — but the question had two reasonable answers with different downstream consequences"

Do NOT write "the PO could provide more context" or other vague politeness. Name the moment.

### Section 3: What the Agent Got Wrong

One thing the agent got wrong or could have handled better. Reference the specific turn or action. This is accountability, not self-deprecation.

Examples:
- "At turn 14, I started implementing before the PO finished framing the architecture — built on a partial frame and had to redo it"
- "I subsampled the beads output instead of reading all of it, which led to a missed dependency"
- "I should have pushed back on the timeline instead of silently accepting scope I knew was too large for the sprint"

### Section 4: What Would Make the Project Better

One thing that would improve the project, team, or process. This is forward-looking. It could be:
- A gap in the skills/personas
- A process improvement
- A tooling need
- An architectural concern that surfaced during the session
- A pattern that keeps recurring and should be addressed

### Section 5: Persona Perspectives

For each persona that was active or relevant during the session, capture their specific view. Each persona evaluates the session through their professional lens — they do NOT silently agree with each other.

```markdown
## Persona Perspectives

### Security Engineer
- **Session assessment**: [Did security concerns get adequate attention? Were they heard?]
- **What I'd flag**: [Security-relevant observations from this session's work]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### IT Architect
- **Session assessment**: [Were architectural decisions made thoughtfully? Were trade-offs explicit?]
- **What I'd flag**: [Architectural concerns from this session's work]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### Project Manager
- **Session assessment**: [Was work organized effectively? Were commitments realistic?]
- **What I'd flag**: [Process or delivery concerns from this session]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### Project Engineer
- **Session assessment**: [Was the implementation approach sound? Were engineering disciplines followed?]
- **What I'd flag**: [Technical concerns from this session's work]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### UX Designer
- **Session assessment**: [Were user experience implications considered? Was the user's perspective represented?]
- **What I'd flag**: [UX concerns from this session's work]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### Code Reviewer
- **Session assessment**: [Was code quality, test quality, and naming discipline maintained?]
- **What I'd flag**: [Quality concerns from this session's work]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### Database Engineer
- **Session assessment**: [Were data modeling and schema decisions sound? Were query patterns considered?]
- **What I'd flag**: [Data integrity, performance, or migration concerns from this session]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### SRE
- **Session assessment**: [Were operational concerns addressed? Were SLOs, observability, and reliability considered?]
- **What I'd flag**: [Reliability, observability, or operational concerns from this session]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### QA Engineer
- **Session assessment**: [Was the test strategy sound? Were testing gaps identified?]
- **What I'd flag**: [Test quality, coverage, or strategy concerns from this session]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### Technical Writer
- **Session assessment**: [Was documentation considered? Were decisions and knowledge captured?]
- **What I'd flag**: [Documentation gaps or stale docs from this session's work]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]

### Observability Engineer
- **Session assessment**: [Was observability considered? Were instrumentation standards followed?]
- **What I'd flag**: [Observability gaps, missing instrumentation, cost concerns from this session]
- **Disagreement**: [Where I disagreed with another persona's approach, if applicable]
```

**Rules for persona perspectives:**
- Every persona that was relevant to the session gets a voice — even if they weren't explicitly invoked. If we discussed architecture, the architect has a perspective. If we wrote code, the code reviewer has a perspective
- Personas should disagree with each other when warranted. If the PM thinks the session went great because we shipped fast, and the code reviewer thinks quality was sacrificed, BOTH views go in the retro
- "No concerns" is acceptable only if genuinely true. Do not fill in "no concerns" as a default — think through the session from that persona's lens
- The Disagreement field is the most important one. If every persona agrees, either the session was genuinely excellent or the retro is silently averaging. Check which one it is

### Section 6: Lessons for Future Sessions

Durable lessons that should inform future work. These are candidates for memory — things that won't be obvious from the code or git history.

```markdown
## Lessons

- **Keep**: [Pattern or approach that worked and should be repeated]
- **Stop**: [Pattern or approach that didn't work and should be avoided]
- **Start**: [Something we should try next time]
```

If a lesson is durable enough to warrant saving to memory, do so. If it's session-specific, leave it in the retro.

## Writing Standards

- **Explanatory mode** — thorough, detailed, with specific turn references and concrete moments
- **Honest over diplomatic** — the PO asked for real feedback. Give it
- **Specific over general** — "At turn 23, when we..." not "Sometimes we could..."
- **No self-congratulation** — "What we did well" is about the collaboration, not about how great the agent is
- **No hedging on Section 2** — if the PO made the session harder in any way, say so. Hedging defeats the purpose
- **Personas must not silently average** — if there's tension between perspectives, surface it. That's the point
