import Foundation
import CoreData

@objc(Slider)
public class Slider: Control {
  @NSManaged private var sbrickId: String?
  @NSManaged private var sbrickPort: SBrickPort.id

  var link: SBrickLink? {
    get {
      if sbrickId == nil { return nil }
      return (sbrickId!, sbrickPort)
    }
    set (value) {
      if value == nil { return }
      self.sbrickId = value!.0
      self.sbrickPort = value!.1
    }
  }
}

extension Slider {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Slider> {
    return NSFetchRequest<Slider>(entityName: "Slider")
  }
}
