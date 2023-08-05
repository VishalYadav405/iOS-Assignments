//
//  UserCheck.swift
//  Assignment1
//
//  Created by Inito on 29/07/23.
//

import Foundation

struct UserCheck{
    var user:User
    
    func checkName() -> (message: String, verify: Bool){
        let name = user.name
        if name.count == 0 {
            return ("Name Field must not be empty", false)
        }
        else if name.count > 20{
            return ("Maximum length of name is 20", false)
        }
            
        return ("", true)
    }
    
    
    func checkEmailId() -> (message: String, verify: Bool){
        let emailId = user.emailId
        if emailId.count == 0 {
            return ("Email-Id Field must not be empty", false)
        }
        else if !(emailId.contains("@") && emailId.contains(".com")) {
            return ("Please enter correct Email-Id", false)
        }
        
        return ("", true)
        
    }
    
    func checkMobileNumber() -> (message: String, verify: Bool){
        let mobileNumber = user.mobileNumber
        if mobileNumber.count == 0 {
            return ("mobile Number Field must not be empty", false)
        }
        else if (mobileNumber.contains(where: { character in
            !character.isNumber
        }) ){
            return ("Please enter correct Number", false)
        }
        else if mobileNumber.count != 10 {
            return ("Please enter correct Number", false)
        }
        
        
        
        return ("", true)
        
    }
    
    func checkPassword() -> (message: String, verify: Bool){
        let password = user.password
        if password.count == 0 {
            return ("Password Field must not be empty", false)
        }
        else if password.count < 8{
            return ("length of password must be greater then 8 Character", false)
        }
        else if !(password.contains(where: { character in
            character.isNumber
        }) ){
            return ("password must contain minimum one number", false)
        }
        
        return ("", true)
    }
    
}
