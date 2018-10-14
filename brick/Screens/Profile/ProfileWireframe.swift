import UIKit

class ProfileWireframe {
  var rootWireframe: RootWireframe?
  var presenter: ProfilePresenter?

  func presentInterface(for profile: Profile) {
    presenter = ProfilePresenter(profile: profile)
    presenter!.wireframe = self
    rootWireframe?.pushViewController(presenter!.view)
  }

  func presentSlider(in view: UIView, with control: Control) {
    rootWireframe?.sliderWireframe.presentSlider(in: view, with: control)
  }

  func presentStick(in view: UIView, with control: Control) {
    rootWireframe?.stickWireframe.presentStick(in: view, with: control)
  }
}
