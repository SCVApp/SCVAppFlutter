//
//  urnik.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import Foundation

struct Urnik:Encodable,Decodable{
    var urnik:[ObdobjeUr] = []
    var lastUpdated:Date?
    
    func isItOld() -> Bool{
        if(lastUpdated == nil){
            return true;
        }
        let dateNow:Date = Date()
        guard let date:Date = Calendar.current.date(byAdding: .hour, value: -1, to: dateNow) else {return true;}
        if(lastUpdated! < date){
            return true;
        }
        return false;
    }
    
    func isFromToday() -> Bool {
        if(lastUpdated == nil){
            return true
        }
        let dateNow:Date = Date()
        let compareYear:Bool = dateNow.get(.year) == lastUpdated?.get(.year)
        let compareMonth:Bool = dateNow.get(.month) == lastUpdated?.get(.month)
        let compareDay:Bool = dateNow.get(.day) == lastUpdated?.get(.day)
        
        if(!compareYear || !compareMonth || !compareDay){
            return true;
        }
        return false;
    }
}
