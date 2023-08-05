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
        
        let db = Firestore.firestore()
        DispatchQueue.main.async {
            clearFirestoreData()
        }
        
        /*DispatchQueue.main.async {
            fetchFilms()
        }*/
        
        
        
        func fetchFilms() {
            let request = AF.request("https://www.inito.com/products/list")
            
            request.responseDecodable(of: Items.self) { [self] (response) in
                
                guard let res = response.value else {
                    print("something went wrong")
                    return }
                //  self.items = []
                
                for temp in res.products.monitor {
                    //self.items.append(temp)
                    let dataDict = changeStructToData(temp)
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.itemInfo: dataDict]){(error) in
                        if let e = error {
                            print("Eroor : \(e)")
                        }
                        else{
                            print("data base save info")
                        }
                    }
                }
                for temp in res.products.monitorPro {
                    //  self.items.append(temp)
                    let dataDict = changeStructToData(temp)
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.itemInfo: dataDict])
                }
                for temp in res.products.reflective3TStrip {
                    // self.items.append(temp)
                    let dataDict = changeStructToData(temp)
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.itemInfo: dataDict])
                }
                for temp in res.products.reflectiveStrip {
                    //  self.items.append(temp)
                    let dataDict = changeStructToData(temp)
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.itemInfo: dataDict])
                }
                for temp in res.products.transmissiveStrip {
                    //  self.items.append(temp)
                    let dataDict = changeStructToData(temp)
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.itemInfo: dataDict])
                }
                
                
                
                
                
                
                //  self.tableView.reloadData()
                
            }
            
        }
        
        
        
        
        func changeStructToData(_ temp: info) -> [String: Any]{
            let dataDict: [String: Any] = [
              "title": temp.title,
              "button_text": temp.button_text,
              "description": temp.description,
              "discounted_price": temp.discounted_price,
              "image_url": temp.image_url
            ]
            return dataDict
        }
        
        
        
        
        
        func clearFirestoreData() {
            let collectionRef = db.collection(K.FStore.collectionName)
            
            collectionRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete()
                    }
                    print("Firestore data cleared")
                    fetchFilms()
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




//MARK: - fetch data


    


//MARK: - clear database



  

