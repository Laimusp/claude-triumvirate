# Claude Triumvirate - skill installer (Windows)
# Copies skills/* into ~/.claude/skills, backing up existing versions.
$ErrorActionPreference = 'Stop'

$skills = @('tb', 'takt', 'mtakt', 'prosto')
$srcRoot = Join-Path $PSScriptRoot 'skills'
$dstRoot = Join-Path $env:USERPROFILE '.claude\skills'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

New-Item -ItemType Directory -Force -Path $dstRoot | Out-Null

foreach ($s in $skills) {
    $src = Join-Path $srcRoot $s
    $dst = Join-Path $dstRoot $s
    if (-not (Test-Path $src)) {
        Write-Host "[SKIP] $s - not found in package"
        continue
    }
    if (Test-Path $dst) {
        $bak = "$dst.bak-$stamp"
        Move-Item -Path $dst -Destination $bak
        Write-Host "[BACKUP] existing '$s' moved to $bak"
    }
    Copy-Item -Recurse -Path $src -Destination $dst
    Write-Host "[OK] installed skill: $s"
}

Write-Host ""
Write-Host "NEXT STEPS:"
Write-Host "  1. Append CLAUDE.md.template content to $env:USERPROFILE\.claude\CLAUDE.md"
Write-Host "     (core v2 prompt - required for full-strength TB)."
Write-Host "  2. Connect MCP servers for the TB gods:"
Write-Host "       codex:       claude mcp add codex -s user -- codex mcp-server"
Write-Host "       antigravity: https://github.com/Laimusp/antigravity-mcp"
Write-Host "  3. Restart Claude Code."
