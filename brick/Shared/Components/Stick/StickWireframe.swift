import UIKit

class StickWireframe {
  var presenter: StickPresenter?

  func presentStick(in view: UIView, with stick: Stick) {
    presenter = StickPresenter(for: stick)
    presenter!.view = StickView(at: stick.origin)
    view.addSubview(presenter!.view!)
  }
}
