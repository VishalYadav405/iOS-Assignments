//
//  SuggestionViewController.swift
//  Assignment1
//
//  Created by Inito on 29/07/23.
//

import UIKit
import Alamofire
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SuggestionViewController: UIViewController {

    var items: [ [String : Any] ] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        let db = Firestore.firestore()
        
        
        
            self.loadProductData()
        
       
       // fetchFilms()
        // Do any additional setup after loading the view.
    }
    
    func loadProductData(){
        items = []
        
        db.collection(K.FStore.collectionName).getDocuments { (quearySnapshot, error) in
            if let e = error {
                print("ther is error in geting data \(e)")
            }else{
                if let snapShotDoc = quearySnapshot?.documents{
                    var i = 0
                    for doc in snapShotDoc {
                        self.items.append(doc.data())
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }

                    }
                }
            }
        }
    }
    
    

}


extension SuggestionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  var totalRow = 0
        //for i in 
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        var temp = item[K.FStore.itemInfo]

        var infoItem = temp!
        
        guard let notNilInfoItem = infoItem as? [String : String] else{
            return cell
        }
            
        
            
      //  print(item)
        print(item)
        if let imageURL = URL(string: notNilInfoItem["image_url"]!),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            cell.itemImage.image = image
        }
        cell.itemPrice.text = "Rs. \(notNilInfoItem["discounted_price"]!)"
        cell.ItemName.text = notNilInfoItem["title"]
        cell.itemDescription.text = notNilInfoItem["description"]
//        cell.buttonText.titleLabel = notNilInfoItem["button_text"]
        
       
        
        return cell
        
        
    }
    
    
}


