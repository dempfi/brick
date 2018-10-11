import UIKit

class ProfilesWireframe {
  var rootWireframe: RootWireframe?
  var profileWireframe = ProfileWireframe()
  var presenter: ProfilesPresenter?

  func presentInterface() {
    presenter = ProfilesPresenter()
    presenter!.wireframe = self
    rootWireframe?.showRootViewController(presenter!.view)
  }

  func presentAddProfile(in view: UIViewController) {
    rootWireframe?.addProfileWireframe.presentInterface(in: view)
  }

  func presentProfile(with profile: Profile, in view: UIViewController) {
    rootWireframe?.profileWireframe.presentInterface(for: profile)
  }
}
