//
//  obdobjeUr.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import Foundation

struct ObdobjeUr:Identifiable, Codable{
    var id:Int = 0;
    var ime:String = "";
    var trajanje:String = "";
    var zacetek:Date?;
    var konec:Date?;
    var ura:[Ura] = []
    var type:ObdobjeUrType? = .normalno;
    
    enum ObdobjeUrType:Decodable,Encodable{
        case trenutno, naslednje, normalno
    }
    
    mutating func setStartAndEnd(){
        let splitedTrajnje:[String] = self.trajanje.components(separatedBy: "-")
        if(splitedTrajnje.count != 2){return;}
        let zacetekString = splitedTrajnje[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let konecString = splitedTrajnje[1].trimmingCharacters(in: .whitespacesAndNewlines)
        guard let zac = self.fromStringToHour(string: zacetekString),
              let konc = self.fromStringToHour(string: konecString) else{return;}
        self.zacetek = zac
        self.konec = konc
    }
    
    private func fromStringToHour(string:String) -> Date?{
        let splitedString:[String] = string.components(separatedBy: ":")
        if(splitedString.count != 2 ){return nil;}
        
        guard let hour:Int = Int(splitedString[0]), let minutes:Int = Int(splitedString[1]) else {return nil;}
        
        guard let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: Date()) else{return nil;}
        return date;
    }
    
    func isEmpty() -> Bool {
        for ura:Ura in self.ura{
            if(!ura.isEmpty()){
                return false;
            }
        }
        return true;
    }
}
