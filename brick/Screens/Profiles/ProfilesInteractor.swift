import UIKit

class ProfilesInteractor {
  let dataSource = CoreDataSource()

  func fetchProfiles(_ onCompletion: @escaping ([Profile]) -> Void) {
    let sort = [NSSortDescriptor(key: #keyPath(Profile.timestamp), ascending: false)]
    dataSource.fetch(Profile.self, sort: sort, onCompletion)
  }
}
