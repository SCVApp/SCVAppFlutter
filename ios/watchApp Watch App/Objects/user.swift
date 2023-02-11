//
//  user.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation

class User:ObservableObject{
    @Published var loggedIn:Bool = false;
    
    func logIn(){
        DispatchQueue.main.async {
            self.loggedIn = true;
        }
    }
    
    func logOut(){
        DispatchQueue.main.async {
            self.loggedIn = false;
        }
    }
}
