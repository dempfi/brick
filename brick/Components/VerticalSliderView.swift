import UIKit
import SnapKit

class VerticalSliderView: ControlView<CGFloat> {
  required convenience init() {
    self.init(at: .zero)
  }

  required convenience init(at: CGPoint) {
    self.init(at: at, ratio: 1)
  }

  required init(at: CGPoint, ratio: CGFloat) {
    let size = CGSize(width: 70 * ratio, height: 210 * ratio)
    super.init(frame: CGRect(origin: at, size: size))
    self.ratio = ratio
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func draw(_ rect: CGRect) {
    drawBackground(image: UIImage(named: "VerticalSliderBackground"))

    background.snp.makeConstraints { make in
      make.height.equalTo(self)
      make.width.equalTo(self).dividedBy(3)
      make.center.equalTo(self)
    }

    drawHandle(
      mask: UIImage(named: "SliderHandle"),
      cornerRadius: rect.width / 2,
      shadowOffset: 7 * ratio,
      shadowRadius: 7.5 * ratio
    )

    handle.snp.makeConstraints { make in
      make.height.equalTo(self.bounds.width)
      make.width.equalTo(self)
      make.center.equalTo(self)
    }
  }

  override func onTouch(at: CGPoint) {
    let distance = at.y - bounds.height / 2

    if abs(distance) <= bounds.height / 2 {
      handle.center.y = distance + bounds.height / 2
    } else {
      handle.center.y = distance <= 0 ? 0 : bounds.height
    }

    let unboundData = -distance / (bounds.height / 2)
    handler?(abs(unboundData) > 1 ? min(max(unboundData, -1), 1) : unboundData)
  }

  override func onReset() {
    handler?(0)
  }
}
