import UIKit

class StickPresenter {
  var interactor: StickInteractor
  var view: StickView? { didSet { view?.handler = powerChanged } }

  init(for stick: Stick) {
    interactor = StickInteractor()
    interactor.linkX = stick.linkX
    interactor.linkY = stick.linkY
  }

  func powerChanged(value: CGPoint) {
    print(value)
  }
}
