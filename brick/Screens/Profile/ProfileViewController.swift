import UIKit
import SBrick

class ProfileViewController: UIViewController {
  var profile: Profile!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.bg
    profile.controls?.forEach { c in addControl(c as! Control) }
  }

  private func addControl(_ control: Control) -> Void {
    let stick = Stick(at: CGPoint(x: Int(control.x), y: Int(control.y)))
    let slider = Slider(at: CGPoint(x: 500, y: 0))

    stick.trackingHandler = { data in
      print(data)
    }


    slider.trackingHandler = { data in
      print(data)
    }

    view.addSubview(stick)
    view.addSubview(slider)
  }
}
