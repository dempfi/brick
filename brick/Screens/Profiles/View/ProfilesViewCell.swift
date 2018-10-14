import Foundation
import UIKit

class ProfilesViewCell: UICollectionViewCell {
  var ratio: CGFloat = 1
  var margins: CGPoint = .zero

  var profile: Profile! {
    didSet {
      if oldValue != profile { redraw() }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundView = UIImageView(image: UIImage(named: "CellBackground"))
    let screen = UIScreen.main.bounds
    ratio = min(frame.width / screen.width, frame.height / screen.height)
    let xMargin = (frame.width - ratio * screen.width) / 2
    let yMargin = (frame.height - ratio * screen.height) / 2
    margins = CGPoint(x: xMargin, y: yMargin)
  }

  required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
  }

  public func redraw() {
    contentView.subviews.forEach { $0.removeFromSuperview() }

    for control in profile.controls {
      var view: UIView!
      let origin = control.origin * ratio + margins

      switch control.type {
      case .stick:
        view = StickView(at: origin, ratio: ratio)
      case .verticalSlider:
        view = VerticalSliderView(at: origin, ratio: ratio)
      case .horizontalSlider:
        view = HorizontalSliderView(at: origin, ratio: ratio)
      }

      contentView.addSubview(view)
    }
  }
}
