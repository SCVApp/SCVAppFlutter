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
        VStack{
            if(urnikManager.urnik != nil){
                List {
                    ForEach((urnikManager.urnik?.urnik)!) { obdobjeUr in
                        UraView(obdonjeUr: obdobjeUr).listRowInsets(EdgeInsets()).listRowPlatterColor(.clear)
                    }
                }.listStyle(.carousel)
            }else{
                Text("Ni podatkov")
            }
        }
    }
}
