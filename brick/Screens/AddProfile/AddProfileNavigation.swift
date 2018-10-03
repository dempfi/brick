import UIKit

class AddProfileNavigation: NSObject {
  static var controller: UINavigationController!

  static func setup(cancelTarget: Any, cancelHandler: Selector) {
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: cancelTarget, action: cancelHandler)
    controller = UINavigationController(rootViewController: AddProfileViewController())
    controller.extendedLayoutIncludesOpaqueBars = false
    controller.navigationBar.topItem?.leftBarButtonItem = cancelButton
  }
}
