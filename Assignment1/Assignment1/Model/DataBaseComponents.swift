

//
//  DataBaseComponents.swift
//  Assignment1
//
//  Created by Inito on 07/08/23.
//

import Foundation
import FirebaseFirestore
import Alamofire
import RealmSwift
import CoreData

class DataBaseComponents{

    let db = Firestore.firestore()
    let realm = try? Realm()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let flag = false

    func fetchData() {
        let request = AF.request("https://www.inito.com/products/list")

        request.responseDecodable(of: Items.self) { [self] (response) in

            guard let res = response.value else {
                print("something went wrong")
                return
            }

            for itemInfo in res.products.monitor {
                if flag {
                    saveDataInFireStore(itemInfo)
                }else{
                    saveDataInRealmAndCoreData(itemInfo)
                }
            }

            for itemInfo in res.products.monitorPro {
                if flag {
                    saveDataInFireStore(itemInfo)
                }else{
                    saveDataInRealmAndCoreData(itemInfo)
                }
            }
            for itemInfo in res.products.reflective3TStrip {
                if flag {
                    saveDataInFireStore(itemInfo)
                }else{
                    saveDataInRealmAndCoreData(itemInfo)
                }
            }
            for itemInfo in res.products.reflectiveStrip {
                if flag {
                    saveDataInFireStore(itemInfo)
                }else{
                    saveDataInRealmAndCoreData(itemInfo)
                }
            }
            for itemInfo in res.products.transmissiveStrip {
                if flag {
                    saveDataInFireStore(itemInfo)
                }else{
                    saveDataInRealmAndCoreData(itemInfo)
                }
            }

        }

    }


    func changeStructToData(_ item: info) -> [String: Any]{
        let dataDict: [String: Any] = [
            "product_id": item.product_id,
            "checkout_url": item.checkout_url,
            "title": item.title,
            "price": item.price,
            "description": item.description,
            "shipping_info": item.shipping_info,
            "discounted_price": item.discounted_price,
            "image_url": item.image_url,
            "button_text": item.button_text
        ]
        return dataDict
    }


    func clearFirestoreData() {
      //  let collectionRef = DataBaseComponents.db.collection(FStore.collectionName)
        let collectionRef = db.collection(FStore.collectionName)

        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
                print("Firestore data cleared")
                self.fetchData()
            }
        }
    }




   func saveDataInFireStore(_ itemInfo: info){
       let dataDict = changeStructToData(itemInfo)
       db.collection(FStore.collectionName).addDocument(data: [FStore.itemInfo: dataDict]){(error) in
           if let e = error {
               print("Eroor : \(e)")
           }
           else{
               print("data base save info")
           }
       }
   }


    func saveDataInRealmAndCoreData(_ itemInfo: info){

        if let itemArray = realm?.objects(Product.self){
            for item in itemArray {
                if item.product_id == itemInfo.product_id{
                    return
                }
            }
        }



        let product = Product()
        product.button_text = itemInfo.button_text
        product.checkout_url = itemInfo.checkout_url
        product.product_id = itemInfo.product_id
        product.title = itemInfo.title


        do{
            try realm?.write{

                realm?.add(product)
            }
        }catch{
            print("error in saving context \(error)")
        }




        print("sdfsdfdsfs")

        let newProductCoreData = ProductCoreData(context: self.context)
        newProductCoreData.discountedPrice = itemInfo.discounted_price
        newProductCoreData.image_url = itemInfo.image_url
        newProductCoreData.price = itemInfo.price
        newProductCoreData.productDescripition = itemInfo.description
        newProductCoreData.product_id = itemInfo.product_id


        print(newProductCoreData)

        do{
            try context.save()
            print("saved")
        }catch{
            print("error in saving context \(error)")
        }

    }



    static let singletonDataBaseComponents = DataBaseComponents()
}

