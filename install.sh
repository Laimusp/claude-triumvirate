#!/usr/bin/env sh
# Claude Triumvirate - skill installer (macOS/Linux)
# Copies skills/* into ~/.claude/skills, backing up existing versions.
#
# Backups go OUTSIDE ~/.claude/skills on purpose: Claude Code treats every directory in there as a
# skill and takes the command name from the DIRECTORY name, so a backup left beside the original
# (tb.bak-...) shows up as a second, stale skill with the same trigger phrases.
set -eu

SRC_ROOT="$(cd "$(dirname "$0")" && pwd)/skills"
DST_ROOT="$HOME/.claude/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
BAK_ROOT="$HOME/.claude/skills-backup/$STAMP"

mkdir -p "$DST_ROOT"

for s in tb takt mtakt prosto; do
    src="$SRC_ROOT/$s"
    dst="$DST_ROOT/$s"
    if [ ! -d "$src" ]; then
        echo "[SKIP] $s - not found in package"
        continue
    fi
    if [ -e "$dst" ]; then
        mkdir -p "$BAK_ROOT"
        mv "$dst" "$BAK_ROOT/$s"
        echo "[BACKUP] existing '$s' moved to $BAK_ROOT/$s"
    fi
    cp -R "$src" "$dst"
    echo "[OK] installed skill: $s"
done

echo
echo "NEXT STEPS:"
echo "  1. Append CLAUDE.md.template content to ~/.claude/CLAUDE.md"
echo "     (core v2 prompt - required for full-strength TB)."
echo "  2. Connect MCP servers for the TB gods - keys must be EXACTLY 'codex' / 'antigravity'"
echo "     (the skills call mcp__codex__codex and mcp__antigravity__ask-antigravity):"
echo "       codex:       claude mcp add codex -s user -- codex mcp-server"
echo "       antigravity: https://github.com/Laimusp/antigravity-mcp"
echo "  3. Restart Claude Code."
echo "  4. Optional: add .tb-artifact.md to your global gitignore - TB writes it into the repo"
echo "     root during a review and deletes it afterwards."
