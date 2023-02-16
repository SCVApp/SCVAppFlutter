//
//  urnikView.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 10/02/2023.
//

import SwiftUI

struct UrnikView:View{
    @EnvironmentObject private var urnikManager:UrnikManager
    var body: some View{
        if(!urnikManager.loading){
            VStack{
                if(urnikManager.urnik != nil){
                    ScrollViewReader{ scrollView in
                        List {
                            ForEach((urnikManager.urnik?.urnik)!) { obdobjeUr in
                                ObdobjeUrView(obdobjeUr: obdobjeUr).listRowInsets(EdgeInsets()).listRowPlatterColor(.clear)
                            }
                        }.listStyle(.carousel).onAppear{
                            if let trenutnoObdobje = urnikManager.dobiObdobje(obdobjeUrType: .trenutno){
                                scrollView.scrollTo(trenutnoObdobje.id)
                            }
                        }
                    }
                }else{
                    Text("Ni podatkov")
                }
            }.onAppear{
                urnikManager.loadUrnik()
            }.navigationTitle("Urnik")
        }else{
            ProgressView()
        }
    }
}

struct UrnikViewPreview:PreviewProvider{
    static var previews: some View{
        UrnikView().environmentObject(UrnikManager(urnik: Urnik(urnik: [
            ObdobjeUr(id: 1,ime: "1.ura",zacetek: Calendar.current.date(byAdding: .minute, value: 10, to: Date()),konec: Calendar.current.date(byAdding: .minute, value: 45, to: Date()),ura: [
                Ura(krajsava: "VOS", ucitelj: "Ales Spital")
            ],type: .naslednje)
        ])))
    }
}
