#!/usr/bin/env bash
set -euo pipefail

# Claude Agent Dev Team — Installer
# Symlinks skills into ~/.claude/skills/ so git pull updates automatically
# Use --copy to copy instead of symlink (for customization)

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="${HOME}/.claude/skills"
RETRO_DIR="${HOME}/retros"
MODE="symlink"

# Parse flags
for arg in "$@"; do
  case $arg in
    --copy)
      MODE="copy"
      shift
      ;;
    --uninstall)
      MODE="uninstall"
      shift
      ;;
    --help|-h)
      echo "Usage: ./install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  (default)    Symlink skills into ~/.claude/skills/ (git pull updates automatically)"
      echo "  --copy       Copy skills instead of symlink (for customization)"
      echo "  --uninstall  Remove installed skills"
      echo "  --help       Show this help"
      exit 0
      ;;
  esac
done

# All skill directories (order doesn't matter)
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
  observability-engineer
  qa-engineer
  technical-writer
  retro
  team-plan
  team-review
  standup
  grooming
  spike
  postmortem
)

if [ "$MODE" = "uninstall" ]; then
  echo "Uninstalling Claude Agent Dev Team skills..."
  for skill in "${SKILLS[@]}"; do
    target="${SKILLS_DIR}/${skill}"
    if [ -L "$target" ] || [ -d "$target" ]; then
      rm -rf "$target"
      echo "  Removed: $skill"
    fi
  done
  echo "Done. Skills removed from ${SKILLS_DIR}"
  echo "Note: ${RETRO_DIR} was not removed (may contain your retrospectives)"
  exit 0
fi

echo "Installing Claude Agent Dev Team skills..."
echo "  Mode: ${MODE}"
echo "  From: ${REPO_DIR}"
echo "  To:   ${SKILLS_DIR}"
echo ""

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Create retro directory
mkdir -p "$RETRO_DIR"

# Track results
installed=0
skipped=0
updated=0

for skill in "${SKILLS[@]}"; do
  source="${REPO_DIR}/${skill}"
  target="${SKILLS_DIR}/${skill}"

  if [ ! -d "$source" ]; then
    echo "  WARN: ${skill} not found in repo, skipping"
    ((skipped++))
    continue
  fi

  # Check if already installed
  if [ -L "$target" ]; then
    # Existing symlink — check if it points to us
    existing="$(readlink "$target")"
    if [ "$existing" = "$source" ]; then
      echo "  OK:   ${skill} (already linked)"
      ((skipped++))
      continue
    else
      echo "  UPDATE: ${skill} (repointing symlink)"
      rm "$target"
      ((updated++))
    fi
  elif [ -d "$target" ]; then
    if [ "$MODE" = "symlink" ]; then
      echo "  SKIP: ${skill} (directory exists — use --copy to overwrite, or remove manually)"
      ((skipped++))
      continue
    else
      echo "  UPDATE: ${skill} (overwriting)"
      rm -rf "$target"
      ((updated++))
    fi
  fi

  if [ "$MODE" = "symlink" ]; then
    ln -s "$source" "$target"
    echo "  LINK: ${skill}"
  else
    cp -R "$source" "$target"
    echo "  COPY: ${skill}"
  fi
  ((installed++))
done

echo ""
echo "Done!"
echo "  Installed: ${installed}"
echo "  Updated:   ${updated}"
echo "  Skipped:   ${skipped}"
echo "  Retro dir: ${RETRO_DIR}"
echo ""

if [ "$MODE" = "symlink" ]; then
  echo "Skills are symlinked — run 'git pull' in this repo to update them."
  echo "To customize a skill without affecting the repo, copy it manually:"
  echo "  cp -R ${SKILLS_DIR}/<skill> ${SKILLS_DIR}/<skill>-custom"
else
  echo "Skills are copied — changes to the repo won't auto-update."
  echo "Run './install.sh --copy' again after 'git pull' to update."
fi
