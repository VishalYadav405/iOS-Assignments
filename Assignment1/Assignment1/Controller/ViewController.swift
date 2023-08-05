//
//  ViewController.swift
//  Assignment1
//
//  Created by Inito on 29/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = false
//        navigationController?.title = "inito"
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        mobileNumberLabel.isHidden = true
        passwordLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    


    @IBAction func proceedPressed(_ sender: Any) {
        
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        mobileNumberLabel.isHidden = true
        passwordLabel.isHidden = true
        
        
        var verification:Bool = true
        
        let user = User(name: NameField.text!, emailId: emailField.text!, mobileNumber: mobileNumberField.text!, password: passwordField.text!)
        let userCheck = UserCheck(user: user)
        
        let nameConstrain = userCheck.checkName()
        if !nameConstrain.verify {
            nameLabel.text = nameConstrain.message
            nameLabel.isHidden = false
        }
        
        let emailIdConstrain = userCheck.checkEmailId()
        if !emailIdConstrain.verify {
            emailLabel.text = emailIdConstrain.message
            emailLabel.isHidden = false
        }
        
        let mobileNumberConstrain = userCheck.checkMobileNumber()
        if !mobileNumberConstrain.verify {
            mobileNumberLabel.text = mobileNumberConstrain.message
            mobileNumberLabel.isHidden = false
        }
        
        let passwordConstrain = userCheck.checkPassword()
        if !passwordConstrain.verify {
            passwordLabel.text = passwordConstrain.message
            passwordLabel.isHidden = false
        }
        
        verification = nameConstrain.verify && emailIdConstrain.verify && mobileNumberConstrain.verify && passwordConstrain.verify
        
        if !verification {
            return
        }
        
        self.performSegue(withIdentifier: "goToTabBar", sender: self)
       
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTabBar" {


            if let tabBarVC = (segue.destination as? UITabBarController) {

                if let firstViewController = tabBarVC.viewControllers?.first as? HomeViewController {
                    firstViewController.userName = NameField.text ?? ""
                    firstViewController.userEmailId = emailField.text ?? ""
                    firstViewController.userMobileNumber = mobileNumberField.text ?? ""
                    // firstViewController.receivedData = dataToSend
                }

            }

        }
        
    }
   
    
}

