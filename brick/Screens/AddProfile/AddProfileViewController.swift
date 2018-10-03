import UIKit
import SnapKit

class AddProfileViewController: UIViewController, UITextFieldDelegate {
  private var controls = Set<UIView>()
  private let selector = ControlSelector()
  private let trash = Trash()
  private var activeView: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.bg
    setupSubviews()
    setupPanRecognizer()
    setupGrid()
  }

  private func setupSubviews() {
    view.addSubview(selector)
    selector.handler = self.onSelect
    selector.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
      make.centerX.equalTo(view.center)
    }

    view.addSubview(trash)
    trash.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
    }
  }

  private func onSelect(_ type: ControlType) {
    switch type {
    case .stick:
      let stick = StickView()
      stick.center = view.center
      self.controls.insert(stick)
      view.insertSubview(stick, belowSubview: selector)

    case .sliderHorizontal:
      let slider = SliderView()
      slider.center = view.center
      self.controls.insert(slider)
      view.insertSubview(slider, belowSubview: selector)

    case .sliderVertical:
      let slider = SliderView()
      slider.center = view.center
      self.controls.insert(slider)
      view.insertSubview(slider, belowSubview: selector)

    }
  }

  private func setupPanRecognizer() {
    let pan = UIPanGestureRecognizer(target:self, action: #selector(onPan))
    pan.maximumNumberOfTouches = 1
    pan.minimumNumberOfTouches = 1
    self.view.addGestureRecognizer(pan)
  }

  @objc private func onPan(recognizer: UIPanGestureRecognizer) {
    let p = recognizer.location(in: self.view)
    switch recognizer.state {
    case .began:
      guard let target = view.hitTest(p, with: nil) else { return }
      if !controls.contains(target) { return }
      trash.isHidden = false
      activeView = target
    case .changed:
      guard let subview = self.activeView else { return }
      subview.center.x = p.x - (p.x.truncatingRemainder(dividingBy: 20))
      subview.center.y = p.y - (p.y.truncatingRemainder(dividingBy: 20))
    case .ended:
      let target = view.hitTest(p, with: nil)
      trash.isHidden = true
      if target == trash && activeView != nil {
        controls.remove(activeView!)
        activeView!.removeFromSuperview()
      }
    default:
      self.activeView = nil
    }
  }

  private func setupGrid() {
    let grid = UIImageView(image: UIImage(named: "Grid"))
    grid.contentMode = .center
    grid.center = view.center
    view.insertSubview(grid, at: 0)
  }
}
