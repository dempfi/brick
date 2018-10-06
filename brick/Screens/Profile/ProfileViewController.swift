import UIKit

class ProfileViewController: UIViewController {
  var profile: Profile!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.background

    for case let control as Control in profile.controls! {
      let origin = CGPoint(x: CGFloat(control.x), y: CGFloat(control.y))

      switch control.type {
      case ControlType.stick.rawValue:
        let stick = StickView(at: origin)
        stick.handler = { data in print(data) }
        view.addSubview(stick)
      case ControlType.verticalSlider.rawValue:
        let slider = VerticalSliderView(at: origin)
        slider.handler = { data in print(data) }
        view.addSubview(slider)
      case ControlType.horizontalSlider.rawValue:
        let slider = HorizontalSliderView(at: origin)
        slider.handler = { data in print(data) }
        view.addSubview(slider)
      default: break
      }
    }
  }
}
