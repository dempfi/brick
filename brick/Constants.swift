import Foundation
import UIKit

struct Colors {
  static let bg = UIColor.black
  static let silver = UIColor(red:0.95, green:0.98, blue:1.00, alpha:1.00)
  static let accent = UIColor(red:0.56, green:0.69, blue:0.21, alpha:1.00)
}

enum ControlType: Int16 {
  case stick = 1
  case horizontalSlider = 2
  case verticalSlider = 3
}
