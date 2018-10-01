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

public class Stick: UIView {
  public var trackingHandler: ((StickData) -> Void)?
  
  private var data = StickData()
  private var isTouched = false
  private var stickView = UIImageView(frame: .zero)
  private var displayLink: CADisplayLink?
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    displayLink = CADisplayLink(target: self, selector: #selector(listen))
    displayLink?.add(to: .current, forMode: RunLoop.Mode.common)
  }
  
  @objc public func listen() {
    if isTouched {
      trackingHandler?(data)
    }
  }
  
  public override func draw(_ rect: CGRect) {
    let bgImage = UIImageView(frame: bounds)
    bgImage.image = UIImage(named: "StickBackground")
    bgImage.contentMode = UIView.ContentMode.scaleAspectFill
    insertSubview(bgImage, at: 0)
    
    let stickSize = CGSize(width: bounds.width / 1.5, height: bounds.height / 1.5)
    stickView.image = UIImage(named: "StickHandle")
    stickView.frame = CGRect(origin: .zero, size: stickSize)
    stickView.contentMode = UIView.ContentMode.scaleAspectFill
    stickView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

    if let superview = stickView.superview {
      superview.bringSubviewToFront(stickView)
    } else {
      addSubview(stickView)
    }
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    isTouched = true
    UIView.animate(withDuration: 0.1) {
      self.touchesMoved(touches, with: event)
    }
  }
  
  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    
    let location = touch.location(in: self)
    let distance = CGPoint(x: location.x - bounds.width / 2, y: location.y - bounds.height / 2)
    let magV = sqrt(pow(distance.x, 2) + pow(distance.y, 2))
    let boundsSize = bounds.width / 2
    
    if magV <= boundsSize {
      stickView.center = CGPoint(x: distance.x + bounds.width / 2, y: distance.y + bounds.height / 2)
    } else {
      let aX = distance.x / magV * boundsSize
      let aY = distance.y / magV * boundsSize
      stickView.center = CGPoint(x: aX + boundsSize, y: aY + boundsSize)
    }
    
    let x = clamp(distance.x, lower: -bounds.width / 2, upper: bounds.width / 2) / (bounds.width / 2)
    let y = clamp(distance.y, lower: -bounds.height / 2, upper: bounds.height / 2) / (bounds.height / 2)
    
    data = StickData(velocity: CGPoint(x: x, y: y), angle: -atan2(x, y) + CGFloat(Double.pi))
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    isTouched = false
    reset()
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    isTouched = false
    reset()
  }
  
  private func reset() {
    data = StickData()
    trackingHandler?(data)
    
    UIView.animate(withDuration: 0.25) {
      self.stickView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
  }
  
  private func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
  }
}
