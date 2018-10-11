import UIKit

class SliderPresenter {
  var interactor: SliderInteractor
  var view: SliderView? { didSet { view?.handler = interactor.powerChanged } }

  init(for slider: Slider) {
    interactor = SliderInteractor()
    interactor.link = slider.link
  }
}
