import UIKit
import SnapKit

class AddProfileViewController: UIViewController, UITextFieldDelegate {
  private var controls = Set<UIView>()
  private let selector = ControlSelectorView()
  private let recycleBin = RecycleBinView()
  private var activeView: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.bg
    setupSubviews()
    setupPanRecognizer()
    addDoneButton()
  }

  private func addDoneButton() {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
    AddProfileNavigation.controller.navigationBar.topItem?.rightBarButtonItem = doneButton
  }

  @objc private func onDone() {
    let collections = controls.map { subview in subview.frame.origin }
    print(collections)
  }

  private func setupSubviews() {
    view.addSubview(selector)
    selector.handler = self.onSelect
    selector.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
      make.centerX.equalTo(view.center)
    }

    view.addSubview(recycleBin)
    recycleBin.snp.makeConstraints { make in
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
    }

    let grid = UIView()
    view.insertSubview(grid, at: 0)
    grid.backgroundColor = UIColor(patternImage: UIImage(named: "GridPattern")!)
    grid.layer.isOpaque = false
    grid.snp.makeConstraints { make in
      make.center.equalTo(view)
      make.height.equalTo(view)
      make.width.equalTo(view)
    }
  }

  private func onSelect(_ type: ControlType) {
    var subview: UIView!
    switch type {
    case .stick: subview = StickView()
    case .sliderHorizontal: subview = HorizontalSliderView()
    case .sliderVertical: subview = VerticalSliderView()
    }
    subview.center = view.center
    self.controls.insert(subview)
    view.insertSubview(subview, belowSubview: selector)
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
      recycleBin.isHidden = false
      activeView = target
    case .changed:
      guard let subview = self.activeView else { return }
      subview.center.x = p.x - (p.x.truncatingRemainder(dividingBy: 10))
      subview.center.y = p.y - (p.y.truncatingRemainder(dividingBy: 10))
    case .ended:
      let target = view.hitTest(p, with: nil)
      recycleBin.isHidden = true
      if target == recycleBin && activeView != nil {
        controls.remove(activeView!)
        activeView!.removeFromSuperview()
      }
    default:
      self.activeView = nil
    }
  }
}
