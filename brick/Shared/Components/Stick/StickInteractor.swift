import UIKit

class StickInteractor: ControlInteractor {
  var linkX: SBrickLink? { didSet { connectX() } }
  var linkY: SBrickLink? { didSet { connectY() } }
  let sbrickSource = SBrickSource.shared
  var sbrickX: SBrick?
  var sbrickY: SBrick?
  var lastXValue: Float = 0.0
  var lastYValue: Float = 0.0

  func connectX() {
    sbrickSource.lookup(linkX!.id, onSuccess: { self.sbrickX = $0 })
  }

  func connectY() {
    sbrickSource.lookup(linkY!.id, onSuccess: { self.sbrickY = $0 })
  }

  func powerChanged(value raw: CGPoint) {
    runXCommand(value: raw.x)
    runYCommand(value: raw.y)
  }

  func runXCommand(value raw: CGFloat) {
    let value = toPowerValue(raw: raw)
    guard value != lastXValue else { return }
    guard let (_, port) = linkX else { return }
    sbrickX?.exec(command: powerToCommand(value: value, for: port))
    lastXValue = value
  }

  func runYCommand(value raw: CGFloat) {
    let value = toPowerValue(raw: raw)
    guard value != lastYValue else { return }
    guard let (_, port) = linkY else { return }
    sbrickY?.exec(command: powerToCommand(value: value, for: port))
    lastYValue = value
  }
}
