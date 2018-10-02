import UIKit

enum ControlType {
  case slider
  case stick
}

class ControlSelector: UIView {
  public var handler: ((ControlType) -> Void)?

  convenience init(x: Int, y: Int) {
//    statements
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func draw(_ rect: CGRect) {
//    let
  }
}
