import UIKit

class Navigation: NSObject {
  static let controller: UINavigationController = {
    let controller = UINavigationController()
    controller.navigationBar.isTranslucent = false
    controller.navigationBar.shadowImage = UIImage()
    controller.navigationBar.barStyle = .black
    controller.modalTransitionStyle = .coverVertical
    return controller
  }()

  static func setupProfiles() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddProfile))
    addButton.tintColor = UIColor(red: 0.94, green: 0.53, blue: 0.31, alpha: 1.00)
    controller.pushViewController(ProfilesViewController(), animated: true)
    controller.navigationBar.topItem?.rightBarButtonItem = addButton
  }

  @objc static func presentAddProfile() {
    let addProfileNavigation = UINavigationController(rootViewController: AddProfileViewController())
    addProfileNavigation.navigationBar.isTranslucent = false
    addProfileNavigation.navigationBar.barStyle = .black
    controller.present(addProfileNavigation, animated: true, completion: nil)
  }
}
