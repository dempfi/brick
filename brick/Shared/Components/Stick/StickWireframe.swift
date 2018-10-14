import UIKit

class StickWireframe {
  var presenter: StickPresenter?

  func presentStick(in view: UIView, with control: Control) {
    presenter = StickPresenter(for: control)
    presenter!.view = StickView(at: control.origin)
    view.addSubview(presenter!.view!)
  }
}
