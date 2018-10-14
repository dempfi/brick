import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {
  @NSManaged public var timestamp: Date
  @NSManaged public var title: String?
  @NSManaged public var controls: Set<Control>
}

extension Profile {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
    return NSFetchRequest<Profile>(entityName: "Profile")
  }

  @objc(addControlsObject:)
  @NSManaged public func addToControls(_ value: Control)

  @objc(removeControlsObject:)
  @NSManaged public func removeFromControls(_ value: Control)

  @objc(addControls:)
  @NSManaged public func addToControls(_ values: Set<Control>)

  @objc(removeControls:)
  @NSManaged public func removeFromControls(_ values: Set<Control>)
}
