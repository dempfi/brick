import Foundation
import CoreData

@objc(Stick)
public class Stick: Control {
  @NSManaged private var sbrickIdX: String?
  @NSManaged private var sbrickIdY: String?
  @NSManaged private var sbrickPortX: SBrickPort.id
  @NSManaged private var sbrickPortY: SBrickPort.id

  var linkX: SBrickLink? {
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

  var linkY: SBrickLink? {
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

extension Stick {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Stick> {
    return NSFetchRequest<Stick>(entityName: "Stick")
  }
}
