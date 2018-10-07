import UIKit

class SliderController {
//  private var port: SBrickPort!
  private var view: SliderView!

  init(from control: Slider, sbrick: SBrick) {
//    self.port = control.port

    switch control.type {
    case .horizontalSlider:
      self.view = HorizontalSliderView(at: control.origin)
    case .verticalSlider:
      self.view = VerticalSliderView(at: control.origin)
    default: break
    }
    self.view.handler = onChange
  }

  private func onChange(value: CGFloat) {
    print(value)
  }
}
