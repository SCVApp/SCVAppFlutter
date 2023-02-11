//
//  watchAppApp.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 10/02/2023.
//

import SwiftUI

@main
struct watchApp_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UrnikManager())
        }
    }
}
