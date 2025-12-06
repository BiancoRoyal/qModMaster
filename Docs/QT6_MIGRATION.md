# Qt 6 Migration Guide

## Übersicht

Dieses Dokument beschreibt die Migration von Qt 5 zu Qt 6 für qModMaster.

## Hauptänderungen

### 1. Build-System

**Qt 5:**
```qmake
QT += core gui network
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
```

**Qt 6:**
```qmake
QT += core gui network widgets
```

### 2. Deprecated APIs

#### QString::sprintf()
**Qt 5:**
```cpp
QString().sprintf("%.2x  ", data[i]);
```

**Qt 6:**
```cpp
QString::asprintf("%.2x  ", data[i]);
// Oder besser:
QString("%1").arg(data[i], 2, 16, QChar('0'));
```

#### QTextStream::endl
**Qt 5:**
```cpp
ts << text << endl;
```

**Qt 6:**
```cpp
ts << text << Qt::endl;
```

#### QApplication::setAttribute(Qt::AA_EnableHighDpiScaling)
**Qt 5:**
```cpp
QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
```

**Qt 6:**
- Nicht mehr benötigt, High DPI wird automatisch unterstützt

### 3. Signal-Slot Syntax

**Qt 4/5 (String-basiert):**
```cpp
QObject::connect(&modbus_adapt, SIGNAL(refreshView()), mainWin, SLOT(refreshView()));
```

**Qt 6 (Funktionale Syntax - empfohlen):**
```cpp
QObject::connect(&modbus_adapt, &ModbusAdapter::refreshView, mainWin, &MainWindow::refreshView);
```

### 4. C++ Standard

**Qt 5:** C++11
**Qt 6:** C++17 (empfohlen)

### 5. Serial Port Erkennung

**Qt 5:** Manuelle Port-Namen-Eingabe
**Qt 6:** QSerialPortInfo für automatische Port-Erkennung

## Migration Checklist

- [ ] qModMaster.pro aktualisieren
- [ ] Deprecated APIs ersetzen
- [ ] Signal-Slot Syntax aktualisieren
- [ ] C++ Standard auf C++17 erhöhen
- [ ] QSerialPortInfo Integration
- [ ] CMakeLists.txt erstellen (optional)
- [ ] Tests mit Qt 6 durchführen

