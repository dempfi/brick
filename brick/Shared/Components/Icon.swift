import UIKit

class Icon: UIImageView {
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        tintColor = UIColor.accent
      } else {
        tintColor = UIColor.foreground
      }
    }
  }

  init(type: type) {
    super.init(image: type.image())
    self.tintColor = UIColor.foreground
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Icon {
  enum type {
    case plug
    case bin
    case add
    case chevronDown

    func image() -> UIImage? {
      switch self {
      case .plug: return UIImage(named: "Plug")
      case .bin: return UIImage(named: "Bin")
      case .add: return UIImage(named: "Add")
      case .chevronDown: return UIImage(named: "ChevronDown")
      }
    }
  }
}
