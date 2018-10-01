import UIKit

class RootNavigation: NSObject {
  static let controller = UINavigationController()

  static func setupProfiles() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddProfile))
    controller.pushViewController(ProfilesViewController(), animated: true)
    controller.navigationBar.topItem?.rightBarButtonItem = addButton
  }

  @objc static func presentAddProfile() {
    AddProfileNavigation.setup(cancelTarget: self, cancelHandler: #selector(dismissModal))
    controller.present(AddProfileNavigation.controller, animated: true, completion: nil)
  }

  @objc static func dismissModal() {
    controller.dismiss(animated: true, completion: nil)
  }
}
