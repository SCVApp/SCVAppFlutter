//
//  urnikManager.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 10/02/2023.
//

import Foundation

class UrnikManager:ObservableObject{
    @Published var urnik:Urnik?
    private static var urnikKey:String = "scvapp-urnik-key";
    private static var defualts:UserDefaults = UserDefaults.standard
    @Published var loading:Bool = false;
    
    func fetchFromWeb(){
        self.loading = self.urnik?.isFromToday() ?? true
        guard let url = URL(string: "\(AppManager.APIUrl)/user/schedule") else {return;}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET";
        
        AppManager.token.refresh()
        guard let accessToken = AppManager.token.accessToken else {return;}
        
        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        return
                    }

                    guard let response = response as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        guard let data = data else { return }
                        self.fromJSON(json: data, update: true)
                    }
                }

        dataTask.resume()
        self.loading = false
    }
    
    func loadUrnik(){
        self.loadFromStorage()
        guard let urnik = self.urnik else {
            self.fetchFromWeb()
            return;
        }
        if(urnik.isItOld()){
            self.fetchFromWeb()
        }
    }
    
    func saveToStorage(){
        do{
            let json:Data = try JSONEncoder().encode(self.urnik)
            UrnikManager.defualts.set(json, forKey: UrnikManager.urnikKey)
        }catch{}
    }
    
    func loadFromStorage(){
        guard let json = UrnikManager.defualts.data(forKey: UrnikManager.urnikKey) else {return;}
        self.fromJSON(json: json)
    }
    
    func fromJSON(json:Data, update:Bool = false){
        do{
            self.urnik = try JSONDecoder().decode(Urnik.self, from: json)
            if(self.urnik != nil && update){
                self.urnik?.lastUpdated = Date()
            }
        }catch{}
        self.saveToStorage()
    }
}
