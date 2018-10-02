import UIKit

class Trash: UIView {
  private let activeColor = UIColor(red:0.68, green:0.28, blue:0.30, alpha:0.60).cgColor
  private let trash = UIImageView(image: UIImage(named: "Trash"))

  override open var intrinsicContentSize: CGSize {
    get {
      return CGSize(width: 50, height: 50)
    }
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor(red:0.68, green:0.28, blue:0.30, alpha:0.60).cgColor
    layer.cornerRadius = 10

    let trash = UIImageView(image: UIImage(named: "Trash"))
    trash.frame = CGRect(x: 15, y: 11, width: 20, height: 28)
    addSubview(trash)
    isHidden = true
  }
}
