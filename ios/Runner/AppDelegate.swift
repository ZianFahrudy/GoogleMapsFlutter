import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCIfuASQ-NuPlhXSCRDR7iP8kQ6wHYpnq4")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
