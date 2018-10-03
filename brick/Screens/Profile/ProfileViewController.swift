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
    let stick = StickView(at: CGPoint(x: Int(control.x), y: Int(control.y)))
    let slider = SliderView(at: CGPoint(x: 500, y: 0))

    stick.handler = { data in
      print(data)
    }


    slider.handler = { data in
      print(data)
    }

    view.addSubview(stick)
    view.addSubview(slider)
  }
}
