//
//  SuggestionViewController.swift
//  Assignment1
//
//  Created by Inito on 29/07/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Alamofire
import CoreData
import RealmSwift

class SuggestionViewController: UIViewController {
    let dbComponents = DataBaseComponents.singletonDataBaseComponents
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var productArrayCoreData = [ProductCoreData]()

    var items: [ [String : Any] ] = []
    
    let realm = try? Realm()
    var productArray: Results<Product>?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)

            self.loadProductData()
    }
    
    func loadProductData(){
        if dbComponents.flag{
            items = []
            dbComponents.db.collection(FStore.collectionName).getDocuments { (quearySnapshot, error) in
                if let e = error {
                    print("ther is error in geting data \(e)")
                }else{
                    if let snapShotDoc = quearySnapshot?.documents{
                        for doc in snapShotDoc {
                            self.items.append(doc.data())
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }else{
            
            
            
            productArray = realm?.objects(Product.self)
            
            
            
            let request = ProductCoreData.fetchRequest()
            do{
                productArrayCoreData = try context.fetch(request)
            }catch{
                print("Error in fatching data from context \(error)")
            }
            print("realm \(productArray?.count)")
            print("coreData \(productArrayCoreData.count)")
            
        }
    }

}


extension SuggestionViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbComponents.flag ? items.count : (productArray?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ItemCell
        

        if dbComponents.flag{
            let item = items[indexPath.row][FStore.itemInfo]
            guard let infoItem = item, let notNilInfoItem = infoItem as? [String : String]  else {
                return cell
            }
            
            if let image = loadImage(notNilInfoItem["image_url"] ?? ""){
                cell.itemImage.image = image
            }
            
            cell.itemPrice.text = "Rs. \(notNilInfoItem["discounted_price"]!)"
            cell.ItemName.text = notNilInfoItem["title"]
            cell.itemDescription.text = notNilInfoItem["description"]
        }else{
            if let image = loadImage(productArrayCoreData[indexPath.row].image_url){
                cell.itemImage.image = image
            }
            cell.itemPrice.text = productArrayCoreData[indexPath.row].price
            cell.ItemName.text = productArray?[indexPath.row].title
            cell.itemDescription.text = productArrayCoreData[indexPath.row].productDescripition
  
            
        }

        return cell
        
    }
    
    func loadImage(_ imageUrl: String?) -> UIImage?{
        if let imageUrl = imageUrl{
            if let imageURL = URL(string: imageUrl){
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    return image
                }
            }
        }
        return nil
    }
    
}


