import UIKit

class SliderWireframe {
  var presenter: SliderPresenter?

  func presentSlider(in view: UIView, with control: Control) {
    presenter = SliderPresenter(for: control)
    switch control.type {
    case .horizontalSlider: presenter!.view = HorizontalSliderView(at: control.origin)
    case .verticalSlider: presenter!.view = VerticalSliderView(at: control.origin)
    default: break
    }
    view.addSubview(presenter!.view!)
  }
}
