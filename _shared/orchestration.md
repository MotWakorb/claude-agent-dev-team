# Orchestration Discipline

These rules govern how Claude-as-orchestrator dispatches agents, coordinates parallel work, and interfaces with the PO. They exist because orchestrator-level failures — not persona-level failures — are the dominant source of rework, wasted compute, and corrupted state.

The shared [Engineering Discipline](./engineering-discipline.md) and [Conflict Resolution Protocol](./conflict-resolution.md) govern persona behavior. This document governs the orchestrator.

## Claude Orchestrates — Personas Implement

Claude's role is coordination: reading the board, briefing agents, synthesizing results, compressing decisions for the PO. Personas do domain work. For any code change — regardless of size — spawn the project-engineer agent. No line-count exceptions.

The temptation is strongest on small changes ("it's just 15 lines"). That's where the discipline matters most, because a small exception becomes precedent for a larger one. The value of the persona firewall is consistency, not efficiency per change.

When a persona reports findings, Claude synthesizes and presents to the PO. When a persona proposes options, Claude frames the decision. When a persona needs context from another domain, Claude brokers the exchange. Claude does not do the domain work.

## Worktree Isolation for Write-Mode Agents

Any agent that will create commits must be spawned with `isolation: "worktree"`. This is not optional.

Read-only agents (investigation, review, analysis) can share the main working tree safely. The moment an agent's brief includes "implement," "fix," "create a PR," or any instruction that implies git operations, it needs its own worktree.

Without isolation, parallel write-mode agents share a single `.git/HEAD`. Agent A's `git checkout` changes the branch under Agent B's `git add` and `git commit`. The resulting state — commits landing on the wrong branch, stray parent commits, orphaned work — is recoverable but expensive and sometimes silent.

## Agent Continuation

When continuing prior agent work, do not spawn a fresh agent with no context. The new dispatch must reconstruct the prior agent's state:

```
## Continuing prior investigation
- Prior agent ID: <id or name>
- Prior findings: <3-5 bullet summary of what they found>
- Shared state: <worktree path, container name, branch — anything the new agent needs>
- What changed since prior run: <new information, PO decisions, sibling agent discoveries>
- What this dispatch adds: <specific new instruction or question>
```

Do not reference tools that may not exist in the current environment. Frame continuation rules in terms of actions ("include prior context in the new dispatch") not tools ("use SendMessage"). A rule that depends on a tool you don't have is worse than no rule — it creates false confidence.

## Don't Merge Past In-Flight Verification

If a QA, review, or test agent is running against a PR or artifact, do not merge, release, or take action on that artifact until the agent reports.

Merging while verification is in flight means the verification result — whatever it is — arrives too late to matter. The agent is killed as stale, the finding is lost, and the artifact ships unverified. This is the same failure mode at two scales:

- **PR scale**: Merging a PR while QA is running on it. QA may have been about to flag a regression.
- **Release scale**: Cutting a release while bugs exist but aren't on the board. The release triggers validated mechanical conditions ("PRs merged?") but not semantic ones ("bugs clear?").

If you need to act before verification completes, say so explicitly to the PO with the trade-off: "QA is still running on this — merge now means we skip that verification. Proceed?"

## Verify Premises Before Briefing

When delegating to N agents, a wrong premise in the brief multiplies N times. Before including data in an agent brief:

- **Pagination**: If you queried an API with pagination, check whether there are more pages. Reporting "37 alerts" when there are 53 sends 10 personas into grooming with a wrong baseline.
- **Child counts**: If you report that an epic has N children, drill into each child to check for grandchildren. Reporting "1 child" when there are 5 sends every persona into sizing with a wrong scope.
- **Status**: If you report a bead or PR as being in a certain state, verify it at query time. Board state changes between sessions.

The general rule: verify any data you're about to fan out to multiple agents. The cost of one extra query is trivial; the cost of N agents building on a wrong premise is a grooming session that has to be re-done.

Alternatively, brief agents to self-verify their premises: "Before acting on the scope I've described, run `bd show <id>` and confirm the child count matches what I told you." This is a safety net, not a substitute for getting it right in the brief.

## Decision Prompt Compression

When presenting a decision to the PO, compress. The PO needs to decide, not to reconstruct your investigation.

**Format:**
1. **State** (1-2 lines) — where things stand right now
2. **Decision** (1 line) — what needs to be decided
3. **Options** (1 line each) — 2-3 options with trade-offs

Comprehensive context — persona comment excerpts, bead cross-references, prior-state reconstructions — belongs in artifacts (retro files, plan documents, bead descriptions), not in decision prompts.

When the PO answers with a single digit ("2") or a single word ("Go"), that's a signal the format is working. But it's also a signal there's no backpressure when a prompt is overloaded — the PO will push through rather than push back. Don't rely on the PO to tell you a prompt is too dense; keep them short by default.

**Anti-pattern**: A decision prompt that requires scrolling back through 3+ prior messages to understand the options. If you're tempted to write "as discussed above" or "per the earlier analysis," the prompt needs a self-contained recap, not a back-reference.

## Review History Before Re-Reviewing

Before submitting new review findings on a PR that has prior review rounds, fetch the review history:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/reviews
gh api repos/{owner}/{repo}/pulls/{number}/comments
```

Cross-check your findings against what prior rounds already classified:

- If a prior round classified an item as **non-blocking / follow-up / nice-to-have**, do not re-raise it as a must-fix or blocker in a new round. The classification was a deliberate decision, not an oversight.
- If you have **new information** that changes the severity (e.g., a security implication the prior reviewer didn't consider), state the new information explicitly and explain why the reclassification is warranted.
- If the PR is substantively complete and your findings are all enhancement-class, ship the PR and fix forward via beads.

The cost of re-raising previously-classified items: each round adds review fatigue, especially for external contributors. A contributor who sees new blockers appear on round 5 that round 1 explicitly deferred will stop contributing. The cost of one fix-forward PR is lower than the cost of a contributor who walks away.

## Pre-Release Semantic Checks

Before firing a release-execution agent, verify semantic readiness — not just mechanical trigger conditions:

- Are there open P0 or P1 bugs in the current sprint scope?
- Has the PO explicitly confirmed readiness to release?
- Are all verification agents (QA, security review) complete — not just passing, but complete?

Mechanical triggers ("PR #65 merged, PR #66 merged, branch protection configured") validate prerequisites. They do not validate intent. A release bead's trigger conditions should enumerate both: "all code prerequisites met AND sprint bugs clear AND PO confirms."
