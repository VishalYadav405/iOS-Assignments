//
//  AppDelegate.swift
//  Assignment1
//
//  Created by Inito on 29/07/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
       // let db = Firestore.firestore()

        clearFirestoreData()
        
        
        func fetchData() {
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
        
      
        func changeStructToData(_ item: info) -> [String: Any]{
            let dataDict: [String: Any] = [
              "title": item.title,
              "button_text": item.button_text,
              "description": item.description,
              "discounted_price": item.discounted_price,
              "image_url": item.image_url
            ]
            return dataDict
        }
        
 
        func clearFirestoreData() {
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
        


        return true
    }
    

// MARK: UISceneSession Lifecycle

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

