import UIKit
import SnapKit

class AddProfileViewController: UIViewController, UITextFieldDelegate {
  private var controlViews = Set<UIView>()
  private let selector = ControlSelectorView()
  private let recycleBin = RecycleBinView()
  private var activeView: UIView?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.background
    setupSubviews()
    setupPanRecognizer()
    setupNavigation()
  }

  private func setupNavigation() {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
    navigationController?.navigationBar.topItem?.rightBarButtonItem = doneButton

    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hideSelf))
    navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelButton
  }

  @objc private func hideSelf() {
    navigationController?.dismiss(animated: true, completion: nil)
  }

  @objc private func onDone() {
    if controlViews.count == 0 { return }
    let profile = Profile(context: Store.moc)
    profile.timestamp = Date()

    for view in controlViews {
      let control = Control(context: Store.moc)
      control.x = Float(view.frame.origin.x)
      control.y = Float(view.frame.origin.y)

      switch view {
      case is StickView: control.type = ControlType.stick.rawValue
      case is VerticalSliderView: control.type = ControlType.verticalSlider.rawValue
      case is HorizontalSliderView: control.type = ControlType.horizontalSlider.rawValue
      default: print("Shouldn't happen.")
      }

      control.profile = profile
    }

    Store.saveContext()
    hideSelf()
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
    case .verticalSlider: subview = VerticalSliderView()
    case .horizontalSlider: subview = HorizontalSliderView()
    }
    subview.center = view.center
    self.controlViews.insert(subview)
    view.insertSubview(subview, belowSubview: selector)
  }

  private func setupPanRecognizer() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
    pan.maximumNumberOfTouches = 1
    pan.minimumNumberOfTouches = 1
    self.view.addGestureRecognizer(pan)
  }

  @objc private func onPan(recognizer: UIPanGestureRecognizer) {
    let touchPoint = recognizer.location(in: self.view)
    switch recognizer.state {
    case .began:
      guard let target = view.hitTest(touchPoint, with: nil) else { return }
      if !controlViews.contains(target) { return }
      recycleBin.isHidden = false
      activeView = target
    case .changed:
      guard let subview = self.activeView else { return }
      subview.center.x = touchPoint.x - (touchPoint.x.truncatingRemainder(dividingBy: 10))
      subview.center.y = touchPoint.y - (touchPoint.y.truncatingRemainder(dividingBy: 10))
    case .ended:
      let target = view.hitTest(touchPoint, with: nil)
      recycleBin.isHidden = true
      if target == recycleBin && activeView != nil {
        controlViews.remove(activeView!)
        activeView!.removeFromSuperview()
      }
    default:
      self.activeView = nil
    }
  }
}
