import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.backgroundColor = UIColor.black
    
    let navbar = UINavigationController(rootViewController: ProfilesViewController())
    
    window!.rootViewController = navbar
    window!.makeKeyAndVisible()
    
    Store.initialize()
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    Store.saveContext()
  }
}
