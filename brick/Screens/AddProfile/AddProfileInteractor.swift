import UIKit

class AddProfileInteractor {
  let dataStore = CoreDataSource()

  func newProfile(controls: [(Control.type, CGPoint)]) {
    let profile = dataStore.profile()

    for (type, origin) in controls {
      let control = dataStore.control {
        $0.profile = profile
        $0.origin = origin
        $0.type = type
      }

      if type == .stick {
        _ = dataStore.link {
          $0.axis = .x
          $0.port = .port1
          $0.sbrick = "68:20:7B:B1:8C:50"
          $0.control = control
        }

        _ = dataStore.link {
          $0.axis = .y
          $0.port = .port2
          $0.sbrick = "68:20:7B:B1:8C:50"
          $0.control = control
        }
      } else {
        _ = dataStore.link {
          $0.port = .port1
          $0.sbrick = "68:20:7B:B1:8C:50"
          $0.control = control
        }
      }
    }

    dataStore.save()
  }
}
