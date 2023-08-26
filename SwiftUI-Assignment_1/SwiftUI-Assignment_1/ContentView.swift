//
//  ContentView.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.white, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                
                
                VStack{
                    Spacer()
                    Text("inito").font(.custom(.ExtendedGraphemeClusterLiteralType(), size: 60))
                    Text("Use Inito to understand your cycle. One test at a time")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView(), label: {
                        Text("SignUp")
                            .frame (width: 280, height: 50)
                            .foregroundColor (.white)
                            .background(RadialGradient(colors: [Color(.systemTeal), Color(.systemPurple)], center: .center, startRadius: 5, endRadius: 120))
                            .clipShape (Capsule())
                    
                    })
                        
                    
                    NavigationLink(destination: SignUpView(), label: {
                        Text("SignIn")
                            .frame (width: 280, height: 50)
                            .foregroundColor (.white)
                            .background(RadialGradient(colors: [Color(.systemTeal), Color(.systemPurple)], center: .center, startRadius: 5, endRadius: 120))
                            .clipShape (Capsule())
                    
                    }).padding(.bottom, 20)

                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
