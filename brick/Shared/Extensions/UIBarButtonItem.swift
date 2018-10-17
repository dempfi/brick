import UIKit

extension UIBarButtonItem {
  static func cancel(target: Any?, action: Selector) -> UIBarButtonItem {
    let button = UIButton(type: .custom)
    button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    button.layer.cornerRadius = 3
    button.addTarget(target, action: action, for: .touchUpInside)
    button.setTitle("Back", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.sizeToFit()

    return UIBarButtonItem(customView: button)
  }
}
