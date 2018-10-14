import UIKit

class ProfilesPresenter {
  let interactor = ProfilesInteractor()
  var wireframe: ProfilesWireframe?
  var view: ProfilesViewController

  init() {
    view = ProfilesViewController()
    view.presenter = self
  }

  func updateView() {
    interactor.fetchProfiles().then(view.showProfiles)
  }

  func addProfile() {
    wireframe?.presentAddProfile(in: view)
  }

  func showProfile(profile: Profile) {
    wireframe?.presentProfile(with: profile, in: view)
  }
}
