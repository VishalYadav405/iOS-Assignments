//
//  SignUpView.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//

import SwiftUI

struct SignUpView: View {
//    @State private var userName = ""
//    @State private var emailId = ""
//    @State private var mobileNumber = ""
//    @State private var password = ""
//    @State private var birthdate = Date()
//
    
    @State private var user = UserInfo(userName: "", emailId: "", mobileNumber: "", password: "", birthdate: Date())
    
    var body: some View {
        VStack{
            Text("Sign Up").font(.title3).frame(alignment: .center)
            Form{
                TextField("First Name", text: $user.userName)
                TextField("Email ID", text: $user.emailId)
                TextField("Mobile Number", text: $user.mobileNumber)
                TextField("Password", text: $user.password)
                DatePicker("Birth Date", selection: $user.birthdate, displayedComponents: .date)
                
                
                NavigationLink(destination: landingPage(user: $user), label: {
                    Text("Sign Up")
                        .frame (width: 280, height: 50)
                        .foregroundColor (.white)
                        .background(RadialGradient(colors: [Color(.systemTeal), Color(.systemPurple)], center: .center, startRadius: 5, endRadius: 120))
                        .clipShape (Capsule())
                    
                    
                })
                
            }
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
