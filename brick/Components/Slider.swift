import UIKit
import SnapKit

class Slider: UIView {
  public var trackingHandler: ((CGFloat) -> Void)?

  private var isTouched = false
  private var handleView = UIImageView(frame: .zero)
  private var displayLink: CADisplayLink?
  private var data: CGFloat = 0.0

  public convenience init(x: Int, y: Int, size: Int) {
    self.init(frame: CGRect(x: x, y: y, width: size / 3, height: size))
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
    let background = UIImageView()
    insertSubview(background, at: 0)
    background.image = UIImage(named: "SliderBackground")
    background.contentMode = UIView.ContentMode.scaleAspectFill
    background.snp.makeConstraints { (make) -> Void in
      make.height.equalTo(self)
      make.width.equalTo(self).dividedBy(3)
      make.center.equalTo(self)
    }

    let handleSize = CGSize(width: bounds.width, height: bounds.width)
    handleView.image = UIImage(named: "SliderHandle")
    handleView.frame = CGRect(origin: .zero, size: handleSize)
    handleView.contentMode = UIView.ContentMode.scaleAspectFill
    handleView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

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
    let distance = location.y - bounds.height / 2

    if abs(distance) <= bounds.height / 2 {
      handleView.center.y = distance + bounds.height / 2
    } else {
      handleView.center.y = distance <= 0 ? 0 : bounds.height
    }

    let unboundData = -distance / (bounds.height / 2)
    data = abs(unboundData) > 1 ? max(min(unboundData, -1), 1) : unboundData
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
    trackingHandler?(data)

    UIView.animate(withDuration: 0.25) {
      self.handleView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
  }
}
