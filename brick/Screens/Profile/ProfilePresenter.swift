class ProfilePresenter {
  var interactor: ProfileInteractor
  var wireframe: ProfileWireframe?
  var view: ProfileViewController
  var profile: Profile

  init(profile: Profile) {
    self.profile = profile
    interactor = ProfileInteractor(profile: profile)
    view = ProfileViewController()
    view.presenter = self
  }

  func updateView() {
    for control in profile.controls {
      if control.type == .stick {
        wireframe?.presentStick(in: view.view, with: control)
      } else {
        wireframe?.presentSlider(in: view.view, with: control)
      }
    }
  }
}
