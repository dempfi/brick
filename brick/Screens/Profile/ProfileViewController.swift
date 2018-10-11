import UIKit

class ProfileViewController: UIViewController {
  var presenter: ProfilePresenter?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.updateView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.background
  }
}
