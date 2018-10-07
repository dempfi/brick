import UIKit

class ProfileViewController: UIViewController {
  var profile: Profile!
  var sbrickManager: SBrickManager!

  init() {
    super.init(nibName: nil, bundle: nil)
    // swiftlint:disable force_cast
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    sbrickManager = appDelegate.sbrickManager
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.background
    let sbrick = sbrickManager.sbricks.first!

    for case let control as Control in profile.controls! {
      let origin = CGPoint(x: CGFloat(control.x), y: CGFloat(control.y))

      switch control.type {
      case ControlType.stick.rawValue:
        let stick = StickView(at: origin)
        stick.handler = { data in print(data) }
        view.addSubview(stick)
      case ControlType.verticalSlider.rawValue:
        let slider = VerticalSliderView(at: origin)

        slider.handler = { data in
          sbrick.exec(command: .drive(port: .port1, power: Float(data)))
        }

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
