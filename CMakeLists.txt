cmake_minimum_required(VERSION 3.16)
project(qModMaster VERSION 0.5.2.3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt6, fallback to Qt5
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Gui Network Widgets SerialPort)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Gui Network Widgets SerialPort)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Source files
set(SOURCES
    src/main.cpp
    src/mainwindow.cpp
    src/modbusadapter.cpp
    src/eutils.cpp
    src/registersmodel.cpp
    src/rawdatamodel.cpp
    src/rawdatadelegate.cpp
    src/registersdatadelegate.cpp
    src/modbuscommsettings.cpp
    src/infobar.cpp
    src/forms/about.cpp
    src/forms/settingsmodbusrtu.cpp
    src/forms/settingsmodbustcp.cpp
    src/forms/settings.cpp
    src/forms/busmonitor.cpp
    src/forms/tools.cpp
    3rdparty/libmodbus/modbus.c
    3rdparty/libmodbus/modbus-data.c
    3rdparty/libmodbus/modbus-tcp.c
    3rdparty/libmodbus/modbus-rtu.c
    3rdparty/QsLog/QsLog.cpp
    3rdparty/QsLog/QsLogDest.cpp
    3rdparty/QsLog/QsLogDestConsole.cpp
    3rdparty/QsLog/QsLogDestFile.cpp
)

# Header files
set(HEADERS
    src/mainwindow.h
    src/modbusadapter.h
    src/eutils.h
    src/registersmodel.h
    src/rawdatamodel.h
    src/rawdatadelegate.h
    src/registersdatadelegate.h
    src/modbuscommsettings.h
    src/infobar.h
    src/forms/about.h
    src/forms/settingsmodbusrtu.h
    src/forms/settingsmodbustcp.h
    src/forms/settings.h
    src/forms/busmonitor.h
    src/forms/tools.h
    3rdparty/libmodbus/modbus.h
    3rdparty/QsLog/QsLog.h
    3rdparty/QsLog/QsLogDest.h
    3rdparty/QsLog/QsLogDestConsole.h
    3rdparty/QsLog/QsLogDestFile.h
    3rdparty/QsLog/QsLogLevel.h
    3rdparty/QsLog/QsLogDisableForThisFile.h
)

# UI files
set(UI_FILES
    src/forms/mainwindow.ui
    src/forms/about.ui
    src/forms/settingsmodbusrtu.ui
    src/forms/settingsmodbustcp.ui
    src/forms/settings.ui
    src/forms/busmonitor.ui
    src/forms/tools.ui
)

# Resource files
set(RESOURCES
    icons/icons.qrc
    translations/translations.qrc
)

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/libmodbus
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/QsLog
)

# Platform-specific settings
if(WIN32)
    add_definitions(-D_TTY_WIN_ -DWINVER=0x0501)
elseif(APPLE)
    add_definitions(-D_TTY_POSIX_)
elseif(UNIX)
    add_definitions(-D_TTY_POSIX_)
endif()

# Create executable
add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${UI_FILES} ${RESOURCES})

# Link Qt libraries
target_link_libraries(${PROJECT_NAME}
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Network
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::SerialPort
)

# Platform-specific libraries (must be after target_link_libraries)
if(WIN32)
    # Windows libraries already linked above
elseif(APPLE)
    find_library(DISKARBITRATION_LIB DiskArbitration)
    find_library(IOKIT_LIB IOKit)
    if(DISKARBITRATION_LIB AND IOKIT_LIB)
        target_link_libraries(${PROJECT_NAME} ${DISKARBITRATION_LIB} ${IOKIT_LIB})
    endif()
endif()

# Build directory
set_target_properties(${PROJECT_NAME} PROPERTIES
    AUTOMOC_MOC_OPTIONS -b
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Installation
if(WIN32)
    install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION .)
elseif(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
    )
    install(TARGETS ${PROJECT_NAME} BUNDLE DESTINATION .)
else()
    install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
endif()

# Print Qt version info
message(STATUS "Qt Version: ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")
message(STATUS "Building for: ${CMAKE_SYSTEM_NAME}")

