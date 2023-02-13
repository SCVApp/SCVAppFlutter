//
//  obdobjeUr.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import Foundation

struct ObdobjeUr:Identifiable,Decodable,Encodable{
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
}
