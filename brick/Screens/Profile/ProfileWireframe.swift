import UIKit

class ProfileWireframe {
  var rootWireframe: RootWireframe?
  var presenter: ProfilePresenter?

  func presentInterface(for profile: Profile) {
    presenter = ProfilePresenter(profile: profile)
    presenter!.wireframe = self
    rootWireframe?.pushViewController(presenter!.view)
  }

  func presentSlider(in view: UIView, with slider: Slider) {
    rootWireframe?.sliderWireframe.presentSlider(in: view, with: slider)
  }

  func presentStick(in view: UIView, with stick: Stick) {
    rootWireframe?.stickWireframe.presentStick(in: view, with: stick)
  }
}
