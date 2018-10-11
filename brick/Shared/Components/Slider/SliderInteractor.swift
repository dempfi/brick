import UIKit

class SliderInteractor: ControlInteractor {
  var sbrick: SBrick?
  var lastValue: Float = 0.0
  var link: SBrickLink? { didSet { connect() } }
  let sbrickSource = SBrickSource.shared

  func connect() {
    sbrickSource.lookup(link!.id, onSuccess: { self.sbrick = $0 })
  }

  func powerChanged(value raw: CGFloat) {
    let value = toPowerValue(raw: raw)
    guard value != lastValue else { return }
    guard let (_, port) = link else { return }
    sbrick?.exec(command: powerToCommand(value: value, for: port))
    lastValue = value
  }
}
