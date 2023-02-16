//
//  ura.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import Foundation

struct Ura:Identifiable, Codable{
    let id = UUID()
    var krajsava:String = "";
    var ucitelj:String = "";
    var ucilnica:String = "";
    var dogodek:String = "";
    var nadomescanje:Bool = false;
    var zaposlitev:Bool = false;
    var odpadlo:Bool = false;
    var type:UraType? = .normalno
    
    enum UraType:Decodable,Encodable{
        case nadomescanje, zaposlitev, odpadlo, normalno, dogodek
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.krajsava = try container.decode(String.self, forKey: .krajsava)
        self.ucitelj = try container.decode(String.self, forKey: .ucitelj)
        self.ucilnica = try container.decode(String.self, forKey: .ucilnica)
        self.dogodek = try container.decode(String.self, forKey: .dogodek)
        self.nadomescanje = try container.decode(Bool.self, forKey: .nadomescanje)
        self.zaposlitev = try container.decode(Bool.self, forKey: .zaposlitev)
        self.odpadlo = try container.decode(Bool.self, forKey: .odpadlo)
        
        self.setType()
    }
    
    init(krajsava:String,ucitelj:String){
        self.krajsava = krajsava
        self.ucitelj = ucitelj
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
    
    func isEmpty() -> Bool {
        if(self.krajsava == "" &&
           self.ucitelj == "" &&
           self.ucilnica == "" &&
           !self.nadomescanje &&
           !self.odpadlo &&
           !self.zaposlitev &&
           self.dogodek == ""){
            return true;
        }
            
            return false;
    }
    
    func getTextForType() -> String{
        switch self.type{
        case .nadomescanje:
            return "Nadomescanje"
        case .dogodek:
            return "Dogodek"
        case .odpadlo:
            return "Odpadlo"
        case .zaposlitev:
            return "Zaposlitev"
        default:
            return ""
        }
    }
}
