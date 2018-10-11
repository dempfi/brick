import UIKit

class ControlInteractor {
  func toPowerValue(raw: CGFloat) -> Float {
    return Float((raw * 100).rounded() / 100)
  }

  func powerToCommand(value: Float, for port: SBrickPort.id) -> SBrickCommand {
    if abs(value) <= 0.2 {
      return .stop(port: port)
    } else {
      return .drive(port: port, power: value)
    }
  }
}
