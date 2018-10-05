import UIKit

public struct StickData: CustomStringConvertible {
  // (-1.0, -1.0) at bottom left to (1.0, 1.0) at top right
  public var velocity: CGPoint = .zero

  // 0 at top middle to 6.28 radians going around clockwise
  public var angle: CGFloat = 0.0

  public var description: String {
    return "velocity: \(velocity), angle: \(angle)"
  }
}

class StickView: ControlView<StickData> {
  required convenience init() {
    self.init(at: .zero)
  }

  required convenience init(at: CGPoint) {
    self.init(at: at, ratio: 1)
  }

  required init(at: CGPoint, ratio: CGFloat) {
    let size = CGSize(width: 150 * ratio, height: 150 * ratio)
    super.init(frame: CGRect(origin: at, size: size))
    self.ratio = ratio
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func draw(_ rect: CGRect) {
    drawBackground(image: UIImage(named: "StickBackground"))

    background.snp.makeConstraints { make in
      make.height.equalTo(self)
      make.width.equalTo(self)
      make.center.equalTo(self)
    }

    drawHandle(
      mask: UIImage(named: "StickHandle"),
      cornerRadius: rect.width / 3,
      shadowOffset: 10 * ratio,
      shadowRadius: 10 * ratio
    )

    handle.snp.makeConstraints { make in
      make.height.equalTo(self).dividedBy(1.5)
      make.width.equalTo(self).dividedBy(1.5)
      make.center.equalTo(self)
    }
  }

  override func onTouch(location: CGPoint) {
    let distance = CGPoint(x: location.x - bounds.width / 2, y: location.y - bounds.height / 2)
    let magV = sqrt(pow(distance.x, 2) + pow(distance.y, 2))
    let boundsSize = bounds.width / 2

    if magV <= boundsSize {
      handle.center = CGPoint(x: distance.x + bounds.width / 2, y: distance.y + bounds.height / 2)
    } else {
      let x = distance.x / magV * boundsSize
      let y = distance.y / magV * boundsSize
      handle.center = CGPoint(x: x + boundsSize, y: y + boundsSize)
    }

    let x = clamp(distance.x, lower: -bounds.width / 2, upper: bounds.width / 2) / (bounds.width / 2)
    let y = clamp(distance.y, lower: -bounds.height / 2, upper: bounds.height / 2) / (bounds.height / 2)

    handler?(StickData(velocity: CGPoint(x: x, y: -y), angle: -atan2(x, y) + CGFloat(Double.pi)))
  }

  private func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
  }
}
