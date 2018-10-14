import UIKit

class ControlSelectorView: UIView {
  public var handler: ((Control.type) -> Void)?

  override open var intrinsicContentSize: CGSize {
    return CGSize(width: 200, height: 50)
  }

  override func draw(_ rect: CGRect) {
    layer.backgroundColor = UIColor.panel.cgColor
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
    handler?(.horizontalSlider)
  }

  @objc private func selectSliderVertical() {
    handler?(.verticalSlider)
  }
}
