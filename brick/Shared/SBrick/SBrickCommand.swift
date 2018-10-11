enum SBrickCommand {
  /// power is in range of -1..1
  case drive(port: SBrickPort.id, power: Float)
  case readTemperature
  case readVoltage

  var data: [UInt8] {
    switch self {
    case .drive(let port, let power):
      return [0x01, port.writeByte, power > 0 ? 0x01 : 0x00, UInt8(Int(abs(power) * 255))]
    case .readVoltage:
      return [0x0F, 0x08]
    case .readTemperature:
      return [0x0F, 0x09]
    }
  }
}
