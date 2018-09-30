import Foundation
import UIKit

class ProfileCellView: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    customiseSelf()
  }
  
  required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
  }
  
  private func customiseSelf() {
    backgroundColor = UIColor(red:0.13, green:0.15, blue:0.20, alpha:1.00)
    layer.cornerRadius = 10
  }
}
