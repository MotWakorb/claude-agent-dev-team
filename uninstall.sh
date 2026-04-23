#!/usr/bin/env bash
set -euo pipefail

# Claude Agent Dev Team — Uninstaller
# Removes skills installed by install.sh from ~/.claude/skills/

SKILLS_DIR="${HOME}/.claude/skills"
RETRO_DIR="${HOME}/retros"

SKILLS=(
  _shared
  security-engineer
  it-architect
  project-manager
  project-engineer
  ux-designer
  code-reviewer
  database-engineer
  sre
  qa-engineer
  technical-writer
  retro
  team-plan
  team-review
  standup
  grooming
  spike
  postmortem
  onboard
)

# Check if anything is installed
found=0
for skill in "${SKILLS[@]}"; do
  target="${SKILLS_DIR}/${skill}"
  if [ -L "$target" ] || [ -d "$target" ]; then
    found=$((found + 1))
  fi
done

if [ "$found" -eq 0 ]; then
  echo "Nothing to uninstall — no Claude Agent Dev Team skills found in ${SKILLS_DIR}"
  exit 0
fi

echo "Found ${found} installed skill(s) in ${SKILLS_DIR}"
echo ""

# Allow --yes to skip confirmation
if [[ "${1:-}" != "--yes" && "${1:-}" != "-y" ]]; then
  read -rp "Remove all Claude Agent Dev Team skills? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

echo ""
echo "Uninstalling Claude Agent Dev Team skills..."
removed=0
for skill in "${SKILLS[@]}"; do
  target="${SKILLS_DIR}/${skill}"
  if [ -L "$target" ] || [ -d "$target" ]; then
    rm -rf "$target"
    echo "  Removed: $skill"
    removed=$((removed + 1))
  fi
done

echo ""
echo "Done. Removed ${removed} skill(s) from ${SKILLS_DIR}"
echo "Note: ${RETRO_DIR} was not removed (may contain your retrospectives)"
