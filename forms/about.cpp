#include "about.h"
#include "ui_about.h"
#include "modbus-version.h"
#include <QApplication>
#include <QSysInfo>
#include <QTextDocument>
#include <QDateTime>
#include <QtGlobal>

const QString VER = "qModMaster 0.5.2-3";
const QString LIB_VER = LIBMODBUS_VERSION_STRING;

About::About(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::About)
{
    ui->setupUi(this);
    ui->lblVersion->setText(VER);
    
    // Build information HTML
    QString infoHtml = "<html><body style='font-family: Arial, sans-serif;'>";
    
    // Application Information
    infoHtml += "<h3 style='margin-top: 0;'>Application</h3>";
    infoHtml += "<p><b>Version:</b> " + VER + "</p>";
    infoHtml += "<p><b>Build Date:</b> " + QString(__DATE__) + " " + QString(__TIME__) + "</p>";
    
    // Qt Framework Information
    infoHtml += "<h3>Qt Framework</h3>";
    QString qtVersion = QString::number(QT_VERSION_MAJOR) + "." + 
                       QString::number(QT_VERSION_MINOR) + "." + 
                       QString::number(QT_VERSION_PATCH);
    QString qtRuntimeVersion = qVersion();
    infoHtml += "<p><b>Qt Runtime Version:</b> " + QString(qtRuntimeVersion) + "</p>";
    infoHtml += "<p><b>Qt Build Version:</b> " + qtVersion + "</p>";
    infoHtml += "<p><b>Qt Modules:</b> Core, GUI, Network, Widgets, SerialPort</p>";
    infoHtml += "<p><a href='https://www.qt.io/'>https://www.qt.io/</a></p>";
    
    // libmodbus Information
    infoHtml += "<h3>libmodbus</h3>";
    infoHtml += "<p><b>Version:</b> " + QString(LIB_VER) + "</p>";
    infoHtml += "<p>Modbus communication library</p>";
    infoHtml += "<p><a href='http://www.libmodbus.org/'>http://www.libmodbus.org/</a></p>";
    
    // QsLog Information
    infoHtml += "<h3>QsLog</h3>";
    infoHtml += "<p><b>Version:</b> 2.0b1</p>";
    infoHtml += "<p>Logging framework for Qt applications</p>";
    infoHtml += "<p><a href='https://bitbucket.org/razvanpetru/qt-logging/'>QsLog Project</a></p>";
    
    // Platform Information
    infoHtml += "<h3>Platform</h3>";
    infoHtml += "<p><b>Operating System:</b> " + QSysInfo::prettyProductName() + "</p>";
    infoHtml += "<p><b>Kernel Version:</b> " + QSysInfo::kernelVersion() + "</p>";
    infoHtml += "<p><b>Architecture:</b> " + QSysInfo::currentCpuArchitecture() + "</p>";
    
    // Build Information
    infoHtml += "<h3>Build Information</h3>";
    #ifdef Q_CC_MSVC
    infoHtml += "<p><b>Compiler:</b> Microsoft Visual C++</p>";
    #elif defined(Q_CC_GNU)
    infoHtml += "<p><b>Compiler:</b> GCC " + QString(__VERSION__) + "</p>";
    #elif defined(Q_CC_CLANG)
    infoHtml += "<p><b>Compiler:</b> Clang " + QString(__VERSION__) + "</p>";
    #else
    infoHtml += "<p><b>Compiler:</b> Unknown</p>";
    #endif
    
    #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    infoHtml += "<p><b>C++ Standard:</b> C++17</p>";
    #else
    infoHtml += "<p><b>C++ Standard:</b> C++11</p>";
    #endif
    
    // License Information
    infoHtml += "<h3>License</h3>";
    infoHtml += "<p><b>qModMaster:</b> GNU General Public License v3</p>";
    infoHtml += "<p><b>libmodbus:</b> GNU Lesser General Public License</p>";
    infoHtml += "<p><b>QsLog:</b> BSD License</p>";
    infoHtml += "<p><b>Qt:</b> LGPL v3 / Commercial</p>";
    
    infoHtml += "</body></html>";
    
    ui->txtInfo->setHtml(infoHtml);
    
    // Set window title
    setWindowTitle("About qModMaster");
}

About::~About()
{
    delete ui;
}
