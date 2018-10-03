import UIKit

enum ControlType {
  case stick
  case sliderHorizontal
  case sliderVertical
}

class ControlSelectorView: UIView {
  public var handler: ((ControlType) -> Void)?

  override open var intrinsicContentSize: CGSize {
    get {
      return CGSize(width: 200, height: 50)
    }
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor(red:0.14, green:0.14, blue:0.15, alpha:1.00).cgColor
    layer.cornerRadius = 10

    let stickButton = UIButton(frame: CGRect(x: 27, y: 11, width: 28, height: 28))
    stickButton.addTarget(self, action: #selector(selectStick), for: .touchDown)
    stickButton.setBackgroundImage(UIImage(named: "SelectStick"), for: .normal)
    addSubview(stickButton)

    let sliderVerticalButton = UIButton(frame: CGRect(x: 85, y: 8, width: 28, height: 34 ))
    sliderVerticalButton.addTarget(self, action: #selector(selectSliderVertical), for: .touchDown)
    sliderVerticalButton.setBackgroundImage(UIImage(named: "SelectSliderVertical"), for: .normal)
    addSubview(sliderVerticalButton)

    let sliderHorizontalButton = UIButton(frame: CGRect(x: 140, y: 11, width: 34, height: 28 ))
    sliderHorizontalButton.addTarget(self, action: #selector(selectSliderHorizontal), for: .touchDown)
    sliderHorizontalButton.setBackgroundImage(UIImage(named: "SelectSliderHorizontal"), for: .normal)
    addSubview(sliderHorizontalButton)
  }

  @objc private func selectStick() {
    handler?(.stick)
  }

  @objc private func selectSliderHorizontal() {
    handler?(.sliderHorizontal)
  }

  @objc private func selectSliderVertical() {
    handler?(.sliderVertical)
  }
}
