enum SBrickCommand {
  /// power is in range of -1..1
  case drive(port: SBrickPort, power: Float)
  case readTemperature
  case readVoltage

  var data: [UInt8] {
    switch self {
    case .drive(let port, let power):
      return [0x01, port.writeChannel, power > 0 ? 0x01 : 0x00, UInt8(Int(abs(power) * 255))]
    case .readVoltage:
      return [0x0F, 0x08]
    case .readTemperature:
      return [0x0F, 0x09]
    }
  }
}

enum SBrickPort {
  case port1, port2, port3, port4

  var writeChannel: UInt8 {
    switch self {
    case .port1: return 0x00
    case .port2: return 0x01
    case .port3: return 0x02
    case .port4: return 0x03
    }
  }
}
