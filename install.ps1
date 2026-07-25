# Claude Triumvirate - skill installer (Windows)
# Copies skills/* into ~/.claude/skills, backing up existing versions.
#
# Backups go OUTSIDE ~/.claude/skills on purpose: Claude Code treats every directory in there as a
# skill and takes the command name from the DIRECTORY name, so a backup left beside the original
# (tb.bak-...) shows up as a second, stale skill with the same trigger phrases.
$ErrorActionPreference = 'Stop'

$skills = @('tb', 'takt', 'mtakt', 'prosto')
$srcRoot = Join-Path $PSScriptRoot 'skills'
$dstRoot = Join-Path $env:USERPROFILE '.claude\skills'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$bakRoot = Join-Path $env:USERPROFILE ".claude\skills-backup\$stamp"

New-Item -ItemType Directory -Force -Path $dstRoot | Out-Null

foreach ($s in $skills) {
    $src = Join-Path $srcRoot $s
    $dst = Join-Path $dstRoot $s
    if (-not (Test-Path $src)) {
        Write-Host "[SKIP] $s - not found in package"
        continue
    }
    if (Test-Path $dst) {
        New-Item -ItemType Directory -Force -Path $bakRoot | Out-Null
        Move-Item -Path $dst -Destination (Join-Path $bakRoot $s)
        Write-Host "[BACKUP] existing '$s' moved to $bakRoot\$s"
    }
    Copy-Item -Recurse -Path $src -Destination $dst
    Write-Host "[OK] installed skill: $s"
}

Write-Host ""
Write-Host "NEXT STEPS:"
Write-Host "  1. Append CLAUDE.md.template content to $env:USERPROFILE\.claude\CLAUDE.md"
Write-Host "     (core v2 prompt - required for full-strength TB)."
Write-Host "  2. Connect MCP servers for the TB gods - keys must be EXACTLY 'codex' / 'antigravity'"
Write-Host "     (the skills call mcp__codex__codex and mcp__antigravity__ask-antigravity):"
Write-Host "       codex:       claude mcp add codex -s user -- codex mcp-server"
Write-Host "       antigravity: https://github.com/Laimusp/antigravity-mcp"
Write-Host "  3. Restart Claude Code."
Write-Host "  4. Optional: add .tb-artifact.md to your global gitignore - TB writes it into the repo"
Write-Host "     root during a review and deletes it afterwards."
