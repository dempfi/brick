import Foundation
import CoreData
import UIKit

@objc(Control)
public class Control: NSManagedObject {
  // swiftlint:disable type_name
  @objc public enum type: Int16 {
    case thumbstick = 0
    case verticalSlider = 1
    case horizontalSlider = 2
  }

  @NSManaged var profile: Profile
  @NSManaged var type: type
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
}
