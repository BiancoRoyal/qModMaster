# Implementierte Änderungen für macOS-Unterstützung

## Übersicht

Dieses Dokument beschreibt die durchgeführten Code-Änderungen, um macOS-Unterstützung zum qModMaster-Projekt hinzuzufügen.

## Durchgeführte Änderungen

### 1. ✅ Serial Port Namen für macOS (`src/modbuscommsettings.cpp`)

**Geändert**: `setSerialPort()` Funktion (Zeilen 59-75)

**Vorher**:
```cpp
#else
    m_serialPortName = serialDev;
    m_serialPortName += QStringLiteral("%1").arg(serialPort.toInt() - 1);
#endif
```

**Nachher**:
```cpp
#elif defined(Q_OS_MACOS) || defined(Q_OS_MAC)
    // macOS: Port-Name wird direkt verwendet (z.B. "/dev/tty.usbserial-1410")
    // Wenn serialPort einen vollständigen Pfad enthält, verwende diesen direkt
    if (serialPort.contains("/dev/")) {
        m_serialPortName = serialPort;
    } else if (!serialDev.isEmpty() && serialDev.contains("/dev/")) {
        // Wenn serialDev bereits ein vollständiger Pfad ist
        m_serialPortName = serialDev;
    } else {
        // Fallback: Verwende serialDev mit serialPort als Suffix
        m_serialPortName = serialDev.isEmpty() ? "/dev/tty.usbserial" : serialDev;
        if (!serialPort.isEmpty() && serialPortNo > 0) {
            // Versuche numerisches Suffix hinzuzufügen, falls sinnvoll
            m_serialPortName += QStringLiteral("%1").arg(serialPortNo - 1);
        }
    }
#else
    m_serialPortName = serialDev;
    m_serialPortName += QStringLiteral("%1").arg(serialPort.toInt() - 1);
#endif
```

**Grund**: macOS verwendet vollständige Port-Namen wie `/dev/tty.usbserial-1410` statt numerischer Suffixe wie Linux (`/dev/ttyS0`).

---

### 2. ✅ Standard Serial Device für macOS (`src/modbuscommsettings.cpp`)

**Geändert**: `load()` Funktion - SerialDev Initialisierung (Zeilen 262-273)

**Vorher**:
```cpp
    if (s->value("RTU/SerialDev").isNull())
        #ifdef Q_OS_WIN32
            m_serialDev = "COM";
        #else
            m_serialDev = "/dev/ttyS";
        #endif
```

**Nachher**:
```cpp
    if (s->value("RTU/SerialDev").isNull())
        #ifdef Q_OS_WIN32
            m_serialDev = "COM";
        #elif defined(Q_OS_MACOS) || defined(Q_OS_MAC)
            m_serialDev = "/dev/tty.usbserial";
        #else
            m_serialDev = "/dev/ttyS";
        #endif
```

**Grund**: macOS verwendet `/dev/tty.usbserial-*` als Standard für USB-Serial Adapter, nicht `/dev/ttyS*`.

---

### 3. ✅ Serial Port Name Initialisierung (`src/modbuscommsettings.cpp`)

**Geändert**: `load()` Funktion - SerialPortName Initialisierung (Zeilen 274-283)

**Vorher**:
```cpp
        #ifdef Q_OS_WIN32
            m_serialPortName = "COM" + m_serialPort;
        #else
            m_serialPortName = m_serialDev;
            m_serialPortName += QStringLiteral("%1").arg(m_serialPort.toInt() - 1);
        #endif
```

**Nachher**:
```cpp
        #ifdef Q_OS_WIN32
            m_serialPortName = "COM" + m_serialPort;
        #elif defined(Q_OS_MACOS) || defined(Q_OS_MAC)
            // macOS: Verwende den Standard-Device-Namen
            m_serialPortName = m_serialDev;
        #else
            m_serialPortName = m_serialDev;
            m_serialPortName += QStringLiteral("%1").arg(m_serialPort.toInt() - 1);
        #endif
```

**Grund**: macOS benötigt keine numerischen Suffixe für Port-Namen.

---

### 4. ✅ Kommentar korrigiert (`forms/settingsmodbusrtu.cpp`)

**Geändert**: Kommentar in Zeile 12

**Vorher**:
```cpp
/* device name is needed only in Linux */
```

**Nachher**:
```cpp
/* device name is needed for Linux and macOS, not for Windows */
```

**Grund**: Der Kommentar war ungenau - macOS benötigt ebenfalls Device-Namen.

---

## Verwendete Qt-Plattform-Makros

- `Q_OS_WIN32`: Windows
- `Q_OS_MACOS` oder `Q_OS_MAC`: macOS (beide werden unterstützt für Kompatibilität)
- `unix:` (in .pro Datei): Linux und macOS

## Nächste Schritte

1. **Testen auf macOS**:
   - Projekt auf macOS kompilieren
   - Serial Port Verbindung testen
   - Verschiedene USB-Serial Adapter testen

2. **Optional - Serial Port Erkennung verbessern**:
   - `QSerialPortInfo` verwenden, um verfügbare Ports automatisch zu erkennen
   - Port-Liste im UI anzeigen

3. **Dokumentation aktualisieren**:
   - README.txt aktualisieren, um macOS zu erwähnen
   - Build-Anweisungen für macOS hinzufügen

## Bekannte Einschränkungen

1. **Port-Namen müssen manuell eingegeben werden**: macOS-Port-Namen sind nicht vorhersagbar (z.B. `/dev/tty.usbserial-1410`). Benutzer müssen den vollständigen Namen im Settings-Dialog eingeben.

2. **Berechtigungen**: Auf macOS benötigt der Benutzer möglicherweise Berechtigungen für Serial Ports. Dies kann durch Hinzufügen des Benutzers zur entsprechenden Gruppe oder durch `sudo` gelöst werden.

## Kompatibilität

- ✅ **Windows**: Alle Änderungen sind rückwärtskompatibel
- ✅ **Linux**: Alle Änderungen sind rückwärtskompatibel
- ✅ **macOS**: Neue Unterstützung hinzugefügt

