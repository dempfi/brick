import CoreData

class CoreDataSource {
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

  func fetch <T: NSManagedObject> (_ entity: T.Type, sort: [NSSortDescriptor], _ onDone: @escaping (_: [T]) -> Void) {
    let fetchRequest = entity.fetchRequest()
    fetchRequest.sortDescriptors = sort

    CoreDataSource.managedObjectContext.perform {
      let result = try? CoreDataSource.managedObjectContext.fetch(fetchRequest)
      // swiftlint:disable force_cast
      onDone(result! as! [T])
    }
  }

  func profile() -> Profile {
    let profile = Profile(context: CoreDataSource.managedObjectContext)
    profile.timestamp = Date()
    return profile
  }

  func stick() -> Stick {
    return Stick(context: CoreDataSource.managedObjectContext)
  }

  func slider() -> Slider {
    return Slider(context: CoreDataSource.managedObjectContext)
  }

  func save() {
    CoreDataSource.save()
  }
}
