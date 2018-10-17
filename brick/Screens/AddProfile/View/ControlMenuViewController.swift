import UIKit

class ControlMenuViewController: UIViewController {
  private var handler: (Control.type) -> Void

  init(at button: UIBarButtonItem, onSelect handler: @escaping (Control.type) -> Void) {
    self.handler = handler
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .popover
    popoverPresentationController?.backgroundColor = UIColor.panel
    popoverPresentationController?.barButtonItem = button
    popoverPresentationController?.delegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    view.layer.backgroundColor = UIColor.panel.cgColor
    view.layer.cornerRadius = 10
    preferredContentSize = CGSize(width: 200, height: 50)

    let stickButton = UIButton(frame: CGRect(x: 27, y: 11, width: 28, height: 28))
    stickButton.addTarget(self, action: #selector(selectStick), for: .touchDown)
    stickButton.setBackgroundImage(UIImage(named: "SelectStick"), for: .normal)
    view.addSubview(stickButton)

    let sliderVerticalButton = UIButton(frame: CGRect(x: 85, y: 8, width: 28, height: 34 ))
    sliderVerticalButton.addTarget(self, action: #selector(selectSliderVertical), for: .touchDown)
    sliderVerticalButton.setBackgroundImage(UIImage(named: "SelectSliderVertical"), for: .normal)
    view.addSubview(sliderVerticalButton)

    let sliderHorizontalButton = UIButton(frame: CGRect(x: 140, y: 11, width: 34, height: 28 ))
    sliderHorizontalButton.addTarget(self, action: #selector(selectSliderHorizontal), for: .touchDown)
    sliderHorizontalButton.setBackgroundImage(UIImage(named: "SelectSliderHorizontal"), for: .normal)
    view.addSubview(sliderHorizontalButton)
  }

  @objc private func selectStick() {
    handler(.stick)
  }

  @objc private func selectSliderHorizontal() {
    handler(.horizontalSlider)
  }

  @objc private func selectSliderVertical() {
    handler(.verticalSlider)
  }
}

extension ControlMenuViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}
