# qModMaster Start-Skripte

Dieses Projekt enthält plattformübergreifende Start-Skripte für Windows, macOS und Linux.

## Verfügbare Skripte

### macOS und Linux
- **`start.sh`** - Bash-Skript für macOS und Linux

### Windows
- **`start.bat`** - Batch-Skript für Windows Command Prompt
- **`start.ps1`** - PowerShell-Skript für Windows (empfohlen)

## Verwendung

### macOS
```bash
./start.sh
```

### Linux
```bash
./start.sh
```

### Windows (Command Prompt)
```cmd
start.bat
```

### Windows (PowerShell)
```powershell
.\start.ps1
```

## Funktionalität

Die Skripte führen folgende Aufgaben aus:

1. **Plattform-Erkennung**: Automatische Erkennung des Betriebssystems
2. **Qt-Pfad-Suche**: Automatische Suche nach Qt-Installationen in Standard-Verzeichnissen
3. **Umgebungsvariablen**: Setzen der notwendigen Umgebungsvariablen (PATH, Library-Pfade, Plugin-Pfade)
4. **Anwendung starten**: Starten der qModMaster-Anwendung

## Unterstützte Qt-Installationen

### macOS
- Homebrew Qt (`/opt/homebrew/opt/qt@5` oder `/usr/local/opt/qt@5`)
- Qt Creator Installation (`~/Qt/<version>/clang_64`)

### Linux
- System Qt (`/usr/lib/qt5`)
- Debian/Ubuntu Qt (`/usr/lib/x86_64-linux-gnu/qt5`)

### Windows
- Qt in Program Files (`C:\Qt\<version>\<compiler>`)
- Qt im Benutzerverzeichnis (`%USERPROFILE%\Qt\<version>\<compiler>`)
- Unterstützte Compiler:
  - MSVC 2019 (64-bit)
  - MSVC 2022 (64-bit)
  - MinGW (64-bit und 32-bit)

## Fehlerbehebung

### "qModMaster executable not found"
- Stellen Sie sicher, dass das Projekt kompiliert wurde:
  ```bash
  qmake qModMaster.pro
  make
  ```

### "Qt not found"
- Installieren Sie Qt für Ihre Plattform
- Oder setzen Sie die Umgebungsvariablen manuell vor dem Start

### macOS: "Permission denied"
- Stellen Sie sicher, dass das Skript ausführbar ist:
  ```bash
  chmod +x start.sh
  ```

### Windows: PowerShell Execution Policy
- Falls PowerShell-Skripte nicht ausgeführt werden können:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

## Manuelle Umgebungsvariablen

Falls die automatische Erkennung nicht funktioniert, können Sie die Umgebungsvariablen manuell setzen:

### macOS/Linux
```bash
export PATH="/path/to/qt/bin:$PATH"
export DYLD_LIBRARY_PATH="/path/to/qt/lib:$DYLD_LIBRARY_PATH"  # macOS
export LD_LIBRARY_PATH="/path/to/qt/lib:$LD_LIBRARY_PATH"      # Linux
export QT_PLUGIN_PATH="/path/to/qt/plugins"
./qModMaster.app/Contents/MacOS/qModMaster  # macOS
# oder
./qModMaster  # Linux
```

### Windows
```cmd
set PATH=C:\Qt\5.15.2\msvc2019_64\bin;%PATH%
set QT_PLUGIN_PATH=C:\Qt\5.15.2\msvc2019_64\plugins
qModMaster.exe
```

