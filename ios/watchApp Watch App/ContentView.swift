//
//  ContentView.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 10/02/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appManager:AppManager
    var body: some View {
        VStack{
            if(appManager.user.loggedIn){
                HomePage()
            }else{
                LoginPage()
            }
        }.onAppear{
            appManager.onLoad()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
