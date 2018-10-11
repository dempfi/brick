import UIKit

class AddProfileWireframe {
  var rootWireframe: RootWireframe?
  var presenter: AddProfilePresenter?
  var navigationController: UINavigationController?
  var presentedViewController: UIViewController?

  func presentInterface(in viewController: UIViewController) {
    presenter = AddProfilePresenter()
    presenter!.wireframe = self
    configureNavigationContoller(root: presenter!.view)
    viewController.present(navigationController!, animated: true, completion: nil)
    presentedViewController = presenter!.view
  }

  func dismissInterface() {
    presentedViewController?.dismiss(animated: true, completion: nil)
  }

  func configureNavigationContoller(root: UIViewController) {
    navigationController = UINavigationController(rootViewController: root)
  }
}
