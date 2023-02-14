//
//  token.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation

class Token: ObservableObject{
    @Published var accessToken:String?;
    @Published var refreshToken:String?;
    @Published var expiresOn:String?;
    
    static private let accessTokenKey:String = "scvapp-access-token-key";
    static private let refreshTokenKey:String = "scvapp-refresh-token-key";
    static private let expiresOnKey:String = "scvapp-expires-on-key";
    
    static private var defualts:UserDefaults = UserDefaults.standard
    
    func load(){
        self.accessToken = Token.defualts.string(forKey: Token.accessTokenKey)
        self.refreshToken = Token.defualts.string(forKey: Token.refreshTokenKey)
        self.expiresOn = Token.defualts.string(forKey: Token.expiresOnKey)
    }
    
    func set(newAccessToken:String?,newRefreshToken:String?,newExpiresOn:String?){
        DispatchQueue.main.async {
            //Update to new
            self.accessToken = newAccessToken ?? self.accessToken
            self.refreshToken = newRefreshToken ?? self.refreshToken
            self.expiresOn = newExpiresOn ?? self.expiresOn
        }
    }
    
    func save(newAccessToken:String?,newRefreshToken:String?,newExpiresOn:String?){
        self.set(newAccessToken: newAccessToken, newRefreshToken: newRefreshToken, newExpiresOn: newExpiresOn)
        //Save
        Token.defualts.set(self.accessToken, forKey: Token.accessTokenKey)
        Token.defualts.set(self.refreshToken, forKey: Token.refreshTokenKey)
        Token.defualts.set(self.expiresOn, forKey: Token.expiresOnKey)
        print("Token saved")
    }
    
    func refresh(force:Bool = false){
        if(self.isTokenExpired() || force){
            guard let url = URL(string: "\(AppManager.APIUrl)/auth/refreshToken") else {return;}
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.httpMethod = "POST";
            
            guard let body = self.toJSON() else {return;}
            
            urlRequest.httpBody = body;
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                        if let error = error {
                            print("Request error: ", error)
                            return
                        }

                        guard let response = response as? HTTPURLResponse else { return }
                        print(response.statusCode)
                        if response.statusCode == 200 {
                            guard let data = data else { return }
                            self.fromJSON(json: data)
                        }
                    }

            dataTask.resume()
        }
    }
    
    func fromJSON(json:Data){
        do{
            let tokenObj:TokenObj = try JSONDecoder().decode(TokenObj.self, from: json)
            self.save(newAccessToken: tokenObj.accessToken, newRefreshToken: tokenObj.refreshToken, newExpiresOn: tokenObj.expiresOn)
        }catch let err{
            print("Decoding problem: \(err)")
        }
    }
    
    func toJSON() -> Data?{
        if(self.accessToken == nil || self.refreshToken == nil || self.expiresOn == nil){
            return nil;
        }
        let tokenObj = TokenObj(accessToken: self.accessToken!, refreshToken: self.refreshToken!, expiresOn: self.expiresOn!)
        
        do{
            return try JSONEncoder().encode(tokenObj)
        }catch{
            
        }
        return nil;
    }
    
    func isTokenExpired() -> Bool{
        if(self.expiresOn == nil){
            return false;
        }
        guard let expirationDate:Date = AppManager.convertToDate(string: self.expiresOn!) else {return false;}
        
        let dateNow:Date = Date.init()
        if(expirationDate <= dateNow){
            return true;
        }
        
        return false;
    }
}

struct TokenObj:Decodable,Encodable{
    var accessToken:String;
    var refreshToken:String;
    var expiresOn:String;
}
