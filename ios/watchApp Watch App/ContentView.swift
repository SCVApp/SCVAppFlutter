//
//  ContentView.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 10/02/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var urnikManager:UrnikManager
    var body: some View {
        UrnikView().onAppear{
            urnikManager.loadUrnik()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
