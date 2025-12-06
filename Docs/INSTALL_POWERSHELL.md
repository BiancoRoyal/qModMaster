# PowerShell auf macOS installieren

## Methode 1: Homebrew (Empfohlen)

PowerShell kann über Homebrew installiert werden:

```bash
brew install --cask powershell
```

**Hinweis:** Diese Installation benötigt Administratorrechte (sudo). Sie werden nach Ihrem Passwort gefragt.

Nach der Installation können Sie PowerShell starten mit:
```bash
pwsh
```

## Methode 2: Direkter Download

1. Laden Sie PowerShell von der offiziellen Website herunter:
   https://github.com/PowerShell/PowerShell/releases

2. Wählen Sie die macOS-Version:
   - **Apple Silicon (M1/M2)**: `powershell-7.x.x-osx-arm64.pkg`
   - **Intel**: `powershell-7.x.x-osx-x64.pkg`

3. Installieren Sie das .pkg Paket durch Doppelklick

4. Starten Sie PowerShell:
   ```bash
   pwsh
   ```

## Methode 3: .NET SDK verwenden

Wenn Sie .NET SDK installiert haben:

```bash
dotnet tool install --global PowerShell
```

## Verifizierung

Nach der Installation können Sie prüfen, ob PowerShell installiert ist:

```bash
pwsh --version
```

## PowerShell starten

```bash
pwsh
```

## PowerShell-Skripte ausführen

Um PowerShell-Skripte auszuführen (z.B. `start.ps1`):

```bash
pwsh start.ps1
```

Oder machen Sie die Datei ausführbar:
```bash
chmod +x start.ps1
./start.ps1
```

## Weitere Informationen

- **Offizielle Dokumentation**: https://learn.microsoft.com/powershell/
- **GitHub Repository**: https://github.com/PowerShell/PowerShell

