import UIKit

class RootWireframe {
  var profileWireframe: ProfileWireframe
  var profilesWireframe: ProfilesWireframe
  var addProfileWireframe: AddProfileWireframe
  var sliderWireframe: SliderWireframe
  var stickWireframe: StickWireframe
  var navigationController: UINavigationController?

  init() {
    profileWireframe = ProfileWireframe()
    profilesWireframe = ProfilesWireframe()
    addProfileWireframe = AddProfileWireframe()
    sliderWireframe = SliderWireframe()
    stickWireframe = StickWireframe()
    profileWireframe.rootWireframe = self
    profilesWireframe.rootWireframe = self
    addProfileWireframe.rootWireframe = self
  }

  func showRootViewController(_ viewController: UIViewController) {
    navigationController?.viewControllers = [viewController]
  }

  func pushViewController(_ viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }
}
