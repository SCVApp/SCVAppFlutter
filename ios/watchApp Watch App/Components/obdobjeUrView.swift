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
        Text("\(obdobjeUr.ime) \(obdobjeUr.type == .naslednje ? "Naslednja ura":"")")
            ForEach(obdobjeUr.ura) { ura in
                UraView(obdonjeUr: obdobjeUr, ura: ura).listRowInsets(EdgeInsets())
            }
        }
    }

