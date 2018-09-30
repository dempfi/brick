import Foundation
import CoreData

class Store {
  private static let store = Store()
  
  private init() {
  }
  
  var container: NSPersistentContainer!
  var viewContext: NSManagedObjectContext!
  
  static func fillData() {
    let control = Control(context: store.viewContext)
    control.x = 100
    control.y = 100
    control.type = "stick"
    
    let profile = Profile(context: store.viewContext)
    profile.title = "Simple"
    profile.addToControls(control)
    saveContext()
  }
  
  static func initialize() {
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    store.container = container
    store.viewContext = container.viewContext
  }
  
  static var moc: NSManagedObjectContext {
    get {
      return store.viewContext
    }
  }
  
  static func saveContext () {
    if store.viewContext.hasChanges {
      do {
        try store.viewContext.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  static func profilesController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Profile> {
    let request: NSFetchRequest<Profile> = Profile.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Profile.title), ascending: true)]
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Store.moc, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = delegate
    do {
      try frc.performFetch()
    } catch {
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
    return frc
  }
}
