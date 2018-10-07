import UIKit

class StickView: ControlView<CGPoint> {
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

  override func onTouch(at: CGPoint) {
    let radius = bounds.width / 2
    let location = CGPoint(x: at.x - radius, y: at.y - radius)
    let distance = sqrt(pow(location.x, 2) + pow(location.y, 2))
    var inBoundPoint = distance <= radius ? location : location / distance * radius

    handle.center = inBoundPoint + radius

    inBoundPoint.y = -inBoundPoint.y
    handler?(squared(inBoundPoint) / radius)
  }

  override func onReset() {
    handler?(.zero)
  }

  private func squared(_ point: CGPoint) -> CGPoint {
    let quarterPi = CGFloat(Double.pi / 4)
    let angle = atan2(point.y, point.x) + CGFloat(Double.pi)

    if angle <= quarterPi || angle > 7 * quarterPi {
      return point * (1 / cos(angle))
    } else if angle > quarterPi && angle <= 3 * quarterPi {
      return point * sin(angle)
    } else if angle > 3 * quarterPi && angle <= 5 * quarterPi {
      return point * (-1 / cos(angle))
    } else if angle > 5 * quarterPi && angle <= 7 * quarterPi {
      return point * (-1 / sin(angle))
    }

    return CGPoint.zero
  }
}

fileprivate extension CGPoint {
  static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
  }

  static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
  }

  static func + (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x + scalar, y: point.y + scalar)
  }
}
