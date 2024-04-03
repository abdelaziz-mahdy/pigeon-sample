import UIKit
import Flutter

private class PigeonApiImplementation: MessageApi {
  func getMessages(email: String) throws -> [Message] {
    return [
          Message(subject: "Hello", body: "World", email: email)
        ]
  }
}

private class PyTorchApiImplementation: PyTorchApi {
  func getRects() throws -> [PyTorchRect] {
    return [
          PyTorchRect(left: 0.0, top: 0.0, right: 1.0, bottom: 1.0, width: 1.0, height: 1.0)
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
    let api = PyTorchApiImplementation()
    PyTorchApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
