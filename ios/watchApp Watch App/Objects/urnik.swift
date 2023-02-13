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
        if(lastUpdated != nil){
            return true;
        }
        let dateNow:Date = Date()
        guard let date:Date = Calendar.current.date(byAdding: .hour, value: 1, to: dateNow) else {return true;}
        if(lastUpdated! > date){
            return true;
        }
        return false;
    }
}
