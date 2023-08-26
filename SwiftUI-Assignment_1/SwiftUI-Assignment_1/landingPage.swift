//
//  landingPage.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//

import SwiftUI

struct landingPage: View {
    @Binding var user: UserInfo
    
    var body: some View {
        TabView{
            HomePage(user: $user)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
           
            HomePage(user: $user)
                .tabItem {
                    Image(systemName: "camera")
                    Text("Camera")
                }
            ShopView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Shop")
                }
        }
    }
}


//struct landingPage_Previews: PreviewProvider {
//    static var previews: some View {
//
//        landingPage(user: <#Binding<UserInfo>#>)
//    }
//}


