import Foundation

public class SBrickPort {
  // swiftlint:disable type_name
  @objc public enum id: Int16 {
    case port1 = 1
    case port2 = 2
    case port3 = 3
    case port4 = 4

    var writeByte: UInt8 {
      switch self {
      case .port1: return 0x00
      case .port2: return 0x01
      case .port3: return 0x02
      case .port4: return 0x03
      }
    }
  }
}
