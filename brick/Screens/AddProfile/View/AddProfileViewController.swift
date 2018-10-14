import UIKit
import SnapKit

func roundToTens(_ point: CGPoint) -> CGPoint {
  let x = 10 * Int(round(point.x / 10))
  let y = 10 * Int(round(point.y / 10))
  return CGPoint(x: x, y: y)
}

class AddProfileViewController: UIViewController {
  weak var presenter: AddProfilePresenter?

  var controls = [UUID: ControlArrangeView]()
  var activeControl: (key: UUID, value: ControlArrangeView)?

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

    let wrapper = ControlArrangeView(for: control)
    view.insertSubview(wrapper, belowSubview: selectorView)
    wrapper.onLinkTap = { self.presenter?.link(id: id) }
    wrapper.center = view.center
    controls[id] = wrapper
    presenter?.positionControl(id, at: wrapper.controlOrigin)
  }

  func setConnected(id: UUID) {
    controls[id]?.isConnected = true
  }

  @objc func onPan(recognizer: UIPanGestureRecognizer) {
    let touchPoint = recognizer.location(in: self.view)

    switch recognizer.state {
    case .began:
      guard let targetView = view.hitTest(touchPoint, with: nil) else { return }
      guard let control = controls.first(where: { $1 == targetView }) else { return }
      activeControl = control
      activeControl!.value.isMoving = true
      activeControl!.value.diff = roundToTens(targetView.center - touchPoint)
      recycleBinView.reveal()

    case .changed:
      guard let (id, subview) = activeControl else { return }
      UIView.animate(withDuration: 0.1, animations: {
        subview.center = touchPoint - touchPoint % 10 + subview.diff
      })
      presenter?.positionControl(id, at: subview.controlOrigin)

    case .ended:
      let target = view.hitTest(touchPoint, with: nil)
      recycleBinView.hide()

      guard let (id, subview) = activeControl else { return }
      activeControl = nil
      subview.isMoving = false
      subview.diff = .zero

      guard target == recycleBinView else { return }
      controls.removeValue(forKey: id)
      subview.removeFromSuperview()
      presenter?.removeControl(id)

    default: activeControl = nil
    }
  }
}
