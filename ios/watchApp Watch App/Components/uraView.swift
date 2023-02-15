//
//  uraView.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import SwiftUI

struct UraView: View{
    var obdonjeUr:ObdobjeUr
    var ura:Ura
    var body: some View{
        VStack {
            HStack{
                Text(ura.krajsava)
                Spacer()
                Text(ura.ucilnica)
            }.padding(.horizontal,10).padding(.top, 10).lineLimit(5)
            VStack{
                Text(obdonjeUr.trajanje).font(.footnote).lineLimit(5)
                Spacer()
                Text(ura.skrajsajIme()).font(.footnote).lineLimit(5)
                if(ura.type != .normalno){
                    Spacer()
                    Text(ura.getTextForType())
                }
            }.padding(.horizontal,10).padding(.bottom, 10)
        }.background(RoundedRectangle(cornerRadius: 12.0).foregroundColor(.blue))
            .padding()
    }
}
