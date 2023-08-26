//
//  ShopView.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//

import SwiftUI
import Alamofire

struct ShopView: View {
  //  var apicall = APICall.shared
    @State private var shopItem: [Info] = []
    var body: some View {
        
        
        NavigationView{
            
            List{
                ForEach(shopItem) { item in
                    ItemCell(item: item)
                }
            
        }
            .navigationTitle("Shop")
        }
        .task {
            shopItem = fetchData()
        }
    }
    
    
    func fetchData() -> [Info] {
        var shopData = [Info]()
        
        let request = AF.request("https://www.inito.com/products/list")

        request.responseDecodable(of: Items.self) { (response) in

            guard let res = response.value else {
                print("something went wrong")
                return
            }

            for itemInfo in res.products.monitor {
                shopData.append(itemInfo)
            }

            for itemInfo in res.products.monitorPro {
                shopData.append(itemInfo)
            }
            for itemInfo in res.products.reflective3TStrip {
                shopData.append(itemInfo)
            }
            for itemInfo in res.products.reflectiveStrip {
                shopData.append(itemInfo)
            }
            for itemInfo in res.products.transmissiveStrip {
                shopData.append(itemInfo)
            }

        }
        return shopData
    }
    
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}


struct ItemCell: View{
    var item: Info
    var body: some View{
        VStack{
            
            
            Image(uiImage: loadImage(item.image_url)!)
                .resizable()
                    .scaledToFit().frame(height: 70)
                    .cornerRadius(4)
                    .padding(.vertical, 4)
            
            
            

//            VStack(alignment: .leading, spacing: 5) {
//                Text(video.title).fontWeight(.semibold)
//                    .lineLimit(2)
//                    .minimumScaleFactor(0.5)
//
//                Text(video.uploadDate).font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
        }

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
