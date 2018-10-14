import Foundation
import CoreData
import UIKit

@objc(Control)
public class Control: NSManagedObject {
  // swiftlint:disable type_name
  @objc public enum type: Int16 {
    case stick = 0
    case verticalSlider = 1
    case horizontalSlider = 2
  }

  @NSManaged var type: type
  @NSManaged var links: Set<Link>
  @NSManaged var profile: Profile
  @NSManaged private var x: Float
  @NSManaged private var y: Float

  var origin: CGPoint {
    get {
      return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    set (value) {
      self.x = Float(value.x)
      self.y = Float(value.y)
    }
  }
}

extension Control {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Control> {
    return NSFetchRequest<Control>(entityName: "Control")
  }

  @objc(addLinksObject:)
  @NSManaged public func addToLinks(_ value: Link)

  @objc(removeLinksObject:)
  @NSManaged public func removeFromLinks(_ value: Link)

  @objc(addLinks:)
  @NSManaged public func addToLinks(_ values: Set<Link>)

  @objc(removeLinks:)
  @NSManaged public func removeFromLinks(_ values: Set<Link>)
}
