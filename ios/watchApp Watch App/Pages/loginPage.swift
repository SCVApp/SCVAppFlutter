//
//  loginPage.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation
import SwiftUI

struct LoginPage:View{
    @EnvironmentObject private var appManager:AppManager
    var body: some View{
        VStack{
            Text("Za prijavo v aplikacijo uporabi apikacijo ŠCVApp na svojem mobilnem telefonu.").font(.caption2)
            Button {
                appManager.loginWithPhone()
            } label: {
                Text("Prijava")
            }

        }
    }
}
