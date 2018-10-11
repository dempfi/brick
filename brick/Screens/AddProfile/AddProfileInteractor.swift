import UIKit

class AddProfileInteractor {
  let dataStore = CoreDataSource()

  func newProfile(controls: [(Control.type, CGPoint)]) {
    let profile = dataStore.profile()

    for (type, origin) in controls {
      if type == .stick {
        let control = dataStore.stick()
        control.type = .stick
        control.profile = profile
        control.origin = origin
      } else {
        let control = dataStore.slider()
        control.profile = profile
        control.link = ("68:20:7B:B1:8C:50", SBrickPort.id.port1)
        control.origin = origin
        control.type = type
      }
    }

    dataStore.save()
  }
}
