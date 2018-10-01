import UIKit

class AddProfileNavigation: NSObject {
  static var controller: UINavigationController!

  static func setup(cancelTarget: Any, cancelHandler: Selector) {
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: cancelTarget, action: cancelHandler)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    controller = UINavigationController(rootViewController: AddProfileViewController())
    controller.navigationBar.topItem?.leftBarButtonItem = cancelButton
    controller.navigationBar.topItem?.rightBarButtonItem = doneButton
  }
}
