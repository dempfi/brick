import UIKit

class RecycleBinView: UIView {
  override open var intrinsicContentSize: CGSize {
    return CGSize(width: 50, height: 50)
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor(red: 0.68, green: 0.28, blue: 0.30, alpha: 0.60).cgColor
    layer.cornerRadius = 10

    let icon = UIImageView(image: UIImage(named: "RecycleBin"))
    icon.frame = CGRect(x: 14, y: 12, width: 22, height: 27)
    addSubview(icon)
    isHidden = true
  }
}
