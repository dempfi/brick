import UIKit

class SliderWireframe {
  var presenter: SliderPresenter?

  func presentSlider(in view: UIView, with slider: Slider) {
    presenter = SliderPresenter(for: slider)
    switch slider.type {
    case .horizontalSlider: presenter!.view = HorizontalSliderView(at: slider.origin)
    case .verticalSlider: presenter!.view = VerticalSliderView(at: slider.origin)
    default: break
    }
    view.addSubview(presenter!.view!)
  }
}
