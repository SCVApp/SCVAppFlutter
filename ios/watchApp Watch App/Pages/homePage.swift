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
                        }
                    }.buttonStyle(PlainButtonStyle()) 
                }
                Button {
                    
                } label: {
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
        HomePage()
    }
}
