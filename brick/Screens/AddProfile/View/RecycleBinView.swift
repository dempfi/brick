import UIKit

class RecycleBinView: UIView {
  override open var intrinsicContentSize: CGSize {
    return CGSize(width: 50, height: 50)
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor(red: 0.40, green: 0.14, blue: 0.14, alpha: 1.00).cgColor
    layer.cornerRadius = 10

    let icon = UIImageView(image: UIImage(named: "RecycleBin"))
    icon.frame = CGRect(x: 14, y: 12, width: 22, height: 27)
    addSubview(icon)
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
