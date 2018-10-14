import UIKit
import Bluebird

class ProfilesInteractor {
  let dataSource = CoreDataSource()

  func fetchProfiles() -> Promise<[Profile]> {
    let sort = [NSSortDescriptor(key: #keyPath(Profile.timestamp), ascending: false)]
    return dataSource.fetch(Profile.self, sort: sort)
  }
}
