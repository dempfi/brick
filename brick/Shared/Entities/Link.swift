import Foundation
import CoreData

@objc(Link)
public class Link: NSManagedObject {
  // swiftlint:disable type_name
  @objc public enum axis: Int16 {
    case universal = 0
    case x = 1
    case y = 2
  }

  // swiftlint:disable type_name
  @objc public enum polarity: Int16 {
    case positive = 0
    case negative = 1
  }

  @NSManaged public var axis: axis
  @NSManaged public var polarity: polarity
  @NSManaged public var port: SBrickPort.id
  @NSManaged public var sbrick: String
  @NSManaged public var control: Control?
}

extension Link {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Link> {
    return NSFetchRequest<Link>(entityName: "Link")
  }
}
