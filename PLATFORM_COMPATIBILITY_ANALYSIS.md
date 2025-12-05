# Plattform-Kompatibilitätsanalyse: qModMaster

## Zusammenfassung

Dieses Dokument analysiert die plattformübergreifende Kompatibilität des qModMaster-Projekts für **macOS**, **Linux** und **Windows** und identifiziert notwendige Anpassungen.

## Aktuelle Situation

### Unterstützte Plattformen (laut README)
- ✅ Windows (getestet)
- ✅ Linux (getestet)
- ❌ macOS (nicht explizit unterstützt)

### Projekt-Struktur
- **Qt-basiert**: Qt 5.2.1+ mit Widgets
- **Modbus-Bibliothek**: libmodbus 3.1.0-1
- **Logging**: QsLog
- **Build-System**: qmake (.pro Datei)

---

## Identifizierte Probleme

### 1. **Kritisch: Serial Port Namen für macOS**

**Problem**: macOS verwendet andere Serial Port Namen als Linux:
- **Linux**: `/dev/ttyS0`, `/dev/ttyS1`, etc.
- **macOS**: `/dev/tty.usbserial-*`, `/dev/cu.usbserial-*`, `/dev/tty.*`, etc.
- **Windows**: `COM1`, `COM2`, etc.

**Betroffene Dateien**:
- `src/modbuscommsettings.cpp` (Zeilen 59-74, 262-282)
- `forms/settingsmodbusrtu.cpp` (Zeile 12)

**Aktueller Code**:
```cpp
#ifdef Q_OS_WIN32
    m_serialDev = "COM";
#else
    m_serialDev = "/dev/ttyS";  // ❌ Funktioniert NICHT auf macOS!
#endif
```

**Lösung**: macOS-spezifische Behandlung hinzufügen:
```cpp
#ifdef Q_OS_WIN32
    m_serialDev = "COM";
#elif defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    m_serialDev = "/dev/tty.usbserial";  // Standard für USB-Serial Adapter
#else
    m_serialDev = "/dev/ttyS";  // Linux
#endif
```

---

### 2. **Kritisch: Serial Port Name Konstruktion**

**Problem**: Die Port-Name-Konstruktion funktioniert nicht für macOS.

**Betroffene Datei**: `src/modbuscommsettings.cpp` (Zeilen 59-74)

**Aktueller Code**:
```cpp
#ifdef Q_OS_WIN32
    if (serialPortNo > 9)
        m_serialPortName = "\\\\.\\COM" + serialPort;
    else
        m_serialPortName = "COM" + serialPort;
#else
    m_serialPortName = serialDev;
    m_serialPortName += QStringLiteral("%1").arg(serialPort.toInt() - 1);
    // ❌ Erzeugt "/dev/tty.usbserial0" statt "/dev/tty.usbserial-1410" auf macOS
#endif
```

**Lösung**: macOS benötigt vollständige Port-Namen (nicht numerische Suffixe):
```cpp
#ifdef Q_OS_WIN32
    if (serialPortNo > 9)
        m_serialPortName = "\\\\.\\COM" + serialPort;
    else
        m_serialPortName = "COM" + serialPort;
#elif defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    // macOS: Port-Name wird direkt verwendet (z.B. "/dev/tty.usbserial-1410")
    m_serialPortName = serialDev.isEmpty() ? "/dev/tty.usbserial" : serialDev;
    // Wenn serialPort einen vollständigen Namen enthält, verwende diesen
    if (serialPort.contains("/dev/")) {
        m_serialPortName = serialPort;
    }
#else
    m_serialPortName = serialDev;
    m_serialPortName += QStringLiteral("%1").arg(serialPort.toInt() - 1);
#endif
```

---

### 3. **Mittel: RTS-Optionen für macOS**

**Problem**: RTS-Optionen sind nur für Windows/Unix definiert, aber macOS könnte andere Optionen benötigen.

**Betroffene Datei**: `forms/settingsmodbusrtu.cpp` (Zeilen 43-52)

**Aktueller Code**:
```cpp
#ifdef Q_OS_WIN32
    ui->cmbRTS->addItem("Disable");
    ui->cmbRTS->addItem("Enable");
    ui->cmbRTS->addItem("HandShake");
    ui->cmbRTS->addItem("Toggle");
#else
    ui->cmbRTS->addItem("None");
    ui->cmbRTS->addItem("Up");
    ui->cmbRTS->addItem("Down");
#endif
```

**Status**: ✅ **OK** - Unix-Optionen funktionieren auch auf macOS (libmodbus unterstützt dies).

---

### 4. **Niedrig: .pro Datei - macOS Support**

**Problem**: Die `.pro` Datei verwendet `unix:` für alle Unix-Systeme, aber macOS könnte spezielle Behandlung benötigen.

**Betroffene Datei**: `qModMaster.pro` (Zeilen 67-75)

**Aktueller Code**:
```qmake
unix:SOURCES +=
unix:DEFINES += _TTY_POSIX_

win32:SOURCES +=
win32:DEFINES += _TTY_WIN_  WINVER=0x0501
win32:LIBS += -lsetupapi -lwsock32 -lws2_32
```

**Status**: ✅ **OK** - `unix:` umfasst macOS, aber explizite macOS-Behandlung wäre besser:
```qmake
unix:!macx:SOURCES +=  # Linux
macx:SOURCES +=        # macOS
unix:DEFINES += _TTY_POSIX_
```

---

### 5. **Niedrig: libmodbus config.h**

**Problem**: Die `config.h` ist für Linux konfiguriert. Für macOS könnte eine Neukonfiguration nötig sein.

**Betroffene Datei**: `3rdparty/libmodbus/config.h`

**Status**: ⚠️ **Prüfen** - libmodbus sollte auf macOS funktionieren, aber die config.h könnte macOS-spezifische Features nicht aktivieren.

**Empfehlung**: Bei Problemen libmodbus neu konfigurieren mit:
```bash
./configure --prefix=/usr/local
make
```

---

### 6. **Niedrig: UI-Kommentar**

**Problem**: Kommentar sagt "device name is needed only in Linux", aber macOS benötigt es auch.

**Betroffene Datei**: `forms/settingsmodbusrtu.cpp` (Zeile 12)

**Aktueller Code**:
```cpp
/* device name is needed only in Linux */
#ifdef Q_OS_WIN32
    ui->cmbDev->setDisabled(true);
#else
    ui->cmbDev->setDisabled(false);
#endif
```

**Lösung**: Kommentar korrigieren:
```cpp
/* device name is needed for Linux and macOS, not for Windows */
```

---

## Empfohlene Änderungen

### Priorität 1: Kritisch (muss behoben werden)

1. **Serial Port Namen für macOS** (`src/modbuscommsettings.cpp`)
   - macOS-spezifische Behandlung hinzufügen
   - Standard-Port-Namen für macOS setzen

2. **Serial Port Name Konstruktion** (`src/modbuscommsettings.cpp`)
   - macOS verwendet vollständige Port-Namen
   - Logik für macOS-Ports anpassen

### Priorität 2: Mittel (sollte behoben werden)

3. **Kommentar korrigieren** (`forms/settingsmodbusrtu.cpp`)
   - Kommentar aktualisieren, dass macOS auch Device-Namen benötigt

### Priorität 3: Niedrig (kann verbessert werden)

4. **.pro Datei explizite macOS-Behandlung**
   - `macx:` Scope hinzufügen für bessere Lesbarkeit

5. **libmodbus config.h prüfen**
   - Bei Problemen neu konfigurieren

---

## Test-Plan

### macOS Tests

1. **Serial Port Erkennung**
   - [ ] USB-Serial Adapter erkennen
   - [ ] Port-Name korrekt anzeigen
   - [ ] Verbindung zu Serial Port herstellen

2. **Modbus RTU Kommunikation**
   - [ ] Lesen von Registern
   - [ ] Schreiben von Registern
   - [ ] Verschiedene Baudraten testen

3. **Modbus TCP Kommunikation**
   - [ ] TCP-Verbindung herstellen
   - [ ] Daten lesen/schreiben

4. **UI-Funktionalität**
   - [ ] Settings-Dialog für RTU
   - [ ] Device-Auswahl funktioniert
   - [ ] RTS-Optionen funktionieren

### Linux Tests (Regression)

1. **Serial Port Funktionalität**
   - [ ] Bestehende Funktionalität bleibt erhalten

### Windows Tests (Regression)

1. **Serial Port Funktionalität**
   - [ ] Bestehende Funktionalität bleibt erhalten

---

## Build-Anweisungen

### macOS Build

```bash
# Qt installieren (z.B. via Homebrew)
brew install qt@5

# Oder Qt Creator verwenden

# Projekt öffnen und bauen
qmake qModMaster.pro
make

# Oder in Qt Creator:
# File -> Open -> qModMaster.pro
# Build -> Build All
```

### Linux Build

```bash
# Qt installieren
sudo apt-get install qt5-default qt5-qmake

# Projekt bauen
qmake qModMaster.pro
make
```

### Windows Build

```bash
# Qt installieren von qt.io
# Qt Creator öffnen
# File -> Open -> qModMaster.pro
# Build -> Build All
```

---

## Bekannte Einschränkungen

1. **Serial Port Erkennung**: macOS benötigt möglicherweise eine Liste verfügbarer Ports (QSerialPortInfo könnte helfen, wird aber aktuell nicht verwendet).

2. **Port-Namen**: macOS-Port-Namen sind nicht vorhersagbar (z.B. `/dev/tty.usbserial-1410`). Benutzer müssen den vollständigen Namen eingeben.

3. **Berechtigungen**: Auf macOS/Linux benötigt der Benutzer möglicherweise Berechtigungen für Serial Ports:
   ```bash
   sudo chmod 666 /dev/tty.usbserial-*
   ```
   Oder Benutzer zur `dialout` Gruppe hinzufügen (Linux).

---

## Fazit

Das Projekt ist **weitgehend plattformübergreifend**, benötigt aber **kritische Anpassungen für macOS**, insbesondere bei der Serial Port Behandlung. Die Hauptprobleme sind:

1. ✅ **Windows**: Vollständig unterstützt
2. ✅ **Linux**: Vollständig unterstützt  
3. ⚠️ **macOS**: Benötigt Code-Anpassungen für Serial Port Namen

Nach Implementierung der empfohlenen Änderungen sollte das Projekt auf allen drei Plattformen funktionieren.

