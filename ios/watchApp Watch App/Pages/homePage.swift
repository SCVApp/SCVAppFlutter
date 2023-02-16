//
//  homePage.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation
import SwiftUI

struct HomePage: View{
    @EnvironmentObject private var urnikManager:UrnikManager
    var body: some View{
        NavigationView{
            ScrollView{
                if let trenutnoObdobje = self.urnikManager.dobiObdobje(obdobjeUrType: .trenutno){
                    NavigationLink(destination:UrnikView()){
                        VStack{
                            ObdobjeUrView(obdobjeUr: trenutnoObdobje)
                            if let obdobjeUr = self.urnikManager.dobiObdobje(obdobjeUrType: .naslednje){
                                if let zacetek = obdobjeUr.zacetek{
                                    VStack{
                                        Text("Naslednja ura čez:")
                                        Text(zacetek, style: .timer)
                                    }
                                }
                            }
                        }
                    }.buttonStyle(PlainButtonStyle()) 
                }else if let naslednjeObdobje = self.urnikManager.dobiObdobje(obdobjeUrType: .naslednje){
                    NavigationLink(destination:UrnikView()){
                        VStack{
                            ObdobjeUrView(obdobjeUr: naslednjeObdobje)
                        }
                    }.buttonStyle(PlainButtonStyle())
                }
                else{
                    NavigationLink(destination:UrnikView()){
                        Label {
                            Text("Urnik")
                        } icon: {
                            Image(systemName: "calendar")
                        }
                    }
                }
                NavigationLink(destination: SettingPage()) {
                    Label {
                        Text("Nastavitve")
                    } icon: {
                        Image(systemName: "gear")
                    }
                }

            }
        }.onAppear{
            urnikManager.loadUrnik()
        }
    }
}

struct HomePagePreview:PreviewProvider{
    static var previews: some View{
        HomePage().environmentObject(UrnikManager())
    }
}
