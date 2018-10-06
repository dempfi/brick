import Foundation

struct ManufacturerData {
  private(set) var productId: UInt8 = 0
  private(set) var hardwareVersion: String = ""
  private(set) var firmwareVersion: String = ""
  private(set) var deviceId: String = ""
  private(set) var isSecured: Bool = false

  init?(from rawData: Data) {
    let data = [UInt8](rawData)
    guard data.count > 2 && data[0] == 152 && data[1] == 1 else { return nil }

    var sectionFirstIndex: Int = 2
    var sectionLastIndex: Int = 0
    var sectionBytes = [UInt8]()

    for index in 2..<data.count {
      if index == sectionFirstIndex {
        sectionLastIndex = index + Int(data[index])
      } else if index == sectionLastIndex {
        sectionBytes.append(data[index])
        if sectionBytes.count > 0 { parse(section: sectionBytes) }
        sectionBytes = []
        sectionFirstIndex = index + 1
      } else {
        sectionBytes.append(data[index])
      }
    }
  }

  private mutating func parse(section: [UInt8]) {
    let typeIdentifier = section[0]
    var bytes = section
    bytes.remove(at: 0)

    switch typeIdentifier {
    case 0:
      if bytes.count > 0 { self.productId = bytes[0] }
      if bytes.count >= 3 { self.hardwareVersion = "\(bytes[1]).\(bytes[2])" }
      if bytes.count >= 5 { self.firmwareVersion = "\(bytes[3]).\(bytes[4])" }

    case 2:
      for byte in bytes {
        if deviceId.count > 0 { self.deviceId += ":" }
        self.deviceId += String(format: "%2X", byte)
      }

    case 3:
      if bytes.count <= 0 { break }
      self.isSecured = (bytes[0] != 0)

    default: break
    }
  }
}
