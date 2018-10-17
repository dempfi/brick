import UIKit

class BarButton: UIBarButtonItem {
  var onTap: (() -> Void)?

  convenience init(_ icon: Icon.type) {
    self.init(icon, onTap: nil)
  }

  init(_ icon: Icon.type, onTap: (() -> Void)?) {
    super.init()
    self.onTap = onTap
    self.image = icon.image()
    self.action = #selector(handleAction)
    self.target = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleAction() {
    onTap?()
  }
}
