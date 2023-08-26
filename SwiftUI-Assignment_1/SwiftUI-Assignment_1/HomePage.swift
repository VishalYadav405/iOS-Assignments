//
//  HomePage.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//

import SwiftUI
import Foundation

struct HomePage: View {
    @State private var isShowingPhotoPicker = false
    @State private var avatarImage = UIImage(systemName: "person.fill")!
    
    @Binding var user: UserInfo
    
    
    
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            
            VStack(spacing: 5){
                Image(uiImage: avatarImage)
                    .resizable ()
                    .scaledToFill ()
                    .frame (width: 100, height: 100) .clipShape (Circle () )
                    .padding ()
                    .onTapGesture {
                        isShowingPhotoPicker = true
                    }
                
                Text("Name: \(user.userName)")
                Text("Email: \(user.emailId)")
                Text("Mobile Number: \(user.mobileNumber)")
                Text("Date of Birth: \(user.birthdate.formatted(date: .long, time: .omitted) )")
                
                
            }.sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(avatarImage: $avatarImage)
            }
        }
    }
}

//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
