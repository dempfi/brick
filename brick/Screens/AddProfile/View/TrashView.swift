import UIKit
import SnapKit

class TrashView: UIView {
  override open var intrinsicContentSize: CGSize {
    return CGSize(width: 50, height: 50)
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor.accent.withAlphaComponent(0.2).cgColor
    layer.borderColor = UIColor.accent.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 10

    let icon = Icon(type: .bin)
    icon.isHighlighted = true
    addSubview(icon)
    icon.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    alpha = 0
  }

  func reveal() {
    UIView.animate(withDuration: 0.2, animations: {
      self.alpha = 1
    })
  }

  func hide() {
    UIView.animate(withDuration: 0.2, animations: {
      self.alpha = 0
    })
  }
}
