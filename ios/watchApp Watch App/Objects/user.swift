//
//  user.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation

struct User{
    var loggedIn:Bool = false;
    
    mutating func logIn(){
        self.loggedIn = true;
    }
    
    mutating func logOut(){
        self.loggedIn = false;
    }
}
