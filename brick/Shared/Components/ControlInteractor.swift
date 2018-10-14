import UIKit

class ControlInteractor {
  let sbrickSource = SBrickSource.shared
  var links: Set<Link>? { didSet { connect() } }
  var sbricks: [String: SBrick] = [:]
  var lastValues: [Link.axis: Float] = [
    Link.axis.universal: 0,
    Link.axis.x: 0,
    Link.axis.y: 0
  ]

  func runCommand(raw: CGFloat, for axis: Link.axis) {
    let value = toPowerValue(raw: raw)
    guard value != lastValues[axis]! else { return }
    lastValues[axis] = value
    links?
      .filter { $0.axis == axis }
      .forEach {
        let sbrick = sbricks[$0.sbrick]
        let command = powerToCommand(value: value, for: $0.port)
        sbrick?.exec(command: command)
    }
  }

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

  func connect() {
    links?.forEach { link in
      self.sbrickSource.lookup(link.sbrick)
        .then { self.sbricks[link.sbrick] = $0 }
    }
  }
}
