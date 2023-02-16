//
//  appManager.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation
import WatchConnectivity

final class AppManager:NSObject,ObservableObject{
    let session:WCSession
    @Published var user:User = User()
    static var token:Token = Token()
    public static let APIUrl = "https://backend.app.scv.si"
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func onLoad(urnikManager:UrnikManager){
        AppManager.token.load()
        AppManager.token.refresh()
        if(AppManager.token.accessToken != nil){
            self.user.logIn()
            urnikManager.loadUrnik()
        }
    }
    
    func handleSessionMessages(method:String,data:[String:Any]){
        switch method{
        case "loginFromPhone":
            self.loginFromPhone(data: data)
            break;
        default:
            break;
        }
    }
    
    func loginFromPhone(data:[String:Any]){
        guard let accessToken:String = data["accessToken"] as? String,
              let refreshToken:String = data["refreshToken"] as? String,
              let expiresOn:String = data["expiresOn"] as? String else {return;}
        guard let expirationDate:Date = AppManager.convertToDate(string: expiresOn) else {return;}
        guard let ExpDate:Date = Calendar.current.date(byAdding: .day, value: -1, to: expirationDate) else {return;} //Subtract 1 day
        AppManager.token.set(newAccessToken: accessToken, newRefreshToken: refreshToken, newExpiresOn: AppManager.convertToString(date: ExpDate))
        AppManager.token.refresh(force: true)
        if(AppManager.token.accessToken != nil){
            self.user.logIn()
        }
    }
    
    func logOut(){
        AppManager.token.deleteAll()
        self.user.logOut()
    }
    
    func loginWithPhone(){
        print("Try to send")
        if(!self.session.isReachable){
            return
        }
        let message:[String:Any] = [
            "method":"requestLoginFromWatch",
            "data":["login":"login"]
        ]
        print("Send to phone")
        self.session.sendMessage(message, replyHandler: nil,errorHandler: nil)
    }
    
    static func convertToDate(string:String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_PL")
        dateFormatter.dateFormat = "E MMM dd yyyy HH:mm:ss 'GMT'zzz (zzzz)"
        let date = dateFormatter.date(from: string);
        return date;
    }
    
    static func convertToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_PL")
        dateFormatter.dateFormat = "E MMM d yyyy HH:mm:ss 'GMT'Z (zzzz)"
        return dateFormatter.string(from: date);
    }
}


extension AppManager:WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let err = error{
            print("Error wc-con: \(err)")
            return;
        }
        if activationState == .activated{
            print("activated wc")
        }
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("New message")
        guard let methodName:String = message["method"] as? String,
              let data:[String:Any] = message["data"] as? [String:Any] else {return}
        self.handleSessionMessages(method: methodName, data: data)
    }
}
