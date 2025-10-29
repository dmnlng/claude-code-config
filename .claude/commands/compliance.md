# Compliance Check Command

Überprüft die Claude Code Konfiguration auf Vollständigkeit, Aktualität und optimale Performance.

## Task

Führe einen umfassenden Compliance-Check der Claude Code Konfiguration durch und identifiziere Optimierungspotenzial.

**Usage:**
- `/compliance` - Run check and show report
- `/compliance --fix` or `/compliance fix` - Run check AND automatically fix issues

## Auto-Fix Capability

When run with `--fix` or `fix` argument, this command will:
1. Run the full compliance check
2. Identify fixable issues
3. **Ask user for confirmation before making changes**
4. Automatically fix common problems:
   - Configure missing Bash validation hook
   - Add Read() deny patterns to settings.local.json
   - Add lock files to .claude/ignore
   - Add database files to .claude/ignore
   - Add .claude/logs/ to .gitignore
   - Make scripts executable
   - Restore missing files from template
   - Add project-specific patterns
5. Create backups of modified files
6. Show summary of applied fixes

The auto-fix script is safe:
- Creates backups before any changes
- Can be reverted if needed
- Only fixes well-known patterns
- Preserves user customizations where possible

## Wann nutzen?

- **Bestandsprojekte**: Vor dem ersten `/init` - zeigt, was fehlt oder veraltet ist
- **Nach Updates**: Wenn Template-Updates verfügbar sind
- **Regelmäßig**: Monatliche Maintenance (ähnlich `npm audit`)
- **Performance-Probleme**: Wenn Claude langsam oder token-hungrig ist
- **Team-Onboarding**: Neue Teammitglieder sehen Konfigurationsstatus

## Check-Kategorien

### 1. Core Configuration (Kritisch)

**Prüfe Existenz und Validität:**

- [ ] `.claude/settings.local.json` existiert und ist valides JSON
- [ ] `.claude/scripts/validate-bash.sh` existiert und ist ausführbar
- [ ] `.claude/ignore` existiert und enthält Patterns
- [ ] `CLAUDE.md` existiert im Projekt-Root

**Für jede fehlende Datei:**
- Zeige welche Datei fehlt
- Erkläre Auswirkung (z.B. "Bash-Validierung inaktiv → Token-Verschwendung")
- Biete Reparatur an: "Run `/init` to fix" oder manuelle Anleitung

### 2. Hook Configuration

**Prüfe `.claude/settings.local.json`:**

```bash
# Lese und parse die Datei
cat .claude/settings.local.json
```

Validiere:
- [ ] `hooks.PreToolUse` für Bash ist konfiguriert
- [ ] Hook zeigt auf korrektes Script-Path
- [ ] `permissions.deny` enthält mindestens 10 Patterns
- [ ] Standard-Patterns sind enthalten (node_modules, .git/objects, dist, build)

**Warnungen:**
- Wenn Hook fehlt: "⚠️ Bash validation hook not configured - tokens wasted on dependencies"
- Wenn Permissions leer: "⚠️ No Read() deny patterns - all files accessible"
- Wenn veraltete Patterns: "💡 Add missing patterns: .next/, .turbo/, .ruff_cache/"

### 3. Token Optimization

**Führe Token-Analyse aus:**

```bash
./.claude/scripts/check-token-usage.sh
```

Interpretiere Ergebnisse:
- 🟢 **Optimal**: < 20% exposed directories
- 🟡 **Verbesserbar**: 20-50% exposed
- 🔴 **Kritisch**: > 50% exposed (große Token-Verschwendung)

**Empfehlungen basierend auf Findings:**
- Wenn große exposed directories: Liste konkrete Patterns zum Hinzufügen
- Wenn Lock-Files exposed: Empfehle diese zu blocken
- Wenn Generated-Code exposed: Empfehle Pattern für generierte Dateien

### 4. CLAUDE.md Quality

**Prüfe CLAUDE.md:**

```bash
wc -l CLAUDE.md  # Zeilenzahl
wc -w CLAUDE.md  # Wortzahl
```

Bewerte:
- [ ] Existiert im Projekt-Root
- [ ] Ist nicht das unmodifizierte Template (check für Platzhalter wie "[tech stack]")
- [ ] Ist nicht zu lang (> 500 Zeilen = Warnung)
- [ ] Enthält projekt-spezifische Informationen

**Plausibilitäts-Checks:**
- Wenn package.json existiert aber CLAUDE.md keine JS/npm Commands erwähnt
- Wenn Tests existieren (tests/ Verzeichnis) aber kein Test-Command definiert
- Wenn Linter-Config existiert (.eslintrc, .pylintrc) aber nicht in CLAUDE.md

**Empfehlungen:**
- "💡 CLAUDE.md mentions Python but project uses JavaScript - update it"
- "💡 Test directory exists but no test command in CLAUDE.md"
- "⚠️ CLAUDE.md is 743 lines - consider condensing (loaded every session)"

### 5. Slash Commands

**Prüfe `.claude/commands/`:**

```bash
ls -la .claude/commands/
```

Erwartete Commands:
- [ ] init.md
- [ ] test.md
- [ ] review.md
- [ ] explore.md
- [ ] optimize-tokens.md
- [ ] compliance.md (dieser hier)

**Status:**
- Anzahl vorhandener Commands
- Fehlende Standard-Commands
- Custom Commands (vom Team hinzugefügt)

### 6. Workflow Documentation

**Prüfe `.claude/workflows/`:**

```bash
ls -la .claude/workflows/
```

Erwartete Workflows:
- [ ] tdd-workflow.md
- [ ] visual-iteration.md
- [ ] multi-claude.md

**Empfehlungen:**
- Wenn keine Workflows: "Consider adding workflow docs for team"
- Wenn Custom Workflows: "✓ Team has added custom workflows"

### 7. Project-Specific Patterns

**Analysiere Projektstruktur vs. .claude/ignore:**

Erkenne:
- Build-Verzeichnisse: .next/, .nuxt/, .output/, dist/, build/, out/
- Dependencies: node_modules/, vendor/, target/, packages/
- Caches: .cache/, .turbo/, __pycache__/, .pytest_cache/
- Generated: *.generated.*, *_pb2.py, *.pb.go

**Für jedes gefundene Verzeichnis:**
- Check ob in .claude/ignore
- Wenn nicht: "⚠️ Found .next/ directory but not in .claude/ignore"
- Schätze Token-Verschwendung

### 8. Script Functionality

**Teste Scripts:**

```bash
# Test 1: validate-bash.sh funktioniert
echo '{"tool_input":{"command":"grep -r test ."}}' | ./.claude/scripts/validate-bash.sh
# Sollte Error ausgeben

# Test 2: check-token-usage.sh funktioniert
./.claude/scripts/check-token-usage.sh > /dev/null
echo $?  # Sollte 0 sein

# Test 3: Scripts sind ausführbar
test -x .claude/scripts/validate-bash.sh && echo "✓" || echo "✗"
test -x .claude/scripts/check-token-usage.sh && echo "✓" || echo "✗"
```

### 9. Git Integration

**Prüfe Git-Status:**

```bash
git status .claude/ CLAUDE.md 2>/dev/null
```

Bewerte:
- [ ] .claude/ ist committed (gut für Team)
- [ ] CLAUDE.md ist committed
- [ ] .claude/logs/ ist in .gitignore

**Warnungen:**
- Wenn nicht committed: "💡 Configuration not in git - team can't benefit"
- Wenn logs committed: "⚠️ .claude/logs/ should be in .gitignore"

### 10. Version Check

**Prüfe Template-Version:**

Wenn Template eine VERSION-Datei hat:
```bash
cat ~/claude-code-template/VERSION 2>/dev/null
cat .claude/VERSION 2>/dev/null
```

Vergleiche:
- Wenn lokale Version älter: "💡 Template update available (v2.1.0 → v2.3.0)"
- Wenn gleich: "✓ Configuration is up-to-date"

## Output Format

Erstelle übersichtlichen Report:

```markdown
# Claude Code Compliance Report
Generated: 2024-01-15 14:30:00

## Overall Status: 🟡 NEEDS IMPROVEMENT (Score: 65/100)

---

## Critical Issues (Must Fix) 🔴

1. **Bash Validation Hook Missing**
   - Impact: ~60,000 tokens wasted per session on node_modules/
   - Fix: Add hook to .claude/settings.local.json
   - Command: Run `/init` or manually edit settings

2. **.next/ Directory Not Blocked**
   - Impact: ~8,000 tokens wasted on build artifacts
   - Fix: Add ".next/" to .claude/ignore
   - Command: echo ".next/" >> .claude/ignore

---

## Warnings (Should Fix) 🟡

3. **CLAUDE.md Contains Template Placeholders**
   - Issue: Still shows "[tech stack]" instead of actual tech
   - Impact: Claude lacks project context
   - Fix: Edit CLAUDE.md and fill in project details

4. **Lock Files Exposed**
   - Found: package-lock.json (2.3 MB, ~10,000 tokens)
   - Fix: Add to .claude/ignore
   - Command: echo "package-lock.json" >> .claude/ignore

---

## Recommendations (Nice to Have) 💡

5. **Configuration Not in Git**
   - Team can't benefit from optimization
   - Fix: git add .claude/ CLAUDE.md && git commit

6. **Missing Custom Commands**
   - Consider adding project-specific commands
   - Example: /deploy, /migrate, /seed-db

---

## Compliant Areas ✅

✓ Scripts are executable
✓ Token analyzer functional
✓ .claude/ignore has 45 patterns
✓ Core directory structure correct
✓ Workflow documentation present

---

## Token Impact Summary

Current State:
- Estimated tokens per session: 78,000
- Tokens wasted on blocked content: 63,000 (81%)
- Tokens for actual code: 15,000 (19%)

After Fixes:
- Estimated tokens per session: 18,000
- Token savings: 60,000 (77% reduction)
- Sessions before limit: 3 → 14 (+367%)

---

## Quick Fix Commands

Run these commands to fix critical issues:

```bash
# Fix 1: Add .next/ to ignore
echo ".next/" >> .claude/ignore

# Fix 2: Add package-lock.json to ignore
echo "package-lock.json" >> .claude/ignore

# Fix 3: Update CLAUDE.md
nano CLAUDE.md  # Replace [tech stack] with actual info

# Fix 4: Commit configuration
git add .claude/ CLAUDE.md
git commit -m "chore: update Claude Code configuration"

# Or: Run full init to fix all issues
claude
> /init
```

---

## Next Steps

1. 🔴 Fix critical issues (estimated time: 5 minutes)
2. 🟡 Address warnings (estimated time: 10 minutes)
3. 💡 Consider recommendations (optional)
4. 📅 Schedule monthly compliance checks
5. 📚 Review workflow docs: .claude/workflows/

Run `/compliance` again after fixes to verify improvements.
```

## Edge Cases

**Wenn .claude/ gar nicht existiert:**
```
# Claude Code Compliance Report

## Overall Status: 🔴 NOT CONFIGURED (Score: 0/100)

❌ No Claude Code configuration found in this project.

This project is missing token optimization and best practices.

### Impact:
- ~85% of tokens wasted on dependencies and build artifacts
- No project-specific context for Claude
- No custom workflows or commands

### Recommendation:
Run `/init` to set up Claude Code configuration.

Estimated setup time: 2 minutes
Estimated token savings: ~82% per session
```

**Wenn alles perfekt:**
```
# Claude Code Compliance Report

## Overall Status: 🟢 EXCELLENT (Score: 98/100)

✅ All critical components configured
✅ Token optimization active and effective
✅ CLAUDE.md well-maintained
✅ Configuration committed to git
✅ All scripts functional

### Token Impact:
- Tokens per session: 12,000
- Token savings: 88,000 (88% vs. unconfigured)
- Sessions before limit: 20+

🎉 This project follows Claude Code best practices!

Minor suggestion:
- Consider adding MCP servers for extended functionality
  (see .claude/settings.local.json for examples)

Next compliance check recommended: in 30 days
```

## Nach Compliance Check

**Biete automatische Reparatur an:**

Wenn der User zustimmt:
1. Fehlende Dateien aus Template kopieren
2. .claude/ignore Patterns hinzufügen
3. CLAUDE.md Platzhalter durch erkannte Werte ersetzen
4. Scripts ausführbar machen
5. Erneuten Check durchführen
6. Git-Commit anbieten

**Oder leite zu /init weiter:**
"Run `/init` to automatically fix all issues"

## Auto-Fix Execution

If user ran `/compliance --fix` or `/compliance fix`, or if user agrees to auto-fix after seeing report:

### Step 1: Confirm with User

Use AskUserQuestion tool:
```
"I found {count} fixable issues. Apply automatic fixes?"

Options:
1. "Yes, fix all issues" (recommended)
   - Description: Automatically fixes all detected issues with backups
2. "Show me what will be fixed first"
   - Description: Display detailed fix plan before applying
3. "No, I'll fix manually"
   - Description: Exit without changes

multiSelect: false
```

### Step 2: Execute Fix Script

If user confirms:

```bash
# Run the auto-fix script
./.claude/scripts/compliance-fix.sh

# Script will:
# 1. Create backups in .claude/backups/TIMESTAMP/
# 2. Fix settings.local.json (add hooks + deny patterns)
# 3. Add lock files to .claude/ignore
# 4. Add database files to .claude/ignore
# 5. Add .claude/logs/ to .gitignore
# 6. Make all scripts executable
# 7. Restore missing files from template
# 8. Add project-specific patterns
# 9. Show summary of fixes applied
```

### Step 3: Verify Fixes

After running fix script:

```bash
# Re-run compliance check to verify
./.claude/scripts/compliance-check.sh
```

Show before/after comparison:
```
Compliance Score Improvement:
Before: 45/100 🔴
After:  95/100 🟢

Token Savings:
Before: 18.8M tokens/session (99% waste)
After:  50k tokens/session (99.7% optimized)

Fixes Applied:
✓ Configured Bash validation hook
✓ Added 15 Read() deny patterns
✓ Added 3 lock files to .claude/ignore
✓ Added .claude/logs/ to .gitignore
✓ Made 4 scripts executable

Backups created in: .claude/backups/20241029_073000/
```

### Step 4: Next Steps

Inform user:
```
🎉 Fixes applied successfully!

Next steps:
1. ⚠️  RESTART Claude for changes to take effect
2. ✓ Test: Run 'grep -r test .' (should be blocked now)
3. ✓ Verify: Run /compliance again to see improved score
4. 📝 Commit changes: git add .claude/ .gitignore && git commit

If you need to revert:
- Backups are in .claude/backups/TIMESTAMP/
- Copy files back to restore previous state
```

## Error Handling for Auto-Fix

If auto-fix script fails:
- Show error message
- Indicate which fix failed
- Point to backup location
- Suggest manual fix or running /init
- Do NOT leave configuration in broken state

If template path is wrong:
```
Error: Template not found at ~/claude-code-template

Please specify template path:
./.claude/scripts/compliance-fix.sh /path/to/template

Or run /init to download/setup template
```

## Safety Features

1. **Always backup before changes**
   - Backups in `.claude/backups/TIMESTAMP/`
   - Each run creates new timestamped backup

2. **Preserve user customizations**
   - If settings.local.json has custom allow patterns, preserve them
   - Merge new deny patterns instead of replacing

3. **Reversible**
   - All backups kept
   - User can restore manually
   - No destructive operations

4. **Transparent**
   - Show exactly what will be changed
   - Ask for confirmation
   - Display summary after completion
