import UIKit

class SliderPresenter {
  var interactor: SliderInteractor
  var view: SliderView? { didSet { view?.handler = interactor.powerChanged } }

  init(for control: Control) {
    interactor = SliderInteractor()
    interactor.links = control.links
  }
}
