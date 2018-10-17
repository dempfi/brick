import UIKit

class SliderInteractor: ControlInteractor {
  func powerChanged(value raw: CGFloat) {
    runCommand(raw: raw, for: .universal)
  }
}
