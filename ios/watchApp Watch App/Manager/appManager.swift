//
//  appManager.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation
import WatchConnectivity

class AppManager:NSObject,ObservableObject{
    let session:WCSession
    @Published var user:User = User()
    @Published var token:Token = Token()
    public static let APIUrl = "https://backend.app.scv.si"
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func onLoad(){
        self.token.refresh()
        if(self.token.accessToken != nil){
            self.user.logIn()
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE MMM dd yyyy hh:mm:ss"
        guard let expirationDate:Date = dateFormatter.date(from: expiresOn) else {return;}
        guard let ExpDate:Date = Calendar.current.date(byAdding: .day, value: -1, to: expirationDate) else {return;} //Subtract 1 day
        
        self.token.set(newAccessToken: accessToken, newRefreshToken: refreshToken, newExpiresOn: dateFormatter.string(from: ExpDate))
        self.token.refresh(force: true)
    }
    
    func loginWithPhone(){
        let message:[String:Any] = [
            "method":"reqestLoginFromWatch",
            "data":["login":"login"]
        ]
        self.session.sendMessage(message, replyHandler: nil,errorHandler: nil)
    }
}


extension AppManager:WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let methodName:String = message["method"] as? String,
              let data:[String:Any] = message["data"] as? [String:Any] else {return}
        self.handleSessionMessages(method: methodName, data: data)
    }
}
