import UIKit
import Flutter

private class PigeonApiImplementation: MessageApi {
  func getMessages(email: String) throws -> [Message] {
    return [
          Message(subject: "Hello", body: "World", email: email)
        ]
  }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let api = PigeonApiImplementation()
    MessageApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
