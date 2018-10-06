import Foundation
import CoreBluetooth

class SBrick: NSObject {
  static let RCServiceUUID = "4dc591b0-857c-41de-b5f1-15abda665b0c"
  static let RCCommandsCharacteristicUUID = "02B8CBCC-0E25-4BDA-8790-A15F53E6010F"
  static let QuickDriveCharacteristicUUID = "489A6AE0-C1AB-4C9C-BDB2-11D373C1B7FB"

  var name: String
  var peripheral: CBPeripheral
  var manufacturerData: ManufacturerData
  private var rcCommandsCharacteristics: CBCharacteristic?
  private var quickDriveCharacteristics: CBCharacteristic?

  init?(_ peripheral: CBPeripheral, _ advertisementData: [String: Any]) {
    guard let data = advertisementData["kCBAdvDataManufacturerData"] as? Data else { return nil }
    guard let manufacturerData = ManufacturerData(from: data) else { return nil }

    self.name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "N/A"
    self.manufacturerData = manufacturerData
    self.peripheral = peripheral
    super.init()
  }

  func didConnect() {
    peripheral.delegate = self
    peripheral.discoverServices([CBUUID(string: SBrick.RCServiceUUID)])
  }
}

extension SBrick: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }

    for service in services where service.uuid == CBUUID(string: SBrick.RCServiceUUID) {
      peripheral.discoverCharacteristics([
        CBUUID(string: SBrick.RCCommandsCharacteristicUUID),
        CBUUID(string: SBrick.QuickDriveCharacteristicUUID)
      ], for: service)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {

      if characteristic.uuid == CBUUID(string: SBrick.QuickDriveCharacteristicUUID) {
        quickDriveCharacteristics = characteristic
        peripheral.setNotifyValue(true, for: characteristic)
      }

      if characteristic.uuid == CBUUID(string: SBrick.RCCommandsCharacteristicUUID) {
        rcCommandsCharacteristics = characteristic
        peripheral.setNotifyValue(true, for: characteristic)
      }
    }
  }
}
