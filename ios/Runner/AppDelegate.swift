import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, WCSessionDelegate {
    
    var session: WCSession?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      initFlutterChannel()
      if WCSession.isSupported() {
          session = WCSession.default;
          session?.delegate = self;
          session?.activate();
      }
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func initFlutterChannel() {
      if let controller = window?.rootViewController as? FlutterViewController {
        let channel = FlutterMethodChannel(
          name: "com.SCVApp.si.watchkitapp",
          binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({ [weak self] (
          call: FlutterMethodCall,
          result: @escaping FlutterResult) -> Void in
          switch call.method {
            case "flutterToWatch":
              guard let watchSession = self?.session, watchSession.isPaired,
                  watchSession.isReachable, let methodData = call.arguments as? [String: Any],
                     let method = methodData["method"], let data = methodData["data"] else {
                  result(false)
               return
               }
            
               let watchData: [String: Any] = ["method": method, "data": data]
               watchSession.sendMessage(watchData, replyHandler: nil, errorHandler: nil)
               result(true)
            default:
               result(FlutterMethodNotImplemented)
            }
         })
       }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
}
