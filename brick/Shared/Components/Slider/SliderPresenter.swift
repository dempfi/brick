import UIKit

class SliderPresenter {
  var interactor: SliderInteractor
  var view: SliderView? { didSet { view?.handler = powerChanged } }

  init(for slider: Slider) {
    interactor = SliderInteractor()
    interactor.link = slider.link
  }

  func powerChanged(value: CGFloat) {
    print(value)
  }
}
