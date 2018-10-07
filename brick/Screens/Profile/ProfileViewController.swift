import UIKit

class ProfileViewController: UIViewController {
  var profile: Profile!
  var sbrickManager: SBrickManager!

  init(profile: Profile, manager sbrickManager: SBrickManager) {
    super.init(nibName: nil, bundle: nil)
    self.sbrickManager = sbrickManager
    self.profile = profile
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.background
//    let sbrick = sbrickManager.sbricks.first!

    for case let control as Control in profile.controls! {
//      switch control.type {
//      case ControlType.stick.rawValue:
//        break
////        let stick = ThumbstickView(at: origin)
////        stick.handler = { data in print(data) }
////        view.addSubview(stick)
//      case ControlType.verticalSlider.rawValue:
//
//        let slider = SliderController(from: control, sbrick: self.sbrick)
//
//        slider.handler = { data in
//          sbrick.exec(command: .drive(port: .port1, power: Float(data)))
//        }
//
//        view.addSubview(slider)
//      case ControlType.horizontalSlider.rawValue:
//        let slider = HorizontalSliderView(at: origin)
//        slider.handler = { data in print(data) }
//        view.addSubview(slider)
//      default: break
//      }
    }
  }
}
