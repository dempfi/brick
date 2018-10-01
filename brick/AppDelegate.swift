import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = Navigation.controller
    window!.backgroundColor = UIColor.black
    window!.makeKeyAndVisible()

    Navigation.setupProfiles()
    Store.initialize()
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    Store.saveContext()
  }
}
