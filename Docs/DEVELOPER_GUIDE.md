# qModMaster - Entwicklerhandbuch

## Inhaltsverzeichnis

1. [Projekt-Übersicht](#projekt-übersicht)
2. [Projektstruktur](#projektstruktur)
3. [Build-System](#build-system)
4. [Abhängigkeiten](#abhängigkeiten)
5. [Kompilierung](#kompilierung)
6. [Code-Architektur](#code-architektur)
7. [Entwicklungsumgebung](#entwicklungsumgebung)
8. [Beitragen](#beitragen)
9. [Debugging](#debugging)
10. [Plattform-spezifische Hinweise](#plattform-spezifische-hinweise)

---

## Projekt-Übersicht

**qModMaster** ist eine Qt-basierte Modbus Master-Anwendung, die libmodbus für die Kommunikation verwendet.

### Technologie-Stack

- **Framework**: Qt 5.2.1+ (Widgets, Core, GUI, Network)
- **Modbus-Bibliothek**: libmodbus 3.1.0-1
- **Logging**: QsLog
- **Build-System**: qmake
- **Sprache**: C++11
- **Versionskontrolle**: Git mit Git Flow

### Unterstützte Plattformen

- ✅ Windows (MSVC, MinGW)
- ✅ macOS (clang)
- ✅ Linux (gcc, clang)

---

## Projektstruktur

```
qModMaster-code-0.5.2-3/
├── src/                    # Alle Quellcode-Dateien
│   ├── forms/             # UI Form-Dateien (.cpp, .h, .ui)
│   │   ├── about.*
│   │   ├── busmonitor.*
│   │   ├── settings.*
│   │   ├── settingsmodbusrtu.*
│   │   ├── settingsmodbustcp.*
│   │   └── tools.*
│   ├── main.cpp           # Programm-Einstiegspunkt
│   ├── mainwindow.*       # Hauptfenster
│   ├── modbusadapter.*    # Modbus-Kommunikations-Layer
│   ├── modbuscommsettings.* # Einstellungsverwaltung
│   ├── registersmodel.*   # Datenmodell für Register
│   ├── rawdatamodel.*     # Datenmodell für Raw-Daten
│   ├── eutils.*           # Utility-Funktionen
│   └── infobar.*          # Info-Bar Widget
├── 3rdparty/              # Externe Bibliotheken
│   ├── libmodbus/         # Modbus-Bibliothek
│   └── QsLog/             # Logging-Bibliothek
├── build/                 # Build-Artefakte (generiert)
│   ├── moc/              # Meta Object Compiler Dateien
│   ├── rcc/              # Resource Compiler Dateien
│   ├── ui/               # UI generierte Header
│   └── obj/              # Object Dateien
├── icons/                 # Icons und Ressourcen
├── translations/          # Übersetzungsdateien
├── docs/                  # Dokumentation
│   ├── USER_GUIDE.md
│   └── DEVELOPER_GUIDE.md
├── qModMaster.pro         # qmake Projektdatei
├── start.sh               # Start-Skript (macOS/Linux)
├── start.bat              # Start-Skript (Windows CMD)
└── start.ps1              # Start-Skript (Windows PowerShell)
```

---

## Build-System

### qmake Projektdatei

Die Hauptprojektdatei ist `qModMaster.pro`. Sie definiert:

- **SOURCES**: Alle .cpp Dateien
- **HEADERS**: Alle .h Dateien
- **FORMS**: Alle .ui Dateien
- **RESOURCES**: .qrc Dateien für Icons und Übersetzungen
- **Build-Verzeichnisse**: MOC_DIR, RCC_DIR, UI_DIR, OBJECTS_DIR

### Build-Verzeichnis-Struktur

Alle generierten Dateien werden im `build/` Verzeichnis organisiert:

- `build/moc/` - Meta Object Compiler Dateien
- `build/rcc/` - Resource Compiler Dateien
- `build/ui/` - UI generierte Header
- `build/obj/` - Object Dateien (organisiert nach Quellverzeichnis)

---

## Abhängigkeiten

### Qt

- **Mindestversion**: Qt 5.2.1
- **Module**: core, gui, network, widgets
- **Download**: https://www.qt.io/download/

### libmodbus

- **Version**: 3.1.0-1
- **Quelle**: http://www.libmodbus.org/
- **Lizenz**: LGPL-2.1+
- **Enthalten**: Im `3rdparty/libmodbus/` Verzeichnis

### QsLog

- **Quelle**: https://bitbucket.org/razvanpetru/qt-components/wiki/QsLog
- **Enthalten**: Im `3rdparty/QsLog/` Verzeichnis

### System-Abhängigkeiten

**macOS:**
- Xcode Command Line Tools
- Homebrew Qt (optional): `brew install qt@5`

**Linux:**
- Qt5 Entwicklungspakete: `sudo apt-get install qt5-default qt5-qmake`
- Build-Essentials: `sudo apt-get install build-essential`

**Windows:**
- Qt für Windows (MSVC oder MinGW)
- Visual Studio (für MSVC) oder MinGW

---

## Kompilierung

### macOS

```bash
# Qt-Pfade setzen
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/qt@5/lib"
export CPPFLAGS="-I/opt/homebrew/opt/qt@5/include"

# Projekt kompilieren
qmake qModMaster.pro
make

# Oder verwenden Sie das Start-Skript
./start.sh
```

### Linux

```bash
# Projekt kompilieren
qmake qModMaster.pro
make

# Oder verwenden Sie das Start-Skript
./start.sh
```

### Windows

**MSVC:**
```cmd
qmake qModMaster.pro
nmake
```

**MinGW:**
```cmd
qmake qModMaster.pro
mingw32-make
```

**PowerShell:**
```powershell
.\start.ps1
```

### Clean Build

```bash
make clean
qmake qModMaster.pro
make
```

---

## Code-Architektur

### Hauptkomponenten

#### 1. MainWindow (`src/mainwindow.*`)

Das Hauptfenster der Anwendung:
- Verwaltet die UI-Komponenten
- Koordiniert die Interaktion zwischen UI und Modbus-Adapter
- Verwaltet Status-Anzeigen und Info-Bars

**Wichtige Methoden:**
- `modbusConnect()` - Verbindung herstellen/trennen
- `refreshView()` - UI aktualisieren
- `modbusRequest()` - Einzelne Modbus-Anfrage senden

#### 2. ModbusAdapter (`src/modbusadapter.*`)

Kernkomponente für Modbus-Kommunikation:
- Kapselt libmodbus-Funktionalität
- Verwaltet RTU und TCP Verbindungen
- Führt Modbus-Transaktionen aus
- Emittiert Signale für UI-Updates

**Wichtige Methoden:**
- `modbusConnectRTU()` - RTU-Verbindung herstellen
- `modbusConnectTCP()` - TCP-Verbindung herstellen
- `modbusReadData()` - Register lesen
- `modbusWriteData()` - Register schreiben

#### 3. ModbusCommSettings (`src/modbuscommsettings.*`)

Einstellungsverwaltung:
- Speichert/Lädt Einstellungen aus INI-Datei
- Verwaltet Serial-Port-Konfiguration
- Plattform-spezifische Port-Namen-Handhabung

**Wichtige Methoden:**
- `loadSettings()` - Einstellungen laden
- `saveSettings()` - Einstellungen speichern
- `setSerialPort()` - Serial-Port konfigurieren

#### 4. Datenmodelle

**RegistersModel** (`src/registersmodel.*`):
- Verwaltet Register-Daten
- Bietet QAbstractTableModel Interface
- Unterstützt verschiedene Zahlensysteme

**RawDataModel** (`src/rawdatamodel.*`):
- Verwaltet Raw-Daten für Bus Monitor
- Zeigt Request/Response Pakete an

### Signal-Slot Architektur

Qt Signal-Slot System wird verwendet für:
- Kommunikation zwischen ModbusAdapter und MainWindow
- UI-Updates bei Datenänderungen
- Timer-basierte zyklische Scans

**Wichtige Verbindungen:**
```cpp
connect(&modbus_adapt, SIGNAL(refreshView()), mainWin, SLOT(refreshView()));
connect(mainWin, SIGNAL(resetCounters()), &modbus_adapt, SLOT(resetCounters()));
```

---

## Entwicklungsumgebung

### Qt Creator

**Empfohlen für alle Plattformen:**

1. Qt Creator öffnen
2. `File` → `Open File or Project`
3. `qModMaster.pro` auswählen
4. Build-Konfiguration wählen
5. `Build` → `Build All`

### Visual Studio Code

**Mit Qt-Erweiterungen:**

1. C++ Extension installieren
2. Qt-Erweiterung installieren
3. Projekt öffnen
4. Build-Tasks konfigurieren

### Build-Konfiguration

**Debug-Build:**
```bash
qmake CONFIG+=debug qModMaster.pro
make
```

**Release-Build:**
```bash
qmake CONFIG+=release qModMaster.pro
make
```

---

## Beitragen

### Git Flow Workflow

Das Projekt verwendet Git Flow:

```bash
# Neues Feature erstellen
git flow feature start feature-name

# Feature entwickeln und committen
git commit -m "Feature: Beschreibung"

# Feature abschließen
git flow feature finish feature-name
```

### Code-Stil

- **Einrückung**: 4 Leerzeichen
- **Klassennamen**: PascalCase (z.B. `ModbusAdapter`)
- **Methodennamen**: camelCase (z.B. `modbusConnect()`)
- **Dateinamen**: lowercase mit Unterstrichen (z.B. `modbus_adapter.cpp`)

### Commit-Nachrichten

Format:
```
Kategorie: Kurze Beschreibung

Detaillierte Beschreibung der Änderungen
- Punkt 1
- Punkt 2
```

**Kategorien:**
- `Feature`: Neue Funktionalität
- `Fix`: Bug-Fix
- `Refactor`: Code-Refaktorierung
- `Docs`: Dokumentation
- `Build`: Build-System Änderungen

---

## Debugging

### Logging

QsLog wird für Logging verwendet:

```cpp
#include "QsLog.h"

QLOG_TRACE() << "Trace message";
QLOG_DEBUG() << "Debug message";
QLOG_INFO() << "Info message";
QLOG_WARN() << "Warning message";
QLOG_ERROR() << "Error message";
```

**Logging-Level setzen:**
```cpp
QsLogging::Logger& logger = QsLogging::Logger::instance();
logger.setLoggingLevel(QsLogging::DebugLevel);
```

### Debug-Ausgabe aktivieren

In `qModMaster.pro`:
```qmake
DEFINES += LIB_MODBUS_DEBUG_OUTPUT
```

### Debugger verwenden

**Qt Creator:**
- Breakpoints setzen
- `Debug` → `Start Debugging`

**GDB (Linux/macOS):**
```bash
gdb ./qModMaster
```

**Visual Studio (Windows):**
- F5 zum Debuggen

---

## Plattform-spezifische Hinweise

### macOS

**Serial Port Namen:**
- macOS verwendet `/dev/tty.usbserial-*` oder `/dev/cu.usbserial-*`
- Port-Namen sind nicht vorhersagbar
- Siehe `src/modbuscommsettings.cpp` für Implementierung

**Code-Anpassungen:**
```cpp
#ifdef Q_OS_MACOS || defined(Q_OS_MAC)
    // macOS-spezifischer Code
#endif
```

**libmodbus Anpassungen:**
- `strlcpy` Konflikt behoben in `modbus-private.h`
- Bus Monitor Funktionen deklariert in `modbus.c`

### Linux

**Serial Port Berechtigungen:**
```bash
sudo usermod -a -G dialout $USER
```

**System Qt:**
- Qt5 wird über Paketmanager installiert
- Pfade: `/usr/lib/qt5` oder `/usr/lib/x86_64-linux-gnu/qt5`

### Windows

**COM-Port Namen:**
- Format: `COM1`, `COM2`, etc.
- Für COM10+: `\\.\COM10`

**Compiler-Optionen:**
- MSVC: `/MD` für Runtime-Library
- MinGW: Standard GCC-Optionen

**Windows-spezifische Bibliotheken:**
```qmake
win32:LIBS += -lsetupapi -lwsock32 -lws2_32
```

---

## Testing

### Manuelle Tests

1. **RTU-Verbindung testen:**
   - Verschiedene Baudraten testen
   - Verschiedene Slave IDs testen
   - Verschiedene Funktionscodes testen

2. **TCP-Verbindung testen:**
   - Verschiedene IP-Adressen testen
   - Timeout-Verhalten testen

3. **Bus Monitor testen:**
   - Request/Response Pakete prüfen
   - Hex-Darstellung prüfen

### Unit Tests

Aktuell keine automatisierten Tests vorhanden. Empfohlen:
- Qt Test Framework verwenden
- ModbusAdapter isoliert testen
- Mock-Objekte für libmodbus verwenden

---

## Bekannte Probleme und Einschränkungen

### macOS

- Serial Port-Namen müssen manuell eingegeben werden
- Automatische Port-Erkennung nicht implementiert
- Berechtigungen für Serial Ports können Probleme verursachen

### Linux

- System-Qt Versionen können variieren
- Serial Port Berechtigungen müssen konfiguriert werden

### Windows

- COM-Port-Namen über COM9 benötigen spezielle Syntax
- Windows Defender kann Ausführung blockieren

---

## Weiterführende Informationen

- **Modbus Protokoll**: Siehe `Docs/Modbus_Application_Protocol_V1_1b3.pdf`
- **Modbus Referenz**: Siehe `ManModbus/` Verzeichnis
- **libmodbus Dokumentation**: http://www.libmodbus.org/documentation/
- **Qt Dokumentation**: https://doc.qt.io/

---

## Lizenz

Dieses Programm ist freie Software unter der GNU General Public License v3.

Siehe `LICENSE` Datei für Details.

