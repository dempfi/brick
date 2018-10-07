import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var sbrickManager: SBrickManager!

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    applyAppearances()
    sbrickManager = SBrickManager(delegate: self)
    let profiles = ProfilesViewController()
    profiles.sbrickManager = sbrickManager
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = UINavigationController(rootViewController: profiles)
    window!.backgroundColor = Colors.background
    window!.makeKeyAndVisible()

    sbrickManager.scan()
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

extension AppDelegate: SBrickManagerDelegate, SBrickDelegate {
  func sbrickManager(_ manager: SBrickManager, didDiscover sbrick: SBrick) {
    manager.connect(to: sbrick)
    print(sbrick.identifier)
    sbrick.delegate = self
  }

  func sbrickReady(_ sbrick: SBrick) {
    sbrickManager.stopScan()
  }
}
