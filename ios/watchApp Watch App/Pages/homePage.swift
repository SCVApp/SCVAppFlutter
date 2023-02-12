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
        UrnikView().onAppear{
            urnikManager.loadUrnik()
        }
    }
}
