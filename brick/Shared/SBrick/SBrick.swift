import Foundation
import CoreBluetooth

protocol SBrickDelegate: class {
  func sbrickConnected(_ sbrick: SBrick)
  func sbrickDisconnected(_ sbrick: SBrick)
  func sbrickReady(_ sbrick: SBrick)
}

extension SBrickDelegate {
  func sbrickConnected(_ sbrick: SBrick) {}
  func sbrickDisconnected(_ sbrick: SBrick) {}
  func sbrickReady(_ sbrick: SBrick) {}
}

class SBrick: NSObject {
  static let RCServiceUUID = "4dc591b0-857c-41de-b5f1-15abda665b0c"
  static let RCCommandsCharacteristicUUID = "02B8CBCC-0E25-4BDA-8790-A15F53E6010F"
  static let QuickDriveCharacteristicUUID = "489A6AE0-C1AB-4C9C-BDB2-11D373C1B7FB"

  var id: String!
  var name: String
  var firmware: String?
  var hardware: String?
  var temperature = 0.0
  var isSequred = false
  var productType: String!

  var peripheral: CBPeripheral
  var isReady = false

  weak var delegate: SBrickDelegate?
  private var keepaliveTimer: Timer?
  private var rcCommandsCharacteristics: CBCharacteristic?
  private var quickDriveCharacteristics: CBCharacteristic?
  private var commandsQueue: [SBrickCommand] = []

  init?(_ peripheral: CBPeripheral, _ advertisementData: [String: Any]) {
    guard let data = advertisementData["kCBAdvDataManufacturerData"] as? Data else { return nil }
    guard let records = SBrickPayload.parse(advertisementData: data) else { return nil }

    for record in records {
      switch record {
      case .device(id: let id):
        self.id = id
      case .secured(let isSecured):
        self.isSequred = isSecured
      case .product(type: let type, hardware: let hardware, firmware: let firmware):
        self.productType = type
        self.hardware = hardware
        self.firmware = firmware
      default: break
      }
    }

    self.name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "N/A"
    self.peripheral = peripheral
    super.init()
  }

  func didConnect() {
    peripheral.delegate = self
    peripheral.discoverServices([CBUUID(string: SBrick.RCServiceUUID)])
    delegate?.sbrickConnected(self)
    keepalive()
  }

  func exec(command: SBrickCommand) {
    guard let characteristic = self.rcCommandsCharacteristics else { return }
    self.commandsQueue.append(command)
    let data = NSData(bytes: command.data, length: command.data.count)
    peripheral.writeValue(data as Data, for: characteristic, type: .withResponse)
  }

  func read() {
    guard let characteristic = self.rcCommandsCharacteristics else { return }
    peripheral.readValue(for: characteristic)
  }

  private func keepalive() {
    guard keepaliveTimer == nil else { return }
    keepaliveTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (_) in
      self?.exec(command: .readTemperature)
    })
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

    delegate?.sbrickReady(self)
    isReady = true
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    guard error == nil else {
      print("Error occured for caharacteristic: \(characteristic.description), \(error.debugDescription)")
      return
    }
    guard self.commandsQueue.count > 0 else { return }
    let lastCommand = self.commandsQueue.remove(at: 0)
    let record = SBrickPayload.parse(raw: ([UInt8](characteristic.value!)))[0]

    guard case .command(let status, let value) = record else { return }
    guard status == .success else { return }

    switch lastCommand {
    case .readTemperature:
      let data = Data(bytes: value)
      let comvertedValue = Double(UInt16(littleEndian: data.withUnsafeBytes { $0.pointee }))
      temperature = comvertedValue / 118.85795 - 160

    default: break
    }
  }
}
