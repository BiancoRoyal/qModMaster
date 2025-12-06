#include <QApplication>
#include <stdio.h>
#include <stdlib.h>
#include <QDir>
#include <QTranslator>

#include "QsLog.h"
#include "QsLogDest.h"
#include "mainwindow.h"
#include "modbusadapter.h"
#include "modbuscommsettings.h"

QTranslator *Translator;

//Logging Levels
//TraceLevel : 0
//DebugLevel : 1
//InfoLevel : 2
//WarnLevel : 3
//ErrorLevel : 4
//FatalLevel : 5
//OffLevel : 6

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // Set application metadata
    app.setApplicationName("qModMaster");
    app.setApplicationVersion("0.6.0");
    app.setOrganizationName("qModMaster");
    
    // High DPI scaling is automatic in Qt 6, deprecated in Qt 5.14+
    #if QT_VERSION < QT_VERSION_CHECK(5, 14, 0)
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    #endif
    
    Translator = new QTranslator;
    Translator->load(":/translations/" + QCoreApplication::applicationName() + "_" + QLocale::system().name());
    app.installTranslator(Translator);

    //init the logging mechanism
    QsLogging::Logger& logger = QsLogging::Logger::instance();
    logger.setLoggingLevel(QsLogging::OffLevel); // start with no logging
    const QString sLogPath(QDir(app.applicationDirPath()).filePath("QModMaster.log"));
    QsLogging::DestinationPtr fileDestination(QsLogging::DestinationFactory::MakeFileDestination(sLogPath,true,65535,2));
    QsLogging::DestinationPtr debugDestination(QsLogging::DestinationFactory::MakeDebugOutputDestination());
    logger.addDestination(debugDestination);
    logger.addDestination(fileDestination);

    //Modbus Adapter
    ModbusAdapter modbus_adapt(NULL);
    //Program settings
    ModbusCommSettings settings("qModMaster.ini");

    //show main window
    mainWin = new MainWindow(NULL, &modbus_adapt, &settings);
    //connect signals - slots (Qt 6 compatible functional syntax)
    QObject::connect(&modbus_adapt, &ModbusAdapter::refreshView, mainWin, &MainWindow::refreshView);
    QObject::connect(mainWin, &MainWindow::resetCounters, &modbus_adapt, &ModbusAdapter::resetCounters);
    mainWin->show();

    return app.exec();

}
