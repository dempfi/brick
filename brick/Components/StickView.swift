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

public class StickView: UIView {
  public var handler: ((StickData) -> Void)?
  public var color = Colors.silver
  private var handleView = UIImageView(frame: .zero)
  private var ratio: CGFloat = 1

  public convenience init() {
    self.init(at: .zero)
  }

  public convenience init(at: CGPoint) {
    self.init(at: at, ratio: 1)
  }

  public init(at: CGPoint, ratio: CGFloat) {
    let size = CGSize(width: 150 * ratio, height: 150 * ratio)
    super.init(frame: CGRect(origin: at, size: size))
    self.ratio = ratio
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func draw(_ rect: CGRect) {
    let background = UIImageView(frame: rect)
    background.image = UIImage(named: "StickBackground")
    background.contentMode = UIView.ContentMode.scaleAspectFill
    insertSubview(background, at: 0)

    let handleSize = floor(rect.width / 1.5)
    handleView.image = UIImage(named: "StickHandle")
    handleView.frame = CGRect(origin: .zero, size: CGSize(width: handleSize, height: handleSize))
    handleView.contentMode = UIView.ContentMode.scaleAspectFill
    handleView.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
    handleView.layer.cornerRadius = handleSize / 2
    handleView.layer.masksToBounds = false
    handleView.layer.backgroundColor = color.cgColor
    handleView.layer.shadowOffset = CGSize(width: 0, height: 10 * ratio)
    handleView.layer.shadowColor = UIColor.black.cgColor
    handleView.layer.shadowRadius = 10 * ratio
    handleView.layer.shadowOpacity = 1

    if let superview = handleView.superview {
      superview.bringSubviewToFront(handleView)
    } else {
      addSubview(handleView)
    }
  }

  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesBegan(touches, with: event) }
    UIView.animate(withDuration: 0.1) {
      self.touchesMoved(touches, with: event)
    }
  }

  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesMoved(touches, with: event) }
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)
    let distance = CGPoint(x: location.x - bounds.width / 2, y: location.y - bounds.height / 2)
    let magV = sqrt(pow(distance.x, 2) + pow(distance.y, 2))
    let boundsSize = bounds.width / 2

    if magV <= boundsSize {
      handleView.center = CGPoint(x: distance.x + bounds.width / 2, y: distance.y + bounds.height / 2)
    } else {
      let x = distance.x / magV * boundsSize
      let y = distance.y / magV * boundsSize
      handleView.center = CGPoint(x: x + boundsSize, y: y + boundsSize)
    }

    let x = clamp(distance.x, lower: -bounds.width / 2, upper: bounds.width / 2) / (bounds.width / 2)
    let y = clamp(distance.y, lower: -bounds.height / 2, upper: bounds.height / 2) / (bounds.height / 2)

    handler?(StickData(velocity: CGPoint(x: x, y: -y), angle: -atan2(x, y) + CGFloat(Double.pi)))
  }

  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesEnded(touches, with: event) }
    reset()
  }

  override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesCancelled(touches, with: event) }
    reset()
  }

  private func reset() {
    UIView.animate(withDuration: 0.25) {
      self.handleView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
  }

  private func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
  }
}
