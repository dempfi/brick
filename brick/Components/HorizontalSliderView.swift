import UIKit
import SnapKit

class HorizontalSliderView: UIView {
  public var handler: ((CGFloat) -> Void)?
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
    let size = CGSize(width: 210 * ratio, height: 70 * ratio)
    super.init(frame: CGRect(origin: at, size: size))
    self.ratio = ratio
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func draw(_ rect: CGRect) {
    let background = UIImageView()
    insertSubview(background, at: 0)
    background.image = UIImage(named: "HorizontalSliderBackground")
    background.contentMode = UIView.ContentMode.scaleAspectFill
    background.snp.makeConstraints { make in
      make.height.equalTo(self).dividedBy(3)
      make.width.equalTo(self)
      make.center.equalTo(self)
    }

    handleView.image = UIImage(named: "SliderHandle")
    handleView.frame = CGRect(origin: .zero, size: CGSize(width: rect.height, height: rect.height))
    handleView.contentMode = UIView.ContentMode.scaleAspectFill
    handleView.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
    handleView.layer.cornerRadius = rect.height / 2
    handleView.layer.masksToBounds = false
    handleView.layer.backgroundColor = color.cgColor
    handleView.layer.shadowOffset = CGSize(width: 0, height: 7 * ratio)
    handleView.layer.shadowColor = UIColor.black.cgColor
    handleView.layer.shadowRadius = 7.5 * ratio
    handleView.layer.shadowOpacity = 1

    if let superview = handleView.superview {
      superview.bringSubviewToFront(handleView)
    } else {
      addSubview(handleView)
    }
  }

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesBegan(touches, with: event) }
    UIView.animate(withDuration: 0.1) {
      self.touchesMoved(touches, with: event)
    }
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesMoved(touches, with: event) }
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
    if handler == nil { return super.touchesEnded(touches, with: event) }
    reset()
  }

  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if handler == nil { return super.touchesCancelled(touches, with: event) }
    reset()
  }

  private func reset() {
    UIView.animate(withDuration: 0.25) {
      self.handleView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
  }
}
