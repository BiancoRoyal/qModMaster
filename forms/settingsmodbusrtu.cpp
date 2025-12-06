#include <QtDebug>
#include <QSerialPortInfo>
#include "settingsmodbusrtu.h"
#include "ui_settingsmodbusrtu.h"

SettingsModbusRTU::SettingsModbusRTU(QWidget *parent,ModbusCommSettings * settings) :
    QDialog(parent),
    ui(new Ui::SettingsModbusRTU),
    m_settings(settings)
{
    ui->setupUi(this);

    /* device name is needed for Linux and macOS, not for Windows */
    #ifdef Q_OS_WIN32
        ui->cmbDev->setDisabled(true);
    #else
        ui->cmbDev->setDisabled(false);
    #endif

    connect(ui->buttonBox, &QDialogButtonBox::accepted, this, &SettingsModbusRTU::changesAccepted);

}

SettingsModbusRTU::~SettingsModbusRTU()
{
    delete ui;
}

void SettingsModbusRTU::showEvent(QShowEvent * event)
{

    //Load Settings
    ui->cmbDataBits->setEnabled(!modbus_connected);
    ui->cmbBaud->setEnabled(!modbus_connected);
    ui->sbPort->setEnabled(!modbus_connected);
    ui->cmbParity->setEnabled(!modbus_connected);
    ui->cmbRTS->setEnabled(!modbus_connected);
    ui->cmbStopBits->setEnabled(!modbus_connected);
    if (m_settings != NULL) {

         ui->cmbRTS->clear();

        //Populate cmbPort-cmbRTS
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

        ui->cmbDev->setCurrentText(m_settings->serialDev());
        ui->sbPort->setValue(m_settings->serialPort().toInt());
        ui->cmbBaud->setCurrentIndex(ui->cmbBaud->findText(m_settings->baud()));
        ui->cmbDataBits->setCurrentIndex(ui->cmbDataBits->findText(m_settings->dataBits()));
        ui->cmbStopBits->setCurrentIndex(ui->cmbStopBits->findText(m_settings->stopBits()));
        ui->cmbParity->setCurrentIndex(ui->cmbParity->findText(m_settings->parity()));
        ui->cmbRTS->setCurrentIndex(ui->cmbRTS->findText(m_settings->RTS()));
        
        // Populate serial port list using QSerialPortInfo (Qt 5.1+)
        #if QT_VERSION >= QT_VERSION_CHECK(5, 1, 0)
        ui->cmbDev->clear();
        const auto serialPortInfos = QSerialPortInfo::availablePorts();
        for (const QSerialPortInfo &portInfo : serialPortInfos) {
            QString portName = portInfo.portName();
            QString description = portInfo.description();
            QString manufacturer = portInfo.manufacturer();
            
            // Format: "COM1 (USB Serial Port)" or "/dev/tty.usbserial (FTDI)"
            QString displayName;
            #ifdef Q_OS_WIN32
            displayName = portName;
            #else
            displayName = portInfo.systemLocation(); // Full path like /dev/tty.usbserial-1410
            #endif
            
            if (!description.isEmpty() || !manufacturer.isEmpty()) {
                QString extraInfo;
                if (!description.isEmpty()) extraInfo = description;
                if (!manufacturer.isEmpty() && manufacturer != description) {
                    if (!extraInfo.isEmpty()) extraInfo += " ";
                    extraInfo += manufacturer;
                }
                if (!extraInfo.isEmpty()) {
                    displayName += " (" + extraInfo + ")";
                }
            }
            
            ui->cmbDev->addItem(displayName, portInfo.systemLocation());
        }
        
        // Select the saved port if available
        QString savedPort = m_settings->serialDev();
        if (!savedPort.isEmpty()) {
            int index = ui->cmbDev->findData(savedPort);
            if (index >= 0) {
                ui->cmbDev->setCurrentIndex(index);
            } else {
                // Try to find by display name
                index = ui->cmbDev->findText(savedPort);
                if (index >= 0) {
                    ui->cmbDev->setCurrentIndex(index);
                } else {
                    // Add saved port if not found (might be disconnected)
                    ui->cmbDev->addItem(savedPort, savedPort);
                    ui->cmbDev->setCurrentIndex(ui->cmbDev->count() - 1);
                }
            }
        }
        #endif
    }


}

void SettingsModbusRTU::changesAccepted()
{

    //Save Settings
    if (m_settings != NULL) {
        // Get the actual port name (system location) from combo box data
        QString portName = ui->cmbDev->currentData().toString();
        if (portName.isEmpty()) {
            // Fallback to display text if data is empty (Qt < 5.1 or manual entry)
            portName = ui->cmbDev->currentText();
        }
        
        m_settings->setSerialPort(QString::number(ui->sbPort->value()), portName);
        m_settings->setBaud(ui->cmbBaud->currentText());
        m_settings->setDataBits(ui->cmbDataBits->currentText());
        m_settings->setStopBits(ui->cmbStopBits->currentText());
        m_settings->setParity(ui->cmbParity->currentText());
        m_settings->setRTS((QString)ui->cmbRTS->currentText());
    }

}

