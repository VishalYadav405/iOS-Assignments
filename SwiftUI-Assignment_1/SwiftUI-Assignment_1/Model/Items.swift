//
//  Items.swift
//  SwiftUI-Assignment_1
//
//  Created by Inito on 26/08/23.
//

import Foundation

struct Items: Codable {
    
    let products: Item
}

struct Item: Codable {
    let monitor: [Info]
    let monitorPro: [Info]
    let transmissiveStrip : [Info]
    let reflectiveStrip: [Info]
    let reflective3TStrip : [Info]
    
    enum CodingKeys: String, CodingKey {
        case monitor
        case monitorPro = "monitor-pro"
        case transmissiveStrip = "transmissive-strip"
        case reflectiveStrip = "reflective-strip"
        case reflective3TStrip = "reflective_3T_strip"

      }
}

struct Info: Codable, Hashable{
    
   // var id = UUID()
    var product_id: String
    var checkout_url: String
    var title: String
    var price: String
    var description: String
    var shipping_info: String
    var discounted_price: String
    var image_url: String
    var button_text: String

}

