import Foundation
import CoreBluetooth

class SBrickController: NSObject {
  var sbricks = Set<SBrick>()
  private var centralManager: CBCentralManager!
  private var shouldScan = false

  override init() {
    super.init()
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  func scan() {
    if centralManager.state == .poweredOn {
      centralManager.scanForPeripherals(withServices: nil, options: nil)
      shouldScan = false
    } else {
      shouldScan = true
    }
  }

  func stopScan() {
    shouldScan = false
    centralManager.stopScan()
  }

  func connect(to sbrick: SBrick) {
    centralManager.connect(sbrick.peripheral, options: nil)
  }
}

extension SBrickController: CBCentralManagerDelegate {
  func centralManager(
    _ central: CBCentralManager,
    didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any],
    rssi RSSI: NSNumber
  ) {
    guard let sbrick = SBrick(peripheral, advertisementData) else { return }
    guard sbricks.allSatisfy({ $0.peripheral != peripheral }) else { return }
    print(sbrick.name, sbrick.manufacturerData)
    sbricks.insert(sbrick)
    connect(to: sbrick)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    for sbrick in sbricks {
      if sbrick.peripheral != peripheral { continue }
      sbrick.didConnect()
    }
  }

  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    print("Failed to connect")
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    print("Disconnected")
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn && shouldScan {
      shouldScan = false
      scan()
    }
  }
}
