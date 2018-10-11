import CoreBluetooth

enum SBrickCommandStatus {
  case success
  case invalidDataLenght
  case invalidParameter
  case unknownCommand
  case noAuthNeeded
  case authError
  case authNeeded
  case thermalProtection
  case undefinedState
}

enum SBrickPayload {
  case product(type: String, hardware: String?, firmware: String?)
  case secured(Bool)
  case device(id: String)
  case command(status: SBrickCommandStatus, value: [UInt8])
}

extension SBrickPayload {
  static func parse(advertisementData: Data) -> [SBrickPayload]? {
    let data = [UInt8](advertisementData)
    guard data.count > 2 && data[0] == 152 && data[1] == 1 else { return nil }
    return self.parse(raw: data.drop(2))
  }

  static func parse(raw: [UInt8]) -> [SBrickPayload] {
    var recordStart: Int = 0
    var recordEnd: Int = 0
    var records = [SBrickPayload]()
    var record = [UInt8]()

    for index in 0..<raw.count {
      if index == recordStart {
        recordEnd = recordStart + Int(raw[index])
      } else if index == recordEnd {
        record.append(raw[index])
        if let parsed = parse(record: record) {
          records.append(parsed)
        }
        record.removeAll()
        recordStart = index + 1
      } else {
        record.append(raw[index])
      }
    }
    return records
  }

  // swiftlint:disable cyclomatic_complexity
  private static func parse(record rawRecord: [UInt8]) -> SBrickPayload? {
    var record = rawRecord
    let type = record.remove(at: 0)

    switch type {
    case 0:
      return .product(
        type: record[0] == 0 ? "SBrick" : "Unknown",
        hardware: record.count >= 3 ? "\(record[1]).\(record[2])" : nil,
        firmware: record.count >= 5 ? "\(record[3]).\(record[4])" : nil
      )

    case 2:
      var id = ""
      for byte in record {
        if id.count > 0 { id += ":" }
        id += String(format: "%2X", byte)
      }
      return .device(id: id)

    case 3:
      return .secured(record[0] != 0)

    case 4:
      let statusCode = record.remove(at: 0)
      var status: SBrickCommandStatus!
      switch statusCode {
      case 0x00: status = .success
      case 0x01: status = .invalidDataLenght
      case 0x02: status = .invalidParameter
      case 0x03: status = .unknownCommand
      case 0x04: status = .noAuthNeeded
      case 0x05: status = .authError
      case 0x06: status = .authNeeded
      case 0x08: status = .thermalProtection
      case 0x09: status = .undefinedState
      default: break
      }
      return .command(status: status, value: record)

    default: return nil
    }
  }
}

extension Array {
  func drop(_ count: Int) -> [Element] {
    var cleaned: [Element] = []
    for index in count..<self.count {
      cleaned.append(self[index])
    }
    return cleaned
  }

  func split(after: Int) -> ([Element], [Element]) {
    var left: [Element] = []
    var right: [Element] = []
    for index in 0..<self.count {
      if index > after {
        right.append(self[index])
      } else {
        left.append(self[index])
      }
    }
    return (left, right)
  }
}
