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
                    List {
                        ForEach((urnikManager.urnik?.urnik)!) { obdobjeUr in
                            ObdobjeUrView(obdobjeUr: obdobjeUr).listRowInsets(EdgeInsets()).listRowPlatterColor(.clear)
                        }
                    }.listStyle(.carousel)
                }else{
                    Text("Ni podatkov")
                }
            }.onAppear{
                urnikManager.loadUrnik()
            }
        }else{
            ProgressView()
        }
    }
}

struct UrnikViewPreview:PreviewProvider{
    static var previews: some View{
        UrnikView().environmentObject(UrnikManager())
    }
}
