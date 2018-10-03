import UIKit
import SnapKit

class HorizontalSliderView: UIView {
  public var handler: ((CGFloat) -> Void)?
  public var color = Colors.silver
  private var handleView = UIImageView(frame: .zero)

  public convenience init() {
    self.init(at: .zero)
  }

  public init(at: CGPoint) {
    super.init(frame: CGRect(origin: at, size: CGSize(width: 210, height: 70)))
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func draw(_ rect: CGRect) {
    let background = UIImageView()
    insertSubview(background, at: 0)
    background.image = UIImage(named: "HorizontalSliderBackground")
    background.contentMode = UIView.ContentMode.scaleAspectFill
    background.snp.makeConstraints { (make) -> Void in
      make.height.equalTo(self).dividedBy(3)
      make.width.equalTo(self)
      make.center.equalTo(self)
    }

    handleView.image = UIImage(named: "SliderHandle")
    handleView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.height, height: bounds.height))
    handleView.contentMode = UIView.ContentMode.scaleAspectFill
    handleView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    handleView.layer.cornerRadius = bounds.height / 2
    handleView.layer.masksToBounds = false
    handleView.layer.backgroundColor = color.cgColor
    handleView.layer.shadowOffset = CGSize(width: 0, height: 7)
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
    UIView.animate(withDuration: 0.1) {
      self.touchesMoved(touches, with: event)
    }
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return }
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)
    let distance = location.x - bounds.width / 2

    if abs(distance) <= bounds.width / 2 {
      handleView.center.x = distance + bounds.width / 2
    } else {
      handleView.center.x = distance <= 0 ? 0 : bounds.width
    }

    let unboundData = distance / (bounds.width / 2)
    handler?(abs(unboundData) > 1 ? min(max(unboundData, -1), 1) : unboundData)
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    reset()
  }

  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    reset()
  }

  private func reset() {
    UIView.animate(withDuration: 0.25) {
      self.handleView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
  }
}
