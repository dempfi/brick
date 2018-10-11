import UIKit
import SnapKit

class AddProfileViewController: UIViewController {
  weak var presenter: AddProfilePresenter?

  var controlViews = [UUID: UIView]()
  var activeControlView: (key: UUID, value: UIView)?

  let selectorView = ControlSelectorView()
  let recycleBinView = RecycleBinView()

  override func viewDidLoad() {
    super.viewDidLoad()
    configurePanRecognizer()
    configureNavbar()
    configureView()
  }

  func configureNavbar() {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
    navigationController?.navigationBar.topItem?.rightBarButtonItem = doneButton

    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
    navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelButton
  }

  func configureView() {
    view.backgroundColor = UIColor.background
    view.addSubview(selectorView)
    selectorView.handler = onControlSelect
    selectorView.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
      make.centerX.equalTo(view.center)
    }

    view.addSubview(recycleBinView)
    recycleBinView.snp.makeConstraints { make in
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

  func configurePanRecognizer() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
    pan.maximumNumberOfTouches = 1
    pan.minimumNumberOfTouches = 1
    self.view.addGestureRecognizer(pan)
  }

  @objc func onDone() {
    presenter?.done()
  }

  @objc func onCancel() {
    presenter?.cancel()
  }

  func onControlSelect(_ type: Control.type) {
    presenter?.newControl(type)
  }

  func drawControl(id: UUID, _ type: Control.type) {
    var control: UIView!
    switch type {
    case .horizontalSlider: control = HorizontalSliderView()
    case .verticalSlider: control = VerticalSliderView()
    case .stick: control = StickView()
    }

    control.center = view.center
    controlViews[id] = control
    view.insertSubview(control, belowSubview: selectorView)
    presenter?.positionControl(id, at: control.frame.origin)
  }

  @objc func onPan(recognizer: UIPanGestureRecognizer) {
    let touchPoint = recognizer.location(in: self.view)

    switch recognizer.state {
    case .began:
      guard let target = view.hitTest(touchPoint, with: nil) else { return }
      guard let controlTarget = controlViews.first(where: { $1 == target }) else { return }
      activeControlView = controlTarget
      recycleBinView.isHidden = false

    case .changed:
      guard let (id, subview) = activeControlView else { return }
      subview.center = touchPoint - touchPoint % 10
      presenter?.positionControl(id, at: subview.frame.origin)

    case .ended:
      let target = view.hitTest(touchPoint, with: nil)
      recycleBinView.isHidden = true
      guard target == recycleBinView else { return }
      guard let (id, subview) = activeControlView else { return }
      controlViews.removeValue(forKey: id)
      subview.removeFromSuperview()
      presenter?.removeControl(id)

    default: activeControlView = nil
    }
  }
}
