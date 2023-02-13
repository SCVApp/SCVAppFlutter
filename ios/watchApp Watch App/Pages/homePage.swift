//
//  homePage.swift
//  watchApp Watch App
//
//  Created by Urban Krepel on 11/02/2023.
//

import Foundation
import SwiftUI

struct HomePage: View{
    var body: some View{
        NavigationView{
            Text("Home")
        }
    }
}

struct HomePagePreview:PreviewProvider{
    static var previews: some View{
        HomePage()
    }
}
