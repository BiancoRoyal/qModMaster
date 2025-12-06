#include <QtDebug>
#include <QFile>
#include <QFileDialog>
#include <QCloseEvent>
#include <QShowEvent>
#include <QtGlobal>  // For qMin
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
#include <QRegularExpression>
#else
#include <QRegExp>
#endif
#include "busmonitor.h"
#include "ui_busmonitor.h"
#include "./src/rawdatadelegate.h"


BusMonitor::BusMonitor(QWidget *parent, RawDataModel *rawDataModel) :
    QMainWindow(parent),
    ui(new Ui::BusMonitor),
    m_rawDataModel(rawDataModel)
{
    ui->setupUi(this);
    ui->lstRawData->setModel(m_rawDataModel->model);
    //ui->lstRawData->setItemDelegate(new RawDataDelegate());
    //Setup Toolbar
    ui->toolBar->addAction(ui->actionSave);
    ui->toolBar->addAction(ui->actionClear);
    ui->toolBar->addAction(ui->actionExit);
    connect(ui->actionSave, &QAction::triggered, this, &BusMonitor::save);
    connect(ui->actionClear, &QAction::triggered, this, &BusMonitor::clear);
    connect(ui->actionExit, &QAction::triggered, this, &BusMonitor::exit);
    connect(ui->lstRawData, &QListView::activated, this, &BusMonitor::selectedRow);
    connect(ui->lstRawData, &QListView::clicked, this, &BusMonitor::selectedRow);

}

BusMonitor::~BusMonitor()
{
    delete ui;
}

void BusMonitor::save()
{


    //Select file
    QString fileName = QFileDialog::getSaveFileName(NULL,"Save File As...",
                                                    QDir::homePath(),"Text (*.txt)",0,
                                                    QFileDialog::DontConfirmOverwrite);

    //Open File
    if (fileName.isEmpty())
        return;
    //continue only if a file name exists
    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly)) return;

    //Text Stream
    QTextStream ts(&file);
    QStringList sl = m_rawDataModel->model->stringList();

    //iterate
    for (int i = 0; i < sl.size(); ++i)
              ts << sl.at(i) << Qt::endl;

    //Close File
    file.close();

}

void BusMonitor::clear()
{


    m_rawDataModel->clear();
    ui->txtPDU->clear();

}

void BusMonitor::exit()
{


   this->close();

}

void BusMonitor::closeEvent(QCloseEvent *event)
{

    m_rawDataModel->enableAddLines(false);
    clear();
    event->accept();

}

void BusMonitor::showEvent(QShowEvent *event)
{

    m_rawDataModel->enableAddLines(true);
    event->accept();

}

void BusMonitor::selectedRow(const QModelIndex & selected)
{
    if (selected.data().canConvert(QVariant::String)) {
            QString val = selected.data().value<QString>();
            qDebug()<<  "BusMonitor : selectedRow - " << val;
            if (val.indexOf("Sys") > -1)
                parseSysMsg(val);
            else if (val.indexOf("Tx") > -1)
                parseTxMsg(val);
            else if (val.indexOf("Rx") > -1)
                parseRxMsg(val);
            else
                ui->txtPDU->setPlainText("Type : Unknown Message");

    }
}

void BusMonitor::parseTxMsg(QString msg)
{
    ui->txtPDU->setPlainText("Type : Tx Message");
    // Qt 6 compatible: QRegExp replaced with QRegularExpression
    #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    QStringList row = msg.split(QRegularExpression("\\s+"));
    #else
    QStringList row = msg.split(QRegExp("\\s+"));
    #endif
        // Bounds checking for safe array access
        if (row.length() < 3) {
            ui->txtPDU->appendPlainText("Error! Invalid message format");
            return;
        }
        ui->txtPDU->appendPlainText("Timestamp : " + row[2]);
        if (msg.indexOf("RTU") > -1){//RTU message
            QStringList pdu;
            if (row.length() < 5){//check message length
                ui->txtPDU->appendPlainText("Error! Cannot parse Message");
                return;
            }
            for (int i = 4; i < row.length() - 1 ; i++)
                pdu.append(row[i]);
            parseTxPDU(pdu, "Slave Addr : ");
            // Bounds checking for safe array access
            if (pdu.length() >= 2) {
                ui->txtPDU->appendPlainText("CRC : " + pdu[pdu.length() - 2] + pdu[pdu.length() - 1]);
            }
        }
        else if (msg.indexOf("TCP") > -1){//TCP message
            if (row.length() < 11){//check message length
                ui->txtPDU->appendPlainText("Error! Cannot parse Message");
                return;
            }
            // Bounds checking for safe array access
            if (row.length() >= 10) {
                ui->txtPDU->appendPlainText("Transaction ID : " + row[4] + row[5]);
                ui->txtPDU->appendPlainText("Protocol ID : " + row[6] + row[7]);
                ui->txtPDU->appendPlainText("Length : " + row[8] + row[9]);
            }
            QStringList pdu;
            for (int i = 10; i < row.length() - 1 ; i++)
                pdu.append(row[i]);
            parseTxPDU(pdu, "Unit ID : ");
        }
        else
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");

}

void BusMonitor::parseTxPDU(QStringList pdu, QString slave)
{

    if (pdu.length() < 6){//check message length
        if (pdu.length() >= 2) {
            ui->txtPDU->appendPlainText(slave + pdu[0]);
            ui->txtPDU->appendPlainText("Function Code : " + pdu[1]);
        } else {
            ui->txtPDU->appendPlainText("Error! Cannot parse Message - insufficient data");
        }
        return;
    }
    // Safe array access with bounds checking
    if (pdu.length() >= 4) {
        ui->txtPDU->appendPlainText(slave + pdu[0]);
        ui->txtPDU->appendPlainText("Function Code : " + pdu[1]);
        ui->txtPDU->appendPlainText("Starting Address : " + pdu[2] + pdu[3]);
    }
    bool ok;
    int fcode = pdu[1].toInt(&ok,16);
    if (fcode == 1 || fcode == 2 || fcode == 3 || fcode == 4){//read
        ui->txtPDU->appendPlainText("Quantity of Registers : " + pdu[4] + pdu[5]);
    }
    else if (fcode == 5 || fcode == 6){//write
        ui->txtPDU->appendPlainText("Output Value : " + pdu[4] + pdu[5]);
    }
    else if (fcode == 15 || fcode == 16){//write multiple
        ui->txtPDU->appendPlainText("Quantity of Registers : " + pdu[4] + pdu[5]);
        if (pdu.length() < 8){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        if (pdu.length() > 6) {
            ui->txtPDU->appendPlainText("Byte Count : " + pdu[6]);
            int byteCount = pdu[6].toInt(&ok,16);
            QString outputValues = "";
            // Bounds checking for safe array access
            int maxIndex = qMin(7 + byteCount, pdu.length());
            for (int i = 7; i < maxIndex; i++)
                outputValues += pdu[i] + " ";
            ui->txtPDU->appendPlainText("Output Values : " + outputValues);
        }
    }

}

void BusMonitor::parseRxMsg(QString msg)
{
    ui->txtPDU->setPlainText("Type : Rx Message");
    // Qt 6 compatible: QRegExp replaced with QRegularExpression
    #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    QStringList row = msg.split(QRegularExpression("\\s+"));
    #else
    QStringList row = msg.split(QRegExp("\\s+"));
    #endif
    ui->txtPDU->appendPlainText("Timestamp : " + row[2]);
    if (msg.indexOf("RTU") > -1){//RTU message
        QStringList pdu;
        if (row.length() < 5){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        for (int i = 4; i < row.length() - 1 ; i++)
            pdu.append(row[i]);
        parseRxPDU(pdu, "Slave Addr : ");
        // Bounds checking for safe array access
        if (pdu.length() >= 2) {
            ui->txtPDU->appendPlainText("CRC : " + pdu[pdu.length() - 2] + pdu[pdu.length() - 1]);
        }
    }
    else if (msg.indexOf("TCP") > -1){//TCP message
        if (row.length() < 11){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        // Bounds checking for safe array access
        if (row.length() >= 10) {
            ui->txtPDU->appendPlainText("Transaction ID : " + row[4] + row[5]);
            ui->txtPDU->appendPlainText("Protocol ID : " + row[6] + row[7]);
            ui->txtPDU->appendPlainText("Length : " + row[8] + row[9]);
        }
        QStringList pdu;
        for (int i = 10; i < row.length() - 1 ; i++)
            pdu.append(row[i]);
        parseRxPDU(pdu, "Unit ID : ");
    }
    else
        ui->txtPDU->appendPlainText("Error! Cannot parse Message");

}

void BusMonitor::parseRxPDU(QStringList pdu, QString slave)
{

    bool ok;
    int fcode = pdu[1].toInt(&ok,16);
    if (fcode == 1 || fcode == 2 || fcode == 3 || fcode == 4){//read
        if (pdu.length() < 4){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        ui->txtPDU->appendPlainText(slave + pdu[0]);
        ui->txtPDU->appendPlainText("Function Code : " + pdu[1]);
        if (pdu.length() > 2) {
            ui->txtPDU->appendPlainText("Byte Count : " + pdu[2]);
            int byteCount = pdu[2].toInt(&ok,16);
            QString inputValues = "";
            // Bounds checking for safe array access
            int maxIndex = qMin(3 + byteCount, pdu.length());
            for (int i = 3; i < maxIndex; i++)
                inputValues += pdu[i] + " ";
            ui->txtPDU->appendPlainText("Register Values : " + inputValues);
        }
    }
    else if (fcode == 5 || fcode == 6){//write
        if (pdu.length() < 6){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        if (pdu.length() >= 6) {
            ui->txtPDU->appendPlainText(slave + pdu[0]);
            ui->txtPDU->appendPlainText("Function Code : " + pdu[1]);
            ui->txtPDU->appendPlainText("Starting Address : " + pdu[2] + pdu[3]);
            ui->txtPDU->appendPlainText("Output Value : " + pdu[4] + pdu[5]);
        }
    }
    else if (fcode == 15 || fcode == 16){//write multiple
        if (pdu.length() < 6){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        if (pdu.length() >= 6) {
            ui->txtPDU->appendPlainText(slave + pdu[0]);
            ui->txtPDU->appendPlainText("Function Code : " + pdu[1]);
            ui->txtPDU->appendPlainText("Starting Address : " + pdu[2] + pdu[3]);
            ui->txtPDU->appendPlainText("Quantity of Registers : " + pdu[4] + pdu[5]);
        }
    }
    else if (fcode > 0x80){//exception
        if (pdu.length() < 3){//check message length
            ui->txtPDU->appendPlainText("Error! Cannot parse Message");
            return;
        }
        if (pdu.length() >= 3) {
            ui->txtPDU->appendPlainText(slave + pdu[0]);
            ui->txtPDU->appendPlainText("Function Code [80 + Rx Function Code] : " + pdu[1]);
            ui->txtPDU->appendPlainText("Exception Code : " + pdu[2]);
        }
    }

}

void BusMonitor::parseSysMsg(QString msg)
{
    ui->txtPDU->setPlainText("Type : System Message");
    // Qt 6 compatible: QRegExp replaced with QRegularExpression
    #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    QStringList row = msg.split(QRegularExpression("\\s+"));
    #else
    QStringList row = msg.split(QRegExp("\\s+"));
    #endif
    // Bounds checking for safe array access
    if (row.length() >= 3) {
        ui->txtPDU->appendPlainText("Timestamp : " + row[2]);
    }
    int msgIndex = msg.indexOf(" : ");
    if (msgIndex >= 0) {
        ui->txtPDU->appendPlainText("Message" + msg.mid(msgIndex));
    }
}
