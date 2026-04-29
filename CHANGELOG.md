# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) at the system level.

Each `SKILL.md` carries a `version:` field in its frontmatter showing the system version it last meaningfully changed in. To check what's installed: `grep -E "^name:|^version:" ~/.claude/skills/*/SKILL.md`.

## [Unreleased]

## [0.2.0]

Tier-aware personas, per-task model selection, and explicit versioning.

### Added
- `_shared/deployment-tier.md` — defines four deployment tiers (`home-lab`, `small-team`, `startup`, `enterprise`) and per-persona calibration tables. Personas read this and the project's `COMPONENTS.md` to right-size recommendations to the deployment context.
- `COMPONENTS.md` (per-project artifact) produced by `/onboard`. Lists each component in the project with its deployment tier. Required for the team ceremonies to run.
- New Step 3 in `/onboard` — Component Inventory & Tier Confirmation. The IT Architect drafts a component list with proposed tiers; other personas contribute tier signals; the PO confirms; `COMPONENTS.md` is written.
- **Preflight check** in `/team-plan`, `/team-review`, `/standup`, `/grooming`, `/spike`, `/postmortem` — refuse to run if `COMPONENTS.md` is missing, directing the user to `/onboard`.
- **Cross-tier resolution rule** — when work spans components at different tiers, strictest tier wins by default. Surface as a decision when applying it across the board would be clearly wasteful.
- **Agent Model Selection** section in `_shared/orchestration.md` — per-task-type model assignments (`haiku` for triage, `sonnet` for most domain work, `opus` for sticky decisions). Tier modulation: home-lab effective tier downshifts one level *except* for security-engineer.
- `model:` field in every persona `SKILL.md` frontmatter (default `sonnet`) — declares the persona's default when invoked directly.
- `version:` field in every `SKILL.md` frontmatter — echoes the system version the skill last changed in.
- README sections: "Project Onboarding (Required Before Team Skills Run)", "Tier-Aware Personas", "Per-Task Model Selection", "Versioning & Rollback".
- `CHANGELOG.md` (this file).
- `CONTRIBUTING.md` updates: documented `model:` and `version:` frontmatter, semver policy, and per-skill version bump expectations.

### Changed
- Persona "Hard Rules" sections in `sre/`, `technical-writer/`, `qa-engineer/`, `database-engineer/`, `it-architect/` reframed from absolute (`No exceptions`) to tier-conditional. Maximum-rigor wording preserved as the *enterprise-tier* baseline; lower tiers documented per-rule.
- Persona preambles (sre, technical-writer, qa-engineer, database-engineer, it-architect) now reference `_shared/deployment-tier.md` and instruct the persona to read `COMPONENTS.md` before producing recommendations.
- `/standup` agent prompts now instruct personas to rate R/Y/G against each component's own tier — a home-lab service is not RED for missing enterprise practices.
- Single-persona invocations (`/sre`, etc.) ask which tier the work is for if `COMPONENTS.md` doesn't cover the in-scope component.

### Tier-Invariant Behavior (Unchanged)
- Critical security findings (CVSS 9.0+) remain non-negotiable at every tier. The CVE in a home-lab service is still a CVE.
- Engineering Discipline (`_shared/engineering-discipline.md`), the Conflict Resolution Protocol, naming discipline, the value gate, and AI-realistic effort estimates apply at every tier.
- Vendor portability and open-source-tooling rules in `it-architect/` remain tier-invariant.

## [0.1.0]

Initial release. Baseline of the Claude Agent Dev Team — 10 personas with domain authority, professional biases, and conflict-resolution protocols, plus eight ceremonies (`/team-plan`, `/team-review`, `/standup`, `/grooming`, `/spike`, `/postmortem`, `/onboard`, `/retro`). See [README.md](./README.md) for the feature list as of this release.

[Unreleased]: https://github.com/MotWakorb/claude-agent-dev-team/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/MotWakorb/claude-agent-dev-team/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/MotWakorb/claude-agent-dev-team/releases/tag/v0.1.0
