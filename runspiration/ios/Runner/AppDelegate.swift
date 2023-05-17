import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let pedometer = CMPedometer()
  var sensorChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    sensorChannel = FlutterMethodChannel(name: "com.example/sensor", binaryMessenger: controller.binaryMessenger)
    sensorChannel?.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "startUpdates":
        self.startUpdates()
        result(nil)
      case "stopUpdates":
        self.stopUpdates()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func startUpdates() {
    if CMPedometer.isStepCountingAvailable() {
      let now = Date()
      pedometer.startUpdates(from: now) { pedometerData, error in
        if let pedometerData = pedometerData {
          self.sensorChannel?.invokeMethod("stepsUpdate", arguments: pedometerData.numberOfSteps.intValue)
          self.sensorChannel?.invokeMethod("distanceUpdate", arguments: pedometerData.distance?.doubleValue)
        }
      }
    }
  }

  func stopUpdates() {
    pedometer.stopUpdates()
  }
}