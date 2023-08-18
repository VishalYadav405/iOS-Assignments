//
//  Tab Bar ViewController.swift
//  Assignment1
//
//  Created by Inito on 29/07/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var userName:String = ""
    var userEmailId:String = ""
    var userMobileNumber:String = ""

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var emailId: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = "Name: \(userName)"
        emailId.text = "Email Id: \(userEmailId)"
        mobileNumber.text = "Mobile Number: \(userMobileNumber)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
