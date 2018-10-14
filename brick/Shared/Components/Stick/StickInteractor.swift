import UIKit

class StickInteractor: ControlInteractor {
  func powerChanged(value raw: CGPoint) {
    print(raw)
    runCommand(raw: raw.x, for: .x)
    runCommand(raw: raw.y, for: .y)
  }
}
