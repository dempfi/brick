import Foundation
import CoreData

@objc(Thumbstick)
public class Thumbstick: Control {
  @NSManaged private var sbrickIdX: String?
  @NSManaged private var sbrickIdY: String?
  @NSManaged private var sbrickPortX: SBrickPort.id
  @NSManaged private var sbrickPortY: SBrickPort.id

  var sbrickX: (String, SBrickPort.id)? {
    get {
      if sbrickIdX == nil { return nil }
      return (sbrickIdX!, sbrickPortX)
    }
    set (value) {
      if value == nil { return }
      self.sbrickIdX = value!.0
      self.sbrickPortX = value!.1
    }
  }

  var sbrickY: (String, SBrickPort.id)? {
    get {
      if sbrickIdY == nil { return nil }
      return (sbrickIdY!, sbrickPortY)
    }
    set (value) {
      if value == nil { return }
      self.sbrickIdY = value!.0
      self.sbrickPortY = value!.1
    }
  }
}

extension Thumbstick {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbstick> {
    return NSFetchRequest<Thumbstick>(entityName: "Thumbstick")
  }
}
