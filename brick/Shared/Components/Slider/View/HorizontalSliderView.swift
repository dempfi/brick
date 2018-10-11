import UIKit
import SnapKit

class HorizontalSliderView: SliderView {
  required convenience init() {
    self.init(at: .zero)
  }

  required convenience init(at: CGPoint) {
    self.init(at: at, ratio: 1)
  }

  required init(at: CGPoint, ratio: CGFloat) {
    let size = CGSize(width: 210 * ratio, height: 70 * ratio)
    super.init(frame: CGRect(origin: at, size: size))
    self.ratio = ratio
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func draw(_ rect: CGRect) {
    drawBackground(image: UIImage(named: "HorizontalSliderBackground"))

    background.snp.makeConstraints { make in
      make.height.equalTo(self).dividedBy(3)
      make.width.equalTo(self)
      make.center.equalTo(self)
    }

    drawHandle(
      mask: UIImage(named: "SliderHandle"),
      cornerRadius: rect.height / 2,
      shadowOffset: 7 * ratio,
      shadowRadius: 7.5 * ratio
    )

    handle.snp.makeConstraints { make in
      make.height.equalTo(self)
      make.width.equalTo(self.bounds.height)
      make.center.equalTo(self)
    }
  }

  override func onTouch(at: CGPoint) {
    let distance = at.x - bounds.width / 2

    if abs(distance) <= bounds.width / 2 {
      handle.center.x = distance + bounds.width / 2
    } else {
      handle.center.x = distance <= 0 ? 0 : bounds.width
    }

    let unboundData = distance / (bounds.width / 2)
    handler?(abs(unboundData) > 1 ? min(max(unboundData, -1), 1) : unboundData)
  }
}
