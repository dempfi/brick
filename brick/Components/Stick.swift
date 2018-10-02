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
  public var color = Colors.silver

  private var data = StickData()
  private var isTouched = false
  private var handleView = UIImageView(frame: .zero)
  private var displayLink: CADisplayLink?

  public convenience init(x: Int, y: Int, size: Int) {
    self.init(frame: CGRect(x: x, y: y, width: size, height: size))
  }

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
    let background = UIImageView(frame: bounds)
    background.image = UIImage(named: "StickBackground")
    background.contentMode = UIView.ContentMode.scaleAspectFill
    insertSubview(background, at: 0)
    layer.cornerRadius = bounds.width / 2
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.white.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowRadius = 20

    let handleSize = floor(bounds.width / 1.5)
    handleView.image = UIImage(named: "StickHandle")
    handleView.frame = CGRect(origin: .zero, size: CGSize(width: handleSize, height: handleSize))
    handleView.contentMode = UIView.ContentMode.scaleAspectFill
    handleView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    handleView.layer.cornerRadius = handleSize / 2
    handleView.layer.masksToBounds = false
    handleView.layer.backgroundColor = color.cgColor
    handleView.layer.shadowOffset = CGSize(width: 0, height: 20)
    handleView.layer.shadowColor = UIColor.black.cgColor
    handleView.layer.shadowRadius = 10
    handleView.layer.shadowOpacity = 1

    if let superview = handleView.superview {
      superview.bringSubviewToFront(handleView)
    } else {
      addSubview(handleView)
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
      handleView.center = CGPoint(x: distance.x + bounds.width / 2, y: distance.y + bounds.height / 2)
    } else {
      let aX = distance.x / magV * boundsSize
      let aY = distance.y / magV * boundsSize
      handleView.center = CGPoint(x: aX + boundsSize, y: aY + boundsSize)
    }
    
    let x = clamp(distance.x, lower: -bounds.width / 2, upper: bounds.width / 2) / (bounds.width / 2)
    let y = clamp(distance.y, lower: -bounds.height / 2, upper: bounds.height / 2) / (bounds.height / 2)
    
    data = StickData(velocity: CGPoint(x: x, y: -y), angle: -atan2(x, y) + CGFloat(Double.pi))
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
      self.handleView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
  }
  
  private func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
  }
}
