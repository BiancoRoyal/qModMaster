# PowerShell Test-Anleitung

## Übersicht

Das Projekt enthält ein PowerShell-Test-Skript (`test_powershell.ps1`), das die PowerShell-Funktionalität und die Kompatibilität mit dem qModMaster Start-Skript testet.

## Voraussetzungen

1. PowerShell muss installiert sein (siehe `INSTALL_POWERSHELL.md`)
2. PowerShell muss im PATH verfügbar sein

## Test-Skript ausführen

### macOS/Linux

```bash
pwsh test_powershell.ps1
```

### Windows

```powershell
.\test_powershell.ps1
```

## Durchgeführte Tests

Das Test-Skript führt folgende Tests durch:

### 1. PowerShell Version
- Prüft die installierte PowerShell-Version
- Zeigt .NET Version an

### 2. Plattform-Erkennung
- Erkennt automatisch Windows, macOS oder Linux
- Zeigt die erkannte Plattform an

### 3. Script-Verzeichnis-Erkennung
- Prüft, ob das Skript-Verzeichnis korrekt erkannt wird
- Zeigt aktuelles Arbeitsverzeichnis

### 4. Dateisystem-Operationen
- Prüft das Vorhandensein wichtiger Projektdateien:
  - `qModMaster.pro`
  - `start.ps1`
  - `start.sh`
  - `start.bat`

### 5. Qt-Pfad-Erkennung
- Sucht nach Qt-Installationen in Standard-Verzeichnissen
- Prüft verschiedene Plattform-spezifische Pfade
- Versucht qmake zu finden

### 6. Umgebungsvariablen
- Prüft PATH-Variable
- Prüft QT_PLUGIN_PATH (falls gesetzt)

### 7. qModMaster Executable-Erkennung
- Sucht nach der kompilierten Anwendung
- Zeigt Dateigröße und Änderungsdatum
- Unterstützt verschiedene Build-Konfigurationen

### 8. PowerShell Script Syntax-Check
- Validiert die Syntax von `start.ps1`
- Prüft auf Syntax-Fehler

### 9. Cross-Platform Kompatibilität
- Prüft, ob PowerShell Core verwendet wird
- Bestätigt Multi-Platform-Unterstützung

### 10. Execution Policy (nur Windows)
- Prüft die PowerShell Execution Policy
- Warnt bei restriktiven Einstellungen

## Erwartete Ausgabe

Das Skript gibt farbige Ausgaben aus:
- **Grün**: Erfolgreiche Tests
- **Gelb**: Warnungen oder nicht kritische Probleme
- **Rot**: Fehler oder fehlende Komponenten
- **Cyan**: Überschriften und Zusammenfassungen

## Beispiel-Ausgabe

```
========================================
PowerShell Test Script for qModMaster
========================================

Test 1: PowerShell Version
  PowerShell Version: 7.5.4
  .NET Version: 8.0.0

Test 2: Platform Detection
  Platform: macOS

Test 3: Script Directory Detection
  Script Directory: /path/to/qModMaster
  Current Directory: /path/to/qModMaster

...
```

## Fehlerbehebung

### "pwsh: command not found"
- PowerShell ist nicht installiert oder nicht im PATH
- Siehe `INSTALL_POWERSHELL.md` für Installationsanweisungen

### "Execution Policy Error" (Windows)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Qt not found"
- Qt ist nicht installiert oder nicht in Standard-Verzeichnissen
- Setzen Sie die Umgebungsvariablen manuell vor dem Test

### "Executable not found"
- Projekt wurde noch nicht kompiliert
- Führen Sie `qmake && make` aus, bevor Sie die Tests ausführen

## Verwendung in CI/CD

Das Test-Skript kann auch in CI/CD-Pipelines verwendet werden:

```yaml
# Beispiel GitHub Actions
- name: Test PowerShell
  run: pwsh test_powershell.ps1
```

## Weitere Informationen

- **PowerShell Dokumentation**: https://learn.microsoft.com/powershell/
- **qModMaster Start-Skripte**: Siehe `README_START.md`

