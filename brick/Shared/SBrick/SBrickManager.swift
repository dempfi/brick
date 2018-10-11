import Foundation
import CoreBluetooth

typealias SBrickLookupTask = (
  id: String,
  onSuccess: (_: SBrick) -> Void,
  onFailure: (_: String) -> Void
)

class SBrickManager: NSObject {
  var sbricks = Set<SBrick>()
  private var shouldScan = false
  private var centralManager: CBCentralManager!
  private var scanQueue = [SBrickLookupTask]()

  override init() {
    super.init()
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  func lookup(_ id: String, onSuccess: @escaping (_: SBrick) -> Void, onFailure: @escaping (_: String) -> Void) {
    scanQueue.append(SBrickLookupTask(id: id, onSuccess: onSuccess, onFailure: onFailure))
    if centralManager.isScanning { return }
    lookupAny()
  }

  func lookupAny() {
    if centralManager.state != .poweredOn { return }
    centralManager.scanForPeripherals(withServices: nil, options: nil)
  }

  func stopScan() {
    centralManager.stopScan()
  }

  func connect(to sbrick: SBrick) {
    centralManager.connect(sbrick.peripheral, options: nil)
  }

  func get(id: String) -> SBrick? {
    return self.sbricks.first(where: { $0.id == id })
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
    if scanQueue.isEmpty { return }

    for (index, task) in scanQueue.enumerated() {
      if task.id != sbrick.id { continue }
      task.onSuccess(sbrick)
      scanQueue.remove(at: index)
      break
    }

    if scanQueue.isEmpty { stopScan() }
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
    if central.state != .poweredOn || scanQueue.count == 0 { return }
    lookupAny()
  }
}
