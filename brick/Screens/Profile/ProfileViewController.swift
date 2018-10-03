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
    let verticalSlider = VerticalSliderView(at: CGPoint(x: 300, y: 50))
    let horizontalSlider = HorizontalSliderView(at: CGPoint(x: 400, y: 50))

    stick.handler = { data in
      print(data)
    }

    verticalSlider.handler = { data in
      print(data)
    }

    horizontalSlider.handler = { data in
      print(data)
    }

    view.addSubview(stick)
    view.addSubview(verticalSlider)
    view.addSubview(horizontalSlider)
  }
}
