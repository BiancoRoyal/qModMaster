#-------------------------------------------------
#
# Project created by QtCreator 2010-11-24T09:57:26
#
#-------------------------------------------------

# Qt 6 Configuration
QT_VERSION_MIN = 6.0.0
QT += core gui network widgets serialport

# For Qt 5 compatibility (fallback)
greaterThan(QT_MAJOR_VERSION, 5): QT += widgets serialport

TARGET = qModMaster
TEMPLATE = app

# Build directory for generated files
CONFIG += object_parallel_to_source
MOC_DIR = build/moc
RCC_DIR = build/rcc
UI_DIR = build/ui
OBJECTS_DIR = build/obj

# C++17 for Qt 6 (C++11 for Qt 5 compatibility)
greaterThan(QT_MAJOR_VERSION, 5) {
    QMAKE_CXXFLAGS += -std=c++17
} else {
    QMAKE_CXXFLAGS += -std=gnu++11
}

SOURCES += src/main.cpp \
    src/mainwindow.cpp \
    3rdparty/libmodbus/modbus.c \
    src/forms/about.cpp \
    src/forms/settingsmodbusrtu.cpp \
    src/forms/settingsmodbustcp.cpp \
    src/modbusadapter.cpp \
    src/eutils.cpp \
    src/registersmodel.cpp \
    src/rawdatamodel.cpp \
    src/forms/settings.cpp \
    src/forms/busmonitor.cpp \
    3rdparty/libmodbus/modbus-data.c \
    3rdparty/libmodbus/modbus-tcp.c \
    3rdparty/libmodbus/modbus-rtu.c \
    src/rawdatadelegate.cpp \
    src/registersdatadelegate.cpp \
    src/modbuscommsettings.cpp \
    3rdparty/QsLog/QsLogDest.cpp \
    3rdparty/QsLog/QsLog.cpp \
    3rdparty/QsLog/QsLogDestConsole.cpp \
    3rdparty/QsLog/QsLogDestFile.cpp \
    src/infobar.cpp \
    src/forms/tools.cpp

HEADERS  += src/mainwindow.h \
    3rdparty/libmodbus/modbus.h \
    src/forms/about.h \
    src/forms/settingsmodbusrtu.h \
    src/forms/settingsmodbustcp.h \
    src/modbusadapter.h \
    src/eutils.h \
    src/registersmodel.h \
    src/rawdatamodel.h \
    src/forms/settings.h \
    src/forms/busmonitor.h \
    src/rawdatadelegate.h \
    src/registersdatadelegate.h \
    src/modbuscommsettings.h \
    3rdparty/QsLog/QsLog.h \
    3rdparty/QsLog/QsLogDest.h \
    3rdparty/QsLog/QsLogDestConsole.h \
    3rdparty/QsLog/QsLogLevel.h \
    3rdparty/QsLog/QsLogDisableForThisFile.h \
    3rdparty/QsLog/QsLogDestFile.h \
    src/infobar.h \
    src/forms/tools.h

INCLUDEPATH += 3rdparty/libmodbus \
    3rdparty/QsLog

TRANSLATIONS += translations/$$TARGET"_zh_CN.ts"
TRANSLATIONS += translations/$$TARGET"_zh_TW.ts"

unix:SOURCES +=

unix:DEFINES += _TTY_POSIX_

win32:SOURCES +=

win32:DEFINES += _TTY_WIN_  WINVER=0x0501

win32:LIBS += -lsetupapi -lwsock32 -lws2_32

# C++ standard is set conditionally above based on Qt version

DEFINES += QS_LOG_LINE_NUMBERS     # automatically writes the file and line for each log message
#DEFINES += QS_LOG_DISABLE         # logging code is replaced with a no-op
#DEFINES += QS_LOG_SEPARATE_THREAD # messages are queued and written from a separate thread
#DEFINES += LIB_MODBUS_DEBUG_OUTPUT # enable debug output from libmodbus

FORMS    += src/forms/mainwindow.ui \
    src/forms/about.ui \
    src/forms/settingsmodbusrtu.ui \
    src/forms/settingsmodbustcp.ui \
    src/forms/settings.ui \
    src/forms/busmonitor.ui \
    src/forms/tools.ui

RESOURCES += \
    icons/icons.qrc \
    translations/translations.qrc


















