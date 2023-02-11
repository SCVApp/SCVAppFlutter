//
//  ura.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import Foundation

struct Ura:Decodable{
    var krajsava:String = "";
    var ucitelj:String = "";
    var ucilnica:String = "";
    var dogodek:String = "";
    var nadomescanje:Bool = false;
    var zaposlitev:Bool = false;
    var odpadlo:Bool = false;
    var type:UraType? = .normalno
    
    enum UraType:Decodable{
        case nadomescanje, zaposlitev, odpadlo, normalno, dogodek
    }
    
    func skrajsajIme() -> String{
        if(self.ucitelj.count < 1) {
            return "";
        }
        let splitedName:Array<Substring> = self.ucitelj.split(separator: " ");
        
        var skrajsanoIme:String = "";
        for i in 0...splitedName.count-2{
            let subString:String = String(splitedName[i]);
            if let firstLetter = subString.first?.uppercased(){
                skrajsanoIme += firstLetter
                skrajsanoIme += ". "
            }
        }
        
        if let zadnje = splitedName.last{
            skrajsanoIme += zadnje
        }
        
        return skrajsanoIme;
    }

    
    mutating func setType(){
        if(dogodek != ""){
            self.type = .dogodek;
        }else if(nadomescanje == true){
            self.type = .nadomescanje
        }else if(zaposlitev == true){
            self.type = .zaposlitev
        }else if(odpadlo == true){
            self.type = .odpadlo
        }else{
            self.type = .normalno;
        }
    }
}
