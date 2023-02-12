//
//  urnikManager.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 10/02/2023.
//

import Foundation

var json:String = """
{
 "urnik": [
        {
            "id": 1,
            "ime": "1. ura",
            "trajanje": "8:00 - 8:45",
            "ura": [
                {
                    "krajsava": "SLO",
                    "ucilnicaInUcitelj": "S. Lubej, C304",
                    "ucitelj": "Sonja Lubej",
                    "ucilnica": "C304",
                    "dogodek": "",
                    "nadomescanje": false,
                    "zaposlitev": false,
                    "odpadlo": false
                }
            ]
        }
    ]
}
"""

class UrnikManager:ObservableObject{
    @Published var urnik:Urnik?
    
    func loadUrnik(){
        do{
            let jsonData = json.data(using: .utf8)!
            self.urnik = try JSONDecoder().decode(Urnik.self, from: jsonData)
        }catch let error{
            print(error)
        }
    }
}
