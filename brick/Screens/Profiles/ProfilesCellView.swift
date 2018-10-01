import Foundation
import UIKit

class ProfilesCellView: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    addBackground()
  }
  
  required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
  }
  
  private func addBackground() {
    let bg = UIImage(named: "CellBackground")
    backgroundView = UIImageView(image: bg)
  }
}
