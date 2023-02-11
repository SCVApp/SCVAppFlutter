//
//  uraView.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 09/02/2023.
//

import SwiftUI

struct UraView: View{
    var obdonjeUr:ObdobjeUr
    @State var ura:Ura?
    var body: some View{
        VStack {
            HStack{
                Text(ura?.krajsava ?? "")
                Spacer()
                Text(ura?.ucilnica ?? "")
            }.padding(.horizontal,10).padding(.top, 10)
            LazyHStack{
                Text(obdonjeUr.trajanje).font(.footnote)
                Spacer()
                Text(ura?.skrajsajIme() ?? "").font(.footnote)
            }.padding(.horizontal,10).padding(.bottom, 10)
        }.background(RoundedRectangle(cornerRadius: 12.0).foregroundColor(.blue))
            .padding().onAppear{
                self.ura = self.obdonjeUr.ura.first
            }
    }
}
