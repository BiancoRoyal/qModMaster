# qModMaster - Benutzerhandbuch

## Inhaltsverzeichnis

1. [Einführung](#einführung)
2. [Installation](#installation)
3. [Erste Schritte](#erste-schritte)
4. [Modbus RTU Verbindung](#modbus-rtu-verbindung)
5. [Modbus TCP Verbindung](#modbus-tcp-verbindung)
6. [Funktionen](#funktionen)
7. [Einstellungen](#einstellungen)
8. [Fehlerbehebung](#fehlerbehebung)

---

## Einführung

**qModMaster** ist eine kostenlose, plattformübergreifende Modbus Master-Anwendung mit grafischer Benutzeroberfläche. Sie ermöglicht die einfache Kommunikation mit Modbus RTU und TCP Slaves.

### Hauptfunktionen

- **Modbus RTU Kommunikation** über serielle Schnittstellen
- **Modbus TCP Kommunikation** über Ethernet
- **Bus Monitor** zur Analyse des gesamten Bus-Verkehrs
- **Register-Lesen und -Schreiben** mit verschiedenen Funktionen
- **Echtzeit-Datenanzeige** in verschiedenen Zahlensystemen
- **Session-Management** zum Speichern und Laden von Konfigurationen
- **Mehrsprachige Unterstützung** (Englisch, Chinesisch)

### Unterstützte Plattformen

- ✅ **Windows** (7, 8, 10, 11)
- ✅ **macOS** (10.13+)
- ✅ **Linux** (Ubuntu, Debian, Fedora, etc.)

---

## Installation

### Windows

1. Laden Sie die Windows-Version herunter
2. Entpacken Sie die ZIP-Datei
3. Führen Sie `qModMaster.exe` aus (keine Installation erforderlich)

**Alternative:** Verwenden Sie das Start-Skript:
```cmd
start.bat
```

### macOS

1. Laden Sie die macOS-Version herunter
2. Entpacken Sie die ZIP-Datei
3. Öffnen Sie `qModMaster.app`

**Alternative:** Verwenden Sie das Start-Skript:
```bash
./start.sh
```

### Linux

1. Laden Sie die Linux-Version herunter
2. Entpacken Sie das Archiv
3. Machen Sie die Datei ausführbar:
   ```bash
   chmod +x qModMaster
   ```
4. Starten Sie die Anwendung:
   ```bash
   ./qModMaster
   ```

**Alternative:** Verwenden Sie das Start-Skript:
```bash
./start.sh
```

---

## Erste Schritte

### Programm starten

1. Starten Sie qModMaster über das Start-Skript oder die ausführbare Datei
2. Das Hauptfenster wird angezeigt

### Hauptfenster-Übersicht

- **Menüleiste**: Zugriff auf alle Funktionen
- **Toolbar**: Schnellzugriff auf häufig verwendete Funktionen
- **Register-Tabelle**: Zeigt die gelesenen/schreibbaren Register an
- **Statusleiste**: Zeigt Verbindungsstatus, Paketanzahl und Fehler

---

## Modbus RTU Verbindung

### Voraussetzungen

- Serielle Schnittstelle (USB-Serial Adapter oder integrierte COM-Ports)
- Verbindung zum Modbus RTU Slave-Gerät

### Verbindung einrichten

1. **Menü**: `Settings` → `Serial RTU` (oder Toolbar-Button)
2. **Serielle Schnittstelle auswählen**:
   - **Windows**: COM1, COM2, etc.
   - **Linux**: `/dev/ttyS0`, `/dev/ttyUSB0`, etc.
   - **macOS**: `/dev/tty.usbserial-*`, `/dev/cu.usbserial-*`
3. **Baudrate einstellen**: 9600, 19200, 38400, 57600, 115200
4. **Datenbits**: 7 oder 8
5. **Stopbits**: 1 oder 2
6. **Parität**: None, Even, Odd
7. **RTS-Steuerung** (nur Linux/macOS): None, Up, Down
8. **OK** klicken

### Verbindung herstellen

1. **Slave ID** eingeben (1-247)
2. **Funktionscode** auswählen:
   - **FC1**: Read Coils
   - **FC2**: Read Discrete Inputs
   - **FC3**: Read Holding Registers
   - **FC4**: Read Input Registers
   - **FC5**: Write Single Coil
   - **FC6**: Write Single Register
   - **FC15**: Write Multiple Coils
   - **FC16**: Write Multiple Registers
3. **Start-Adresse** eingeben
4. **Anzahl der Register** eingeben
5. **Connect**-Button klicken

### Wichtige Hinweise für macOS

- macOS verwendet spezielle Port-Namen wie `/dev/tty.usbserial-1410`
- Der vollständige Port-Name muss im Settings-Dialog eingegeben werden
- Verfügbare Ports können mit `ls /dev/tty.*` im Terminal gefunden werden

---

## Modbus TCP Verbindung

### Voraussetzungen

- Netzwerkverbindung zum Modbus TCP Slave-Gerät
- IP-Adresse und Port des Slave-Geräts (Standard: Port 502)

### Verbindung einrichten

1. **Menü**: `Settings` → `TCP` (oder Toolbar-Button)
2. **IP-Adresse** eingeben (z.B. `192.168.1.100`)
3. **Port** eingeben (Standard: `502`)
4. **OK** klicken

### Verbindung herstellen

1. **Slave ID** eingeben (1-247)
2. **Funktionscode** auswählen
3. **Start-Adresse** und **Anzahl der Register** eingeben
4. **Connect**-Button klicken

---

## Funktionen

### Register lesen

1. Verbindung herstellen (siehe oben)
2. **Funktionscode** für Lesen auswählen (FC1, FC2, FC3, FC4)
3. **Start-Adresse** und **Anzahl** eingeben
4. **Add Items** klicken (oder automatisch beim Verbinden)
5. Register werden automatisch gelesen und angezeigt

### Register schreiben

1. Verbindung herstellen
2. **Funktionscode** für Schreiben auswählen (FC5, FC6, FC15, FC16)
3. **Start-Adresse** und **Anzahl** eingeben
4. **Add Items** klicken
5. Werte in der Tabelle eingeben
6. **Read/Write**-Button klicken

### Zyklisches Scannen

1. Verbindung herstellen
2. **Scan Rate** einstellen (in Millisekunden)
3. **Scan**-Button aktivieren
4. Register werden automatisch in der eingestellten Rate gelesen

### Bus Monitor

Der Bus Monitor zeigt alle Datenpakete auf dem Modbus-Bus an:

1. **Menü**: `Tools` → `Bus Monitor`
2. Alle Request- und Response-Pakete werden angezeigt
3. Daten werden im Hex-Format angezeigt

### Session speichern/laden

**Session speichern:**
1. **Menü**: `File` → `Save Session`
2. Dateiname eingeben
3. Alle aktuellen Einstellungen werden gespeichert

**Session laden:**
1. **Menü**: `File` → `Load Session`
2. Gespeicherte Session-Datei auswählen
3. Einstellungen werden wiederhergestellt

---

## Einstellungen

### Allgemeine Einstellungen

**Menü**: `Settings` → `Settings`

- **Maximale Anzahl von Zeilen**: Begrenzt die Anzahl der angezeigten Zeilen im Raw Data Monitor
- **Basis-Adresse**: Offset für die Adressanzeige (0 oder 1)
- **Timeout**: Timeout für Modbus-Transaktionen (in Sekunden)

### Logging

Das Logging-Level kann in der Datei `qModMaster.ini` eingestellt werden:

```ini
[Var]
LoggingLevel=3
```

**Logging-Level:**
- `0`: TraceLevel (sehr detailliert)
- `1`: DebugLevel
- `2`: InfoLevel
- `3`: WarnLevel (Standard)
- `4`: ErrorLevel
- `5`: FatalLevel
- `6`: OffLevel (kein Logging)

Die Log-Datei wird im Anwendungsverzeichnis als `QModMaster.log` gespeichert.

### Sprache ändern

**Menü**: `Language` → Sprache auswählen
- English (en_US)
- Simplified Chinese (zh_CN)
- Traditional Chinese (zh_TW)

---

## Fehlerbehebung

### Verbindungsprobleme

**"Connection failed - Could not connect to serial port"**
- Prüfen Sie, ob der Port korrekt ist
- Prüfen Sie, ob der Port von einer anderen Anwendung verwendet wird
- Prüfen Sie die Kabelverbindung
- **macOS**: Stellen Sie sicher, dass Sie den vollständigen Port-Namen verwenden

**"Connection failed - Could not connect to TCP port"**
- Prüfen Sie die IP-Adresse und den Port
- Prüfen Sie die Netzwerkverbindung
- Prüfen Sie die Firewall-Einstellungen
- Prüfen Sie, ob der Slave-Gerät erreichbar ist (ping)

### Lesen/Schreiben Fehler

**"Read data failed" / "Write data failed"**
- Prüfen Sie die Slave ID
- Prüfen Sie die Start-Adresse und Anzahl der Register
- Prüfen Sie, ob der Funktionscode unterstützt wird
- Prüfen Sie die Verbindung (Bus Monitor verwenden)

### macOS-spezifische Probleme

**Port nicht gefunden:**
```bash
# Verfügbare Ports auflisten
ls /dev/tty.*
ls /dev/cu.*

# Berechtigungen prüfen
ls -l /dev/tty.usbserial-*
```

**Berechtigungsprobleme:**
```bash
# Benutzer zur dialout Gruppe hinzufügen (Linux)
sudo usermod -a -G dialout $USER

# macOS: Port-Berechtigungen prüfen
sudo chmod 666 /dev/tty.usbserial-*
```

### Log-Datei prüfen

Bei Problemen können Sie die Log-Datei `QModMaster.log` im Anwendungsverzeichnis prüfen:
- **Windows**: Im Ordner mit `qModMaster.exe`
- **macOS**: In `qModMaster.app/Contents/MacOS/`
- **Linux**: Im Ordner mit `qModMaster`

---

## Tastenkürzel

- **F1**: Hilfe
- **Ctrl+O**: Session laden
- **Ctrl+S**: Session speichern
- **Ctrl+Q**: Beenden (macOS/Linux)
- **Alt+F4**: Beenden (Windows)

---

## Support

Bei Problemen oder Fragen:

1. Prüfen Sie die Log-Datei `QModMaster.log`
2. Verwenden Sie den Bus Monitor zur Diagnose
3. Prüfen Sie die Dokumentation im `ManModbus/` Verzeichnis
4. Erstellen Sie ein Issue im Projekt-Repository

---

## Lizenz

Dieses Programm ist freie Software unter der GNU General Public License v3.

Siehe `LICENSE` Datei für Details.

