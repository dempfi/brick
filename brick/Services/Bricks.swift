import Foundation
import SBrick
import CoreBluetooth

class Bricks: SBrickManagerDelegate {
    var bricks: [SBrick] = []
    var manager: SBrickManager!
    
    init () {
        self.manager = SBrickManager(delegate: self)
    }
    
    func scan() {
        manager.startDiscovery()
    }
    
    func sbrickManager(_ sbrickManager: SBrickManager, didDiscover sbrick: SBrick) {
        self.bricks.append(sbrick)
    }
    
    func sbrickManager(_ sbrickManager: SBrickManager, didUpdateBluetoothState bluetoothState: CBManagerState) {
        // TODO
    }
}
