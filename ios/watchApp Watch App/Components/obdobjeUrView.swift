//
//  obdobjeUrView.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 13/02/2023.
//

import Foundation
import SwiftUI

struct ObdobjeUrView:View{
    var obdobjeUr:ObdobjeUr
    var body:some View{
        HStack{
            Text(obdobjeUr.ime)
            if obdobjeUr.type == .naslednje{
                if let zacetek = obdobjeUr.zacetek{
                    Text("sledi čez:")
                    Text(zacetek, style: .timer)
                }
            }
        }.lineLimit(nil)
            ForEach(obdobjeUr.ura) { ura in
                UraView(obdonjeUr: obdobjeUr, ura: ura).listRowInsets(EdgeInsets()).id(ura.id)
            }
        }
    }

