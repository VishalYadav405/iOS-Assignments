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
            VStack{
                Text("Shop").font(.largeTitle)
                List{
                    
                    ForEach(shopItem, id: \.self) { item in
                        ItemCell(item: item)
                    }
                    
                }
            }
            .task{
                await fetchData()
            }
    }
    
    
    func fetchData() async {
      //  var shopData = [Info]()
        
        let request = AF.request("https://www.inito.com/products/list")

        request.responseDecodable(of: Items.self) { (response) in
           // print(response)

            guard let res = response.value else {
                print("something went wrong")
                return
            }

            for itemInfo in res.products.monitor {
               // print("---------Monitor-----------")
                shopItem.append(itemInfo)
            }

            for itemInfo in res.products.monitorPro {
                shopItem.append(itemInfo)
            }
            for itemInfo in res.products.reflective3TStrip {
                shopItem.append(itemInfo)
            }
            for itemInfo in res.products.reflectiveStrip {
                shopItem.append(itemInfo)
            }
            for itemInfo in res.products.transmissiveStrip {
                shopItem.append(itemInfo)
            }

        }
       // return shopData
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
        VStack(alignment: .leading){
            
            
            Image(uiImage: loadImage(item.image_url)!)
                .resizable()
                    .scaledToFit()
                    .cornerRadius(4)
                    .padding(.vertical, 4)
            
            Text(item.title).font(.headline)
            
            HStack{
                Text("Rs. \(item.discounted_price)")
                    .font(.title3)
                
                Spacer()
                Button {
                    print("Button pressed")
                } label: {
                    Text("Add to Cart")
                        .frame(width: 150, height: 30, alignment: .center)
                        
                        .background(.black)
                        .foregroundColor(.white)
                }.clipShape(Capsule())
                .padding(.trailing, 20)

            }
            
            Text(item.description)
                .font(.caption)
           

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
