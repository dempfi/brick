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
    for case let slider as Slider in profile.controls! {
      wireframe?.presentSlider(in: view.view, with: slider)
    }
    for case let stick as Stick in profile.controls! {
      wireframe?.presentStick(in: view.view, with: stick)
    }
  }
}
