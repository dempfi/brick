import UIKit

class StickPresenter {
  var interactor: StickInteractor
  var view: StickView? { didSet { view?.handler = interactor.powerChanged } }

  init(for stick: Stick) {
    interactor = StickInteractor()
    interactor.linkY = stick.linkY
    interactor.linkX = stick.linkX
  }
}
