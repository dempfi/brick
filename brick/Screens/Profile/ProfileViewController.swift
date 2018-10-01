import UIKit
import SBrick

class ProfileViewController: UIViewController {
  var profile: Profile!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    profile.controls?.forEach { c in addControl(c as! Control) }
  }

  private func addControl(_ control: Control) -> Void {
    let position = CGRect(x: Int(control.x), y: Int(control.y), width: 150, height: 150)
    
    let stick = Stick()
    stick.frame = position
    stick.trackingHandler = { data in
      print(data)
    }
    
    view.addSubview(stick)
  }
}
