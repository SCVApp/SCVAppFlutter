//
//  settingPage.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 14/02/2023.
//

import Foundation
import SwiftUI

struct SettingPage : View{
    var body: some View{
            VStack{
                Button {
                    
                } label: {
                    Label {
                        Text("Odjava")
                    } icon: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }.foregroundColor(.red)
                }
                
            }.navigationTitle("Nastavitve")
    }
}

struct SettingPagePreview:PreviewProvider{
    static var previews: some View{
        SettingPage()
    }
}
