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
    let stick = Stick(x: Int(control.x), y: Int(control.y), size: 150)
    let slider = Slider(x: 500, y: 50, size: 210)

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
