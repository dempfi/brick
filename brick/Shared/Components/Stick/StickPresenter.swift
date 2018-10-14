import UIKit

class StickPresenter {
  var interactor: StickInteractor
  var view: StickView? { didSet { view?.handler = interactor.powerChanged } }

  init(for control: Control) {
    interactor = StickInteractor()
    interactor.links = control.links
  }
}
