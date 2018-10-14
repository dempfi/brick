import UIKit

class AddProfilePresenter {
  var interactor = AddProfileInteractor()
  var view: AddProfileViewController
  weak var wireframe: AddProfileWireframe?

  var controlGrid = [UUID: (Control.type, CGPoint)]()

  init() {
    view = AddProfileViewController()
    view.presenter = self
  }

  func cancel() {
    wireframe?.dismissInterface()
  }

  func done() {
    guard !controlGrid.isEmpty else { return }
    interactor.newProfile(controls: controlGrid.values.map { $0 })
    wireframe?.dismissInterface()
  }

  func link(id controlId: UUID) {
    view.setConnected(id: controlId)
  }

  func newControl(_ type: Control.type) {
    let id = UUID()
    controlGrid[id] = (type, CGPoint.zero)
    view.drawControl(id: id, type)
  }

  func positionControl(_ id: UUID, at position: CGPoint) {
    controlGrid[id] = (controlGrid[id]!.0, position)
  }

  func removeControl(_ id: UUID) {
    controlGrid.removeValue(forKey: id)
  }
}
