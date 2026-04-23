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

# --- Remove managed block from ~/.claude/CLAUDE.md ---
CLAUDE_MD="${HOME}/.claude/CLAUDE.md"
MARKER_START="# --- Claude Agent Dev Team (managed) ---"
MARKER_END="# --- End Claude Agent Dev Team ---"

if [ -f "$CLAUDE_MD" ] && grep -qF "$MARKER_START" "$CLAUDE_MD"; then
  awk -v start="$MARKER_START" -v end="$MARKER_END" '
    $0 == start { skip=1; next }
    skip && $0 == end { skip=0; next }
    !skip { print }
  ' "$CLAUDE_MD" > "${CLAUDE_MD}.tmp" && mv "${CLAUDE_MD}.tmp" "$CLAUDE_MD"
  # Remove file if it's now empty (only whitespace)
  if [ ! -s "$CLAUDE_MD" ] || ! grep -q '[^[:space:]]' "$CLAUDE_MD" 2>/dev/null; then
    rm -f "$CLAUDE_MD"
    echo "  Removed: ${CLAUDE_MD} (was empty after cleanup)"
  else
    echo "  Cleaned: ${CLAUDE_MD} (removed managed block, preserved other content)"
  fi
fi

echo ""
echo "Done. Removed ${removed} skill(s) from ${SKILLS_DIR}"
echo "Note: ${RETRO_DIR} was not removed (may contain your retrospectives)"
