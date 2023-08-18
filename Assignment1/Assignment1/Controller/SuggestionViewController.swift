

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


    var itemDictionary: [String : info] = [:]
    var keys: [String] = []

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

                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }

                    }
                }
            }
        }else{



            productArray = realm?.objects(Product.self)

            if let notNilProductArray = productArray{
                for product in notNilProductArray {
                    itemDictionary[product.product_id] = info(product_id: product.product_id, checkout_url: product.checkout_url, title: product.title, price: "", description: "", shipping_info: "", discounted_price: "", image_url: "", button_text: product.title)
                }
            }




            let request = ProductCoreData.fetchRequest()
            do{
                productArrayCoreData = try context.fetch(request)
            }catch{
                print("Error in fatching data from context \(error)")
            }


            for product in productArrayCoreData{
                if itemDictionary.keys.contains(product.product_id ?? ""){

                    if let notNilProductId = product.product_id{
                        itemDictionary[notNilProductId]!.description = product.productDescripition ?? ""
                        itemDictionary[notNilProductId]!.discounted_price = product.discountedPrice ?? ""
                        itemDictionary[notNilProductId]!.product_id = product.product_id ?? ""
                        itemDictionary[notNilProductId]!.image_url = product.image_url ?? ""
                    }


                }
                else{
                    itemDictionary[product.product_id ?? ""] = info(product_id: "", checkout_url: "", title: "", price: "", description: product.productDescripition ?? "", shipping_info: product.productDescripition ?? "", discounted_price: product.discountedPrice ?? "", image_url: product.image_url ?? "", button_text: "")

                }

            }


            keys = Array(itemDictionary.keys)

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

            cell.itemPrice.text = "Rs. \(notNilInfoItem["discounted_price"] ?? "")"
            cell.ItemName.text = notNilInfoItem["title"]
            cell.itemDescription.text = notNilInfoItem["description"]
        }else{

            if let image = loadImage(itemDictionary[keys[indexPath.row]]?.image_url){
                cell.itemImage.image = image
            }
            cell.itemPrice.text = "Rs. \(String(describing: itemDictionary[keys[indexPath.row]]?.discounted_price))"
            cell.ItemName.text = itemDictionary[keys[indexPath.row]]?.title
            cell.itemDescription.text = itemDictionary[keys[indexPath.row]]?.description
            cell.itemPrice.text = itemDictionary[keys[indexPath.row]]?.discounted_price



//            if let image = loadImage(productArrayCoreData[indexPath.row].image_url){
//                cell.itemImage.image = image
//            }
//            cell.itemPrice.text = productArrayCoreData[indexPath.row].price
//            cell.ItemName.text = productArray?[indexPath.row].title
//            cell.itemDescription.text = productArrayCoreData[indexPath.row].productDescripition
//

        }

        return cell

    }

    func loadImage(_ imageUrl: String?) -> UIImage?{
        
        if let imageUrl = imageUrl{
            var img: UIImage?
            if let imageURL = URL(string: imageUrl){
                
//                DispatchQueue.global(qos: .userInitiated).async { [weak self]  in
//                    if let imageData = try? Data(contentsOf: imageURL),
//                       let image = UIImage(data: imageData) {
//                        img = image
//                    }
//
//                  }
              
                    if let imageData = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: imageData) {
                        img = image
                    }
                
            }
            return img
        }
        return nil
    }

}








