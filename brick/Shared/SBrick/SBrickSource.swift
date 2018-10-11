import Foundation
import CoreBluetooth

class SBrickSource: NSObject {
  typealias LookupTask = (
    id: String,
    onSuccess: (_: SBrick) -> Void,
    onFailure: ((_: String) -> Void)?
  )

  var sbricks = Set<SBrick>()
  private var shouldScan = false
  private var centralManager: CBCentralManager!
  private var scanQueue = [LookupTask]()

  static let shared = SBrickSource()

  private override init() {
    super.init()
    self.centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  func lookup(_ id: String, onSuccess: @escaping (_: SBrick) -> Void) {
    if let sbrick = sbricks.first(where: { $0.id == id }) {
      onSuccess(sbrick)
      return
    }

    scanQueue.append(LookupTask(id: id, onSuccess: onSuccess, onFailure: nil))
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

extension SBrickSource: CBCentralManagerDelegate {
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

    for task in scanQueue {
      if task.id != sbrick.id { continue }
      connect(to: sbrick)
      task.onSuccess(sbrick)
    }

    scanQueue.removeAll(where: { $0.id == sbrick.id })
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
