import UIKit

class SliderView: ControlView<CGFloat> {
  override func onReset() {
    handler?(0)
  }
}
