//
//  forImageDownloads.swift
//  Assignment1
//
//  Created by Inito on 22/08/23.
//

import Foundation
import UIKit

class ImageDownloader{
    
    var imageArray = [UIImage]()
    
    let imageURLArray = ["https://dqxth8lmt6m4r.cloudfront.net/assets/v1/reflective_monitor-5d3640f9e6550d48f3d12fb58af880b38a9d1345b35e7d2a1718386850af70d5.png", "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/reflective_monitor-5d3640f9e6550d48f3d12fb58af880b38a9d1345b35e7d2a1718386850af70d5.png","https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_10_no_discount-c5ebe5488dffb7c5bf468093116f2c0224c4de191c364c029f8367cbdffd5538.png", "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_10_no_discount-c5ebe5488dffb7c5bf468093116f2c0224c4de191c364c029f8367cbdffd5538.png",  "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_15_with_discount-20c3b131f10b2eac07c5bb16467a5da692d076869e46c83e8c1d01069218c689.png", "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_25_with_discount-d66f0b9ad958a6135e8afb77c1a4f6e1123344180f324f346e713f383538ecc5.png", "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_10_no_discount-c5ebe5488dffb7c5bf468093116f2c0224c4de191c364c029f8367cbdffd5538.png",  "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_15_with_discount-20c3b131f10b2eac07c5bb16467a5da692d076869e46c83e8c1d01069218c689.png", "https://dqxth8lmt6m4r.cloudfront.net/assets/v1/fertility_strips_pack_of_25_with_discount-d66f0b9ad958a6135e8afb77c1a4f6e1123344180f324f346e713f383538ecc5.png"
    ]
    
    func downloadImages(_ startingIndex: Int, completion: @escaping () -> Void) async{
        imageArray = []
        for index in startingIndex...(2*startingIndex - 1 ){
            async let num = loadImage(imageURLArray[index])
        }
        await imageArray
        
        print("downloaded image count is \(imageArray.count)")
        completion()
        
    }
    
    func loadImage(_ imageUrl: String?) async -> Int{

        if let imageUrl = imageUrl{
            if let imageURL = URL(string: imageUrl){
                    if let imageData = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: imageData) {
                        imageArray.append(image)
                        return 2
                    }
            }

        }
        return 0
    }

//    func loadImage(_ urlString: String?) async -> Int{
//        if let urlString = urlString {
//            let imageURL = URL(string: urlString)!
//            let request = URLRequest(url: imageURL)
//            do{
//                let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
//                imageArray.append(UIImage(data: data)!)
//                print("Finished loading image")
//                return 3
//            }catch{
//                print("error in downloadind Image")
//                return 2
//            }
//        }
//        return 0
//    }

    
}
