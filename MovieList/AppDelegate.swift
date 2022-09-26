import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinatorType!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .orange
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        let appCoordinator = AppCoordinator(window: window!)
        appCoordinator.launch()
        self.appCoordinator = appCoordinator
        return true
    }
}
