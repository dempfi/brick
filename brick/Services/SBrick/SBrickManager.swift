import Foundation
import CoreBluetooth

protocol SBrickManagerDelegate: class {
  func sbrickManager(_ manager: SBrickManager, didDiscover sbrick: SBrick)
}

class SBrickManager: NSObject {
  var sbricks = Set<SBrick>()
  weak var delegate: SBrickManagerDelegate?
  private var shouldScan = false
  private var centralManager: CBCentralManager!

  init(delegate: SBrickManagerDelegate) {
    super.init()
    self.delegate = delegate
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

  func get(id: String) -> SBrick? {
    return self.sbricks.first(where: { $0.identifier == id })
  }
}

extension SBrickManager: CBCentralManagerDelegate {
  func centralManager(
    _ central: CBCentralManager,
    didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any],
    rssi RSSI: NSNumber
  ) {
    guard let sbrick = SBrick(peripheral, advertisementData) else { return }
    guard sbricks.allSatisfy({ $0.peripheral != peripheral }) else { return }
    sbricks.insert(sbrick)
    delegate?.sbrickManager(self, didDiscover: sbrick)
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
    if error != nil {
      print(error!.localizedDescription)
    }
    print("Disconnected")
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn && shouldScan {
      shouldScan = false
      scan()
    }
  }
}
