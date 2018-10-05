import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    applyAppearances()
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = UINavigationController(rootViewController: ProfilesViewController())
    window!.backgroundColor = Colors.background
    window!.makeKeyAndVisible()

    Store.initialize()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    Store.saveContext()
  }

  private func applyAppearances() {
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().tintColor = Colors.accent
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
}
