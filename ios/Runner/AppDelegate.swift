import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var session:WCSession?;
    private var channel:FlutterMethodChannel?;
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      self.initFlutterChannel()
      if WCSession.isSupported(){
          self.session = .default;
          self.session?.delegate = self
          self.session?.activate()
      }
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func initFlutterChannel(){
        if let controller = window?.rootViewController as? FlutterViewController {
            self.channel = FlutterMethodChannel(
                  name: "com.SCVApp.si",
                  binaryMessenger: controller.binaryMessenger)
                
                channel?.setMethodCallHandler({ [weak self] (
                  call: FlutterMethodCall,
                  result: @escaping FlutterResult) -> Void in
                  switch call.method {
                    case "forwardToAppleWatch":
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
    
    
}

extension AppDelegate: WCSessionDelegate{
    func sessionDidBecomeInactive(_ session: WCSession){ }
        func sessionDidDeactivate(_ session: WCSession) {}
        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error:
                     Error?) {
        }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async{
                        guard let methodName = message["method"] as? String,
                              let data = message["data"] as? [String : Any] else {return}
            self.channel?.invokeMethod(methodName,arguments:data)
        }
    }
}
