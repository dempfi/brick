import UIKit
import SnapKit

let borderColor = UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.00).cgColor

class ControlArrangeView: UIView {
  var diff: CGPoint = .zero
  var isMoving = false {
    didSet { toggleBorder() }
  }
  var isConnected = false {
    didSet { toggleConnection() }
  }
  var controlOrigin: CGPoint {
    return frame.origin + 10
  }
  var onLinkTap: (() -> Void)?

  private var controlView: UIView
  private var linkIconView = UIImageView(
    image: UIImage(named: "PlugDisconnected"),
    highlightedImage: UIImage(named: "PlugConnected")
  )

  init(for controlView: UIView) {
    self.controlView = controlView
    let size = controlView.frame.size + 20
    super.init(frame: CGRect(origin: .zero, size: size))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func toggleBorder() {
    layer.borderColor = isMoving ? UIColor.accent.cgColor : borderColor
  }

  private func toggleConnection() {
    linkIconView.isHighlighted = isConnected
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor.background.cgColor
    layer.borderColor = borderColor
    layer.cornerRadius = 15
    layer.borderWidth = 2

    addSubview(controlView)
    controlView.frame.origin = .zero + 10
    controlView.isUserInteractionEnabled = false

    addSubview(linkIconView)
    linkIconView.snp.makeConstraints { make in
      make.trailing.equalTo(self).inset(10)
      make.top.equalTo(self).inset(10)
    }

    setupLinkIconTapListener()
  }

  private func setupLinkIconTapListener() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLinkIconTap))
    linkIconView.addGestureRecognizer(tapRecognizer)
    linkIconView.isUserInteractionEnabled = true
  }

  @objc private func onLinkIconTap(_ sender: UITapGestureRecognizer) {
    onLinkTap?()
  }
}
