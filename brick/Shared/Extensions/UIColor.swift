import UIKit

extension UIColor {
  convenience init(hex: Int) {
    let red = CGFloat((hex >> 16) & 0xFF) / 255
    let green = CGFloat((hex >> 8) & 0xFF) / 255
    let blue = CGFloat(hex & 0xFF) / 255
    self.init(displayP3Red: red, green: green, blue: blue, alpha: 1)
  }

  static var background: UIColor {
    return UIColor(hex: 0x13131A)
  }

  static var foreground: UIColor {
    return UIColor(hex: 0xAAAAB3)
  }

  static var accent: UIColor {
    return UIColor(hex: 0xEC3963)
  }

  static var panel: UIColor {
    return UIColor(hex: 0x1F1F24)
  }
}
