//import UIKit
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseAuth
//import Alamofire
//import CoreData
//import RealmSwift
//
//class SuggestionViewController: UIViewController {
//
//
//    var itemDictionary: [String : info] = [:]
//    var keys: [String] = []
//
//    let dbComponents = DataBaseComponents.singletonDataBaseComponents
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var productArrayCoreData = [ProductCoreData]()
//
//    var items: [ [String : Any] ] = []
//
//    let realm = try? Realm()
//    var productArray: Results<Product>?
//
//    var imageArray: [UIImage] = []
//
//
//    @IBOutlet weak var tableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
//
//        self.loadProductData()
//    }
//
//    func loadProductData(){
//        if dbComponents.flag{
//            items = []
//            dbComponents.db.collection(FStore.collectionName).getDocuments { (quearySnapshot, error) in
//                if let e = error {
//                    print("ther is error in geting data \(e)")
//                }else{
//                    if let snapShotDoc = quearySnapshot?.documents{
//                        for doc in snapShotDoc {
//                            self.items.append(doc.data())
//
//                        }
//                    }
//
//
//
//                    self.imageArray = []
//                    for i in 0..<self.items.count {
//                        let item = self.items[i][FStore.itemInfo]
//                        guard let infoItem = item, let notNilInfoItem = infoItem as? [String: String] else {
//                            return
//                        }
//                        Task{
//                            do{
//                                let image = try await self.loadImage(notNilInfoItem["image_url"])
//                                if let image = image {
//                                    self.imageArray.append(image)
//                                }
//                            }catch{
//                                print("error in loading image")
//                                return
//                            }
//
//                        }
//                    }
//
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }else{
//            productArray = realm?.objects(Product.self)
//
//            if let notNilProductArray = productArray{
//                for product in notNilProductArray {
//                    itemDictionary[product.product_id] = info(product_id: product.product_id, checkout_url: product.checkout_url, title: product.title, price: "", description: "", shipping_info: "", discounted_price: "", image_url: "", button_text: product.title)
//                }
//            }
//
//
//
//            let request = ProductCoreData.fetchRequest()
//            do{
//                productArrayCoreData = try context.fetch(request)
//            }catch{
//                print("Error in fatching data from context \(error)")
//            }
//
//
//            for product in productArrayCoreData{
//                if itemDictionary.keys.contains(product.product_id ?? ""){
//
//                    if let notNilProductId = product.product_id{
//                        itemDictionary[notNilProductId]!.description = product.productDescripition ?? ""
//                        itemDictionary[notNilProductId]!.discounted_price = product.discountedPrice ?? ""
//                        itemDictionary[notNilProductId]!.product_id = product.product_id ?? ""
//                        itemDictionary[notNilProductId]!.image_url = product.image_url ?? ""
//                    }
//
//
//                }
//                else{
//                    itemDictionary[product.product_id ?? ""] = info(product_id: "", checkout_url: "", title: "", price: "", description: product.productDescripition ?? "", shipping_info: product.productDescripition ?? "", discounted_price: product.discountedPrice ?? "", image_url: product.image_url ?? "", button_text: "")
//                }
//            }
//            keys = Array(itemDictionary.keys)
//            imageArray = []
//
//            for i in 0..<keys.count {
//                 Task{
//                     let url = itemDictionary[keys[i]]?.image_url
//                     do{
//                         let image = try await loadImage(url)
//                         if let image = image{
//                             imageArray.append(image)
//                         }
//                     }catch{
//                         print("error in loading image")
//                         return
//                     }
//
//                }
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//
//            }
//        }
//
//    }
//}
//
//
//extension SuggestionViewController: UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dbComponents.flag ? items.count : (productArray?.count ?? 0)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ItemCell
//
//
//        if dbComponents.flag{
//            let item = items[indexPath.row][FStore.itemInfo]
//            guard let infoItem = item, let notNilInfoItem = infoItem as? [String : String]  else {
//                return cell
//            }
//
//            if indexPath.row < imageArray.count {
//                cell.itemImage.image = imageArray[indexPath.row]
//            }
//
//            cell.itemPrice.text = "Rs. \(notNilInfoItem["discounted_price"] ?? "")"
//            cell.ItemName.text = notNilInfoItem["title"]
//            cell.itemDescription.text = notNilInfoItem["description"]
//        }else{
//
//            if indexPath.row < imageArray.count {
//                cell.itemImage.image = imageArray[indexPath.row]
//            }
//            cell.itemPrice.text = "Rs. \(String(describing: itemDictionary[keys[indexPath.row]]?.discounted_price))"
//            cell.ItemName.text = itemDictionary[keys[indexPath.row]]?.title
//            cell.itemDescription.text = itemDictionary[keys[indexPath.row]]?.description
//            cell.itemPrice.text = "Rs. \((itemDictionary[keys[indexPath.row]]?.discounted_price) ?? "")"
//
//
//        }
//
//        return cell
//
//    }
//
//    func loadImage(_ imageUrl: String?) async throws -> UIImage? {
//        guard let imageUrl = imageUrl,
//              let imageURL = URL(string: imageUrl) else {
//            return nil
//        }
//
//
//        let (data, _) = try await URLSession.shared.data(from: imageURL)
//            if let image = UIImage(data: data) {
//                return image
//            }
//
//
//        return nil
//    }
//
//}
//
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

    var imageArray: [UIImage] = []


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
                    }

                    self.imageArray = []
                    for i in 0..<self.items.count{
                        let item = self.items[i][FStore.itemInfo]
                        guard let infoItem = item, let notNilInfoItem = infoItem as? [String : String]  else {
                            return
                        }

                        if let image = self.loadImage(notNilInfoItem["image_url"] ?? ""){
                            self.imageArray.append(image)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
            imageArray = []

            for i in 0..<keys.count {
                if let image = loadImage(itemDictionary[keys[i]]?.image_url){
                    imageArray.append(image)
                }
            }




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

            if indexPath.row < imageArray.count {
                cell.itemImage.image = imageArray[indexPath.row]
            }

            cell.itemPrice.text = "Rs. \(notNilInfoItem["discounted_price"] ?? "")"
            cell.ItemName.text = notNilInfoItem["title"]
            cell.itemDescription.text = notNilInfoItem["description"]
        }else{

            if indexPath.row < imageArray.count {
                cell.itemImage.image = imageArray[indexPath.row]
            }
            cell.itemPrice.text = "Rs. \(String(describing: itemDictionary[keys[indexPath.row]]?.discounted_price))"
            cell.ItemName.text = itemDictionary[keys[indexPath.row]]?.title
            cell.itemDescription.text = itemDictionary[keys[indexPath.row]]?.description
            cell.itemPrice.text = "Rs. \((itemDictionary[keys[indexPath.row]]?.discounted_price) ?? "")"


        }

        return cell

    }

    func loadImage(_ imageUrl: String?) -> UIImage?{

        if let imageUrl = imageUrl{
            var img: UIImage?
            if let imageURL = URL(string: imageUrl){
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























//
//import UIKit
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseAuth
//import Alamofire
//import CoreData
//import RealmSwift
//
//class SuggestionViewController: UIViewController {
//
//
//    var itemDictionary: [String : info] = [:]
//    var keys: [String] = []
//
//    let dbComponents = DataBaseComponents.singletonDataBaseComponents
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var productArrayCoreData = [ProductCoreData]()
//
//    var items: [ [String : Any] ] = []
//
//    let realm = try? Realm()
//    var productArray: Results<Product>?
//
//    var imageArray: [UIImage] = []
//
//
//    @IBOutlet weak var tableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
//
//            self.loadProductData()
//    }
//
//    func loadProductData(){
//        if dbComponents.flag{
//            items = []
//            dbComponents.db.collection(FStore.collectionName).getDocuments { (quearySnapshot, error) in
//                if let e = error {
//                    print("ther is error in geting data \(e)")
//                }else{
//                    if let snapShotDoc = quearySnapshot?.documents{
//                        for doc in snapShotDoc {
//                            self.items.append(doc.data())
//
//                        }
//                    }
//
//                    self.imageArray = []
//                    for i in 0..<self.items.count{
//                        let item = self.items[i][FStore.itemInfo]
//                        guard let infoItem = item, let notNilInfoItem = infoItem as? [String : String]  else {
//                            return
//                        }
//
//                        Task{
//                            async let image = self.loadImage(notNilInfoItem["image_url"] ?? "")
//                            if let image = await image {
//                                self.imageArray.append(image)
//                            }
//
//                        }
//
//
//                    }
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }else{
//            productArray = realm?.objects(Product.self)
//
//            if let notNilProductArray = productArray{
//                for product in notNilProductArray {
//                    itemDictionary[product.product_id] = info(product_id: product.product_id, checkout_url: product.checkout_url, title: product.title, price: "", description: "", shipping_info: "", discounted_price: "", image_url: "", button_text: product.title)
//                }
//            }
//
//
//
//            let request = ProductCoreData.fetchRequest()
//            do{
//                productArrayCoreData = try context.fetch(request)
//            }catch{
//                print("Error in fatching data from context \(error)")
//            }
//
//
//            for product in productArrayCoreData{
//                if itemDictionary.keys.contains(product.product_id ?? ""){
//
//                    if let notNilProductId = product.product_id{
//                        itemDictionary[notNilProductId]!.description = product.productDescripition ?? ""
//                        itemDictionary[notNilProductId]!.discounted_price = product.discountedPrice ?? ""
//                        itemDictionary[notNilProductId]!.product_id = product.product_id ?? ""
//                        itemDictionary[notNilProductId]!.image_url = product.image_url ?? ""
//                    }
//
//
//                }
//                else{
//                    itemDictionary[product.product_id ?? ""] = info(product_id: "", checkout_url: "", title: "", price: "", description: product.productDescripition ?? "", shipping_info: product.productDescripition ?? "", discounted_price: product.discountedPrice ?? "", image_url: product.image_url ?? "", button_text: "")
//                }
//            }
//            keys = Array(itemDictionary.keys)
//            imageArray = []
//
//            for i in 0..<keys.count {
//                Task{
//                    let url = itemDictionary[keys[i]]?.image_url
//                    async let image = loadImage(url)
//
//                }
//            }
//
//
//
//
//        }
//    }
//
//}
//
//
//extension SuggestionViewController: UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dbComponents.flag ? items.count : (productArray?.count ?? 0)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ItemCell
//
//
//        if dbComponents.flag{
//            let item = items[indexPath.row][FStore.itemInfo]
//            guard let infoItem = item, let notNilInfoItem = infoItem as? [String : String]  else {
//                return cell
//            }
//
//            if indexPath.row < imageArray.count {
//                cell.itemImage.image = imageArray[indexPath.row]
//            }
//
//            cell.itemPrice.text = "Rs. \(notNilInfoItem["discounted_price"] ?? "")"
//            cell.ItemName.text = notNilInfoItem["title"]
//            cell.itemDescription.text = notNilInfoItem["description"]
//        }else{
//
//            if indexPath.row < imageArray.count {
//                cell.itemImage.image = imageArray[indexPath.row]
//            }
//            cell.itemPrice.text = "Rs. \(String(describing: itemDictionary[keys[indexPath.row]]?.discounted_price))"
//            cell.ItemName.text = itemDictionary[keys[indexPath.row]]?.title
//            cell.itemDescription.text = itemDictionary[keys[indexPath.row]]?.description
//            cell.itemPrice.text = "Rs. \((itemDictionary[keys[indexPath.row]]?.discounted_price) ?? "")"
//
//
//        }
//
//        return cell
//
//    }
//
//    func loadImage(_ imageUrl: String?) async -> UIImage?{
//
//        if let imageUrl = imageUrl{
//            var img: UIImage?
//            if let imageURL = URL(string: imageUrl){
//
//                    if let imageData = try? Data(contentsOf: imageURL),
//                       let image = UIImage(data: imageData) {
//                        img = image
//                    }
//
//            }
//            return img
//        }
//        return nil
//    }
//
////    func loadImage(_ urlString: String?) async -> UIImage? {
////        if let urlString = urlString {
////            let imageURL = URL(string: urlString)!
////            let request = URLRequest(url: imageURL)
////            let (data, _) = try? await URLSession.shared.data(for: request, delegate: nil)
////
////            print("Finished loading image")
////
////            imageArray.append(UIImage(data: data)!)
////            return UIImage(data: data)!
////        }
////        return nil
////    }
//
//
//}
