# Compliance Auto-Fix - Quick Start

## TL;DR - Automatische Behebung in 2 Befehlen

```bash
cd ~/your-project
claude

> /compliance fix
```

Das wars! Claude wird:
1. Probleme finden
2. Fragen ob Sie wollen, dass es sie behebt
3. Alles automatisch reparieren
4. Backups erstellen
5. Ihnen sagen, dass Sie Claude neu starten sollen

## Was wird automatisch gefixt?

### 1. Bash Validation Hook ⭐ (WICHTIGSTE FIX)
**Problem:** settings.local.json fehlt der `hooks` Abschnitt
**Effekt:** node_modules/ wird gelesen → 18M Tokens verschwendet
**Fix:** Fügt Hook-Konfiguration hinzu

**Vorher:**
```json
{
  "permissions": { ... }
}
```

**Nachher:**
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{"command": "bash .claude/scripts/validate-bash.sh"}]
    }]
  },
  "permissions": { ... }
}
```

### 2. Read() Deny Patterns
**Problem:** Keine Read() Blockierungen konfiguriert
**Effekt:** Claude kann alle Dateien lesen
**Fix:** Fügt 15+ deny patterns hinzu

```json
"deny": [
  "Read(**/node_modules/**)",
  "Read(**/*.lock)",
  "Read(**/*.sqlite)",
  // ... und mehr
]
```

### 3. Lock-Files in .claude/ignore
**Problem:** package-lock.json, yarn.lock nicht blockiert
**Effekt:** ~35k Tokens verschwendet
**Fix:** Fügt zu .claude/ignore hinzu

### 4. Database-Files
**Problem:** *.sqlite, *.db nicht blockiert
**Effekt:** Datenbank-Dateien werden gelesen
**Fix:** Fügt Patterns zu .claude/ignore hinzu

### 5. .gitignore
**Problem:** .claude/logs/ nicht ignoriert
**Effekt:** Logs könnten committed werden
**Fix:** Fügt .claude/logs/ zu .gitignore hinzu

### 6. Script Permissions
**Problem:** Scripts nicht ausführbar
**Effekt:** Hooks funktionieren nicht
**Fix:** chmod +x auf alle .sh Dateien

### 7. Fehlende Dateien
**Problem:** Commands oder Scripts fehlen
**Effekt:** Slash-Commands funktionieren nicht
**Fix:** Kopiert aus Template

## Nutzung

### Variante 1: Mit Auto-Fix

```bash
claude
> /compliance fix

# oder
> /compliance --fix
```

Claude fragt:
```
I found 5 fixable issues. Apply automatic fixes?

1. Yes, fix all issues (recommended)
2. Show me what will be fixed first
3. No, I'll fix manually
```

Wählen Sie Option 1 → Fertig!

### Variante 2: Erst Check, dann Fix

```bash
> /compliance

# Liest Report...
# Entscheidet sich für Auto-Fix

> /compliance fix
```

### Variante 3: Manuelles Script

```bash
# Außerhalb von Claude
cd ~/your-project
bash .claude/scripts/compliance-fix.sh

# Mit custom Template-Pfad
bash .claude/scripts/compliance-fix.sh /path/to/template
```

## Sicherheit

### Backups

**ALLE** Änderungen werden gesichert:
```
.claude/backups/20241029_073000/
├── settings.local.json.backup
├── gitignore.backup
└── ...
```

**Zum Wiederherstellen:**
```bash
# Falls was schiefgeht
cp .claude/backups/20241029_073000/settings.local.json.backup .claude/settings.local.json
```

### Keine Datenverluste

- Nur bekannte Config-Dateien werden geändert
- Kein Code wird modifiziert
- Keine Datenbanken werden angefasst
- Keine Commits werden erstellt (Sie entscheiden)

## Nach dem Fix

### 1. Claude NEU STARTEN (wichtig!)

```bash
# Beenden (Strg+C)
^C

# Neu starten
claude
```

**Warum?** Hooks werden nur beim Start geladen!

### 2. Testen

```bash
> /compliance

# Sollte jetzt zeigen:
# Score: 95/100 🟢
```

Oder manuell:
```bash
# Sollte blockiert werden:
grep -r "test" .
# Output: ERROR: Command contains blocked pattern

# Sollte funktionieren:
grep "test" src/
# Output: [normale grep Ausgabe]
```

### 3. Committen

```bash
git add .claude/ .gitignore
git commit -m "chore: configure Claude Code token optimization

- Add Bash validation hook
- Add Read() deny patterns
- Block lock files and databases
- Token savings: ~99.7% per session"
```

## Erwartete Verbesserungen

### Token Usage
```
Vorher:  18.800.000 tokens/session
Nachher:     50.000 tokens/session
Einsparung:  99.7%
```

### Sessions
```
Vorher:  1-2 sessions before limit
Nachher: 40+ sessions before limit
```

### Compliance Score
```
Vorher:  45/100 🔴
Nachher: 95/100 🟢
```

## Häufige Fragen

### Q: Ist das sicher?
**A:** Ja!
- Backups werden erstellt
- Nur Config-Dateien geändert
- Kein Code modifiziert
- Reversibel

### Q: Was wenn etwas kaputt geht?
**A:**
```bash
# Restore aus Backup
cd .claude/backups/
ls -la  # Finde neuesten Backup
cp 20241029_073000/settings.local.json.backup ../.claude/settings.local.json
```

### Q: Muss ich Claude neu starten?
**A:** Ja! Hooks werden nur beim Start geladen.

### Q: Funktioniert das mit meinen eigenen Anpassungen?
**A:** Ja! Das Script:
- Behält Ihre `allow` patterns
- Ergänzt nur `deny` patterns
- Überschreibt nichts Wichtiges

### Q: Kann ich einzelne Fixes rückgängig machen?
**A:** Ja! Editieren Sie die Dateien manuell und entfernen Sie, was Sie nicht wollen.

### Q: Was wenn Template nicht gefunden wird?
**A:**
```bash
# Pfad angeben
bash .claude/scripts/compliance-fix.sh /path/to/template

# Oder Template neu installieren
/init ~/path/to/template
```

## Troubleshooting

### "Template not found"
```bash
# Prüfen wo Template ist
ls -la ~/claude-code-template/

# Falls nicht da, Template kopieren oder /init nutzen
```

### "Permission denied"
```bash
# Scripts ausführbar machen
chmod +x .claude/scripts/*.sh
```

### "Fixes applied but nothing changed"
```bash
# Claude neu starten!
# Hooks werden nur beim Start geladen
```

### "Backup directory full"
```bash
# Alte Backups löschen (> 30 Tage)
find .claude/backups/ -mtime +30 -exec rm -rf {} \;
```

## Support

- Vollständige Dokumentation: `.claude/commands/compliance.md`
- Token-Analyzer: `.claude/scripts/check-token-usage.sh`
- Compliance-Check: `.claude/scripts/compliance-check.sh`
- Auto-Fix: `.claude/scripts/compliance-fix.sh`

---

**Pro-Tipp:** Führen Sie `/compliance` monatlich aus, um sicherzustellen, dass die Konfiguration optimal bleibt!
