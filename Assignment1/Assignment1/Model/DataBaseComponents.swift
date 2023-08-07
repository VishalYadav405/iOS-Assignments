//
//  DataBaseComponents.swift
//  Assignment1
//
//  Created by Inito on 07/08/23.
//

import Foundation
import FirebaseFirestore
import Alamofire

struct DataBaseComponents{
    static let db = Firestore.firestore()
    
    static func fetchData() {
        let request = AF.request("https://www.inito.com/products/list")
        
        request.responseDecodable(of: Items.self) { [self] (response) in
            
            guard let res = response.value else {
                print("something went wrong")
                return
            }
            
            for item in res.products.monitor {
                let dataDict = changeStructToData(item)
                DataBaseComponents.db.collection(FStore.collectionName).addDocument(data: [FStore.itemInfo: dataDict]){(error) in
                    if let e = error {
                        print("Eroor : \(e)")
                    }
                    else{
                        print("data base save info")
                    }
                }
            }
            for item in res.products.monitorPro {
                let dataDict = changeStructToData(item)
                DataBaseComponents.db.collection(FStore.collectionName).addDocument(data: [FStore.itemInfo: dataDict])
            }
            for item in res.products.reflective3TStrip {
                let dataDict = changeStructToData(item)
                DataBaseComponents.db.collection(FStore.collectionName).addDocument(data: [FStore.itemInfo: dataDict])
            }
            for item in res.products.reflectiveStrip {
                let dataDict = changeStructToData(item)
                DataBaseComponents.db.collection(FStore.collectionName).addDocument(data: [FStore.itemInfo: dataDict])
            }
            for item in res.products.transmissiveStrip {
                let dataDict = changeStructToData(item)
                DataBaseComponents.db.collection(FStore.collectionName).addDocument(data: [FStore.itemInfo: dataDict])
            }
            
        }
        
    }
    
  
    static func changeStructToData(_ item: info) -> [String: Any]{
        let dataDict: [String: Any] = [
          "title": item.title,
          "button_text": item.button_text,
          "description": item.description,
          "discounted_price": item.discounted_price,
          "image_url": item.image_url
        ]
        return dataDict
    }
    

    static func clearFirestoreData() {
        let collectionRef = DataBaseComponents.db.collection(FStore.collectionName)
        
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
                print("Firestore data cleared")
                fetchData()
            }
        }
    }
}
