import CoreData
import Bluebird

class CoreDataSource {
  typealias Init<T> = (_: T) -> Void

  private static var persistentContainer: NSPersistentContainer!
  private static var managedObjectContext: NSManagedObjectContext!

  static func save() {
    do {
      try CoreDataSource.managedObjectContext.save()
    } catch {
      debugPrint("Can't persist: \(error.localizedDescription)")
    }
  }

  static func prepare() {
    persistentContainer = NSPersistentContainer(name: "Entities")
    persistentContainer.loadPersistentStores(completionHandler: onPersistentContainer)
    managedObjectContext = persistentContainer.viewContext
  }

  private static func onPersistentContainer(_: NSPersistentStoreDescription, error: Error?) {
    if let error = error as Error? {
      fatalError("Unresolved error \(error), \(error.localizedDescription)")
    }
  }

  func fetch <T: NSManagedObject> (_ entity: T.Type, sort: [NSSortDescriptor]) -> Promise<[T]> {
    let fetchRequest = entity.fetchRequest()
    fetchRequest.sortDescriptors = sort

    return Promise<[T]> { resolve, _ in
      CoreDataSource.managedObjectContext.perform {
        let result = try? CoreDataSource.managedObjectContext.fetch(fetchRequest)
        // swiftlint:disable force_cast
        resolve(result! as! [T])
      }
    }
  }

  func profile(_ block: ((_:Profile) -> Void)? = nil) -> Profile {
    let profile = Profile(context: CoreDataSource.managedObjectContext)
    profile.timestamp = Date()
    if let block = block { block(profile) }
    return profile
  }

  func control(_ block: ((_:Control) -> Void)? = nil) -> Control {
    let control = Control(context: CoreDataSource.managedObjectContext)
    if let block = block { block(control) }
    return control
  }

  func link(_ block: ((_:Link) -> Void)? = nil) -> Link {
    let link = Link(context: CoreDataSource.managedObjectContext)
    link.polarity = .positive
    link.axis = .universal
    if let block = block { block(link) }
    return link
  }

  func save() {
    CoreDataSource.save()
  }
}
