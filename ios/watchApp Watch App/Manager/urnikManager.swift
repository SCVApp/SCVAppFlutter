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
    var timer:Timer?
    
    func fetchFromWeb(){
        DispatchQueue.main.async {
            self.loading = self.urnik?.isFromToday() ?? true
        }
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
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    
    private func setUpTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                self.setTypesForUrnik()
            }
        }
        self.timer!.fire()
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
        self.setUpTimer()
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
        DispatchQueue.main.async {
            do{
                self.urnik = try JSONDecoder().decode(Urnik.self, from: json)
                if(self.urnik != nil && update){
                    self.urnik?.lastUpdated = Date()
                }
                if(self.urnik != nil){
                    self.urnik!.onLoad()
                }
            }catch{}
        }
        self.saveToStorage()
    }
    
    func dobiObdobje(obdobjeUrType:ObdobjeUr.ObdobjeUrType) -> ObdobjeUr?{
        return self.urnik?.urnik.first(where: { obdobjeUr in
            obdobjeUr.type == obdobjeUrType
        })
    }
    
    func setTypesForUrnik(){
        if(self.urnik == nil){
            return;
        }
        let dateNow:Date = Date()
        var indexZaTrenutno:Int = -1
        var indexZaNaslednjo:Int = -1
        self.urnik?.poukType = .niPouka
        var index:Int = 0
        for var obdobjeUr:ObdobjeUr in self.urnik!.urnik{
            if(obdobjeUr.zacetek == nil || obdobjeUr.konec == nil){
                obdobjeUr.setStartAndEnd()
                if(index > 0){
                    self.urnik!.urnik[index - 1].setStartAndEnd()
                }
            }
            if(obdobjeUr.zacetek!.isBefore(dateNow) && obdobjeUr.konec!.isAfter(dateNow)){
                obdobjeUr.type = .trenutno
                indexZaTrenutno = index
                self.urnik?.poukType = .pouk
                if(obdobjeUr.isEmpty()){
                    self.urnik?.poukType = .odmor
                }
            }else{
                obdobjeUr.type = .normalno
            }
            
            if(indexZaTrenutno >= 0){
                if(index == indexZaTrenutno + 1){
                    obdobjeUr.type = .naslednje
                }
            }else{
                if(index == 0){
                    if(obdobjeUr.zacetek!.isAfter(dateNow)){
                        obdobjeUr.type = .naslednje
                        self.urnik?.poukType = .zacetekPouka
                    }
                }else{
                    if(obdobjeUr.zacetek!.isAfter(dateNow) && self.urnik!.urnik[index - 1].konec!.isBefore(dateNow)){
                        obdobjeUr.type = .naslednje
                        self.urnik?.poukType = .odmor
                    }
                }
            }
            
            if(obdobjeUr.type == .naslednje){
                indexZaNaslednjo = index
            }
            
            index += 1
        }
        
        if(self.urnik?.urnik.count == 0){
            self.urnik?.poukType = .niPouka
        }else if(indexZaTrenutno == -1 && indexZaNaslednjo == -1){
            self.urnik?.poukType = .konecPouka
        }
    }
}
