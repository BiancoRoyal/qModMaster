# qModMaster

Eine kostenlose, plattformübergreifende Modbus Master-Anwendung mit grafischer Benutzeroberfläche.

## 📋 Übersicht

qModMaster ermöglicht die einfache Kommunikation mit Modbus RTU und TCP Slaves über eine intuitive grafische Benutzeroberfläche. Die Anwendung unterstützt alle gängigen Modbus-Funktionscodes und bietet einen integrierten Bus Monitor zur Analyse des Bus-Verkehrs.

### Hauptfunktionen

- ✅ **Modbus RTU** Kommunikation über serielle Schnittstellen
- ✅ **Modbus TCP** Kommunikation über Ethernet
- ✅ **Bus Monitor** zur Analyse des gesamten Bus-Verkehrs
- ✅ **Register-Lesen und -Schreiben** mit verschiedenen Funktionen
- ✅ **Echtzeit-Datenanzeige** in verschiedenen Zahlensystemen
- ✅ **Session-Management** zum Speichern und Laden von Konfigurationen
- ✅ **Mehrsprachige Unterstützung** (Englisch, Chinesisch)

### Unterstützte Plattformen

- ✅ **Windows** (7, 8, 10, 11)
- ✅ **macOS** (10.13+)
- ✅ **Linux** (Ubuntu, Debian, Fedora, etc.)

## 🚀 Schnellstart

### Installation

**Windows:**
```cmd
start.bat
```

**macOS/Linux:**
```bash
./start.sh
```

Die Start-Skripte erkennen automatisch Ihre Qt-Installation und starten die Anwendung.

### Erste Schritte

1. Starten Sie qModMaster
2. Wählen Sie `Settings` → `Serial RTU` oder `TCP`
3. Konfigurieren Sie die Verbindungsparameter
4. Klicken Sie auf `Connect`

## 📚 Dokumentation

### Für Benutzer

👉 **[Benutzerhandbuch](docs/USER_GUIDE.md)** - Vollständige Anleitung zur Verwendung von qModMaster

- Installation und Einrichtung
- Modbus RTU Verbindung
- Modbus TCP Verbindung
- Funktionen und Features
- Einstellungen
- Fehlerbehebung

### Für Entwickler

👉 **[Entwicklerhandbuch](docs/DEVELOPER_GUIDE.md)** - Technische Dokumentation für Entwickler

- Projektstruktur
- Build-System
- Code-Architektur
- Entwicklungsumgebung
- Plattform-spezifische Hinweise
- Debugging

### Weitere Dokumentation

- **[Start-Skripte](README_START.md)** - Dokumentation der Start-Skripte
- **[Plattform-Kompatibilität](PLATFORM_COMPATIBILITY_ANALYSIS.md)** - Detaillierte Analyse der Plattform-Unterstützung
- **[macOS Änderungen](CHANGES_FOR_MACOS.md)** - Dokumentation der macOS-spezifischen Anpassungen
- **[Modbus Referenz](ManModbus/)** - Modbus Protokoll-Referenz

## 🛠️ Technologie-Stack

- **Framework**: Qt 6.0+ (Qt 5.14+ unterstützt)
- **Modbus-Bibliothek**: libmodbus 3.1.0-1
- **Logging**: QsLog
- **Build-System**: qmake oder CMake
- **Sprache**: C++17 (Qt 6) / C++11 (Qt 5)

## 📦 Abhängigkeiten

- Qt 6.0+ oder Qt 5.14+ (core, gui, network, widgets, serialport)
- libmodbus 3.1.0-1 (im Projekt enthalten)
- QsLog (im Projekt enthalten)
- CMake 3.16+ (optional, für CMake-Build)

## 🔨 Kompilierung

### macOS
```bash
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
qmake qModMaster.pro
make
```

### Linux
```bash
qmake qModMaster.pro
make
```

### Windows
```cmd
# Mit qmake
qmake qModMaster.pro
nmake

# Mit CMake (empfohlen)
mkdir build
cd build
cmake ..
cmake --build .
```

Siehe [Entwicklerhandbuch](docs/DEVELOPER_GUIDE.md) für detaillierte Anweisungen.

### Qt 6 Upgrade

Das Projekt wurde auf Qt 6 aktualisiert. Siehe [Qt 6 Upgrade Zusammenfassung](docs/QT6_UPGRADE_SUMMARY.md) für Details.

## 📝 Lizenz

Dieses Programm ist freie Software unter der **GNU General Public License v3**.

Siehe [LICENSE](LICENSE) Datei für Details.

## 🤝 Beitragen

Beiträge sind willkommen! Bitte verwenden Sie Git Flow für die Entwicklung:

```bash
git flow feature start feature-name
# Entwickeln und committen
git flow feature finish feature-name
```

Siehe [Entwicklerhandbuch](docs/DEVELOPER_GUIDE.md) für Details zum Entwicklungsprozess.

## 📞 Support

Bei Problemen oder Fragen:

1. Prüfen Sie die [Benutzerhandbuch](docs/USER_GUIDE.md) für häufige Probleme
2. Prüfen Sie die Log-Datei `QModMaster.log`
3. Verwenden Sie den Bus Monitor zur Diagnose
4. Erstellen Sie ein Issue im Projekt-Repository

## 🔗 Links

- **Modbus Protokoll**: [Modbus.org](http://www.modbus.org/)
- **libmodbus**: [libmodbus.org](http://www.libmodbus.org/)
- **Qt Framework**: [qt.io](https://www.qt.io/)

---

**Version**: 0.5.2-3  
**Letzte Aktualisierung**: 2024

