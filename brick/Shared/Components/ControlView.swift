import UIKit

class ControlView<T>: UIView {
  var handler: ((T) -> Void)?
  var ratio: CGFloat = 1
  var accentColor = UIColor.silver
  let handle = UIImageView()
  let background = UIImageView()
  var isConnected: Bool {
    return handler != nil
  }

  required convenience init() {
    self.init(at: .zero)
  }

  required convenience init(at: CGPoint) {
    self.init(at: at, ratio: 1)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(at: CGPoint, ratio: CGFloat) {
    fatalError("init(at:ratio) has not been implemented")
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func drawHandle(mask: UIImage?, cornerRadius: CGFloat, shadowOffset: CGFloat, shadowRadius: CGFloat) {
    handle.contentMode = UIView.ContentMode.scaleAspectFill
    handle.layer.cornerRadius = cornerRadius
    handle.layer.masksToBounds = false
    handle.layer.backgroundColor = accentColor.cgColor
    handle.layer.shadowOffset = CGSize(width: 0, height: shadowOffset)
    handle.layer.shadowColor = UIColor.black.cgColor
    handle.layer.shadowRadius = shadowRadius
    handle.layer.shadowOpacity = 1
    handle.image = mask
    addSubview(handle)
  }

  func drawBackground(image: UIImage?) {
    background.contentMode = UIView.ContentMode.scaleAspectFill
    background.image = image
    insertSubview(background, at: 0)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !isConnected { return super.touchesBegan(touches, with: event) }
    UIView.animate(withDuration: 0.1) {
      self.touchesMoved(touches, with: event)
    }
  }

  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !isConnected { return super.touchesMoved(touches, with: event) }
    guard let touch = touches.first else { return }
    onTouch(at: touch.location(in: self))
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !isConnected { return super.touchesEnded(touches, with: event) }
    resetHandle()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !isConnected { return super.touchesCancelled(touches, with: event) }
    resetHandle()
  }

  func resetHandle() {
    UIView.animate(withDuration: 0.25) {
      self.handle.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    onReset()
  }

  func onTouch(at: CGPoint) {
  }

  func onReset() {
  }
}
