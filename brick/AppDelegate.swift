import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var rootWireframe: RootWireframe?
  var profilesWireframe: ProfilesWireframe?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    setupWindow()
    setupAppearances()
    setupInterface()
    CoreDataSource.prepare()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataSource.save()
  }

  func setupWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = UINavigationController()
    window!.backgroundColor = UIColor.background
    window!.makeKeyAndVisible()
  }

  func setupInterface() {
    rootWireframe = RootWireframe()
    rootWireframe!.navigationController = window?.rootViewController as? UINavigationController
    rootWireframe!.profilesWireframe.presentInterface()
  }

  func setupAppearances() {
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().barTintColor = UIColor.background
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().tintColor = UIColor.accent
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.foreground
    ]
  }
}
