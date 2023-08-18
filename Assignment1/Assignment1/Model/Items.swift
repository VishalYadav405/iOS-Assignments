//
//  Items.swift
//  Assignment1
//
//  Created by Inito on 05/08/23.
//

import Foundation

struct Items: Codable {
    
    let products: Item
}

struct Item: Codable {
    let monitor: [info]
    let monitorPro: [info]
    let transmissiveStrip : [info]
    let reflectiveStrip: [info]
    let reflective3TStrip : [info]
    
    enum CodingKeys: String, CodingKey {
        case monitor
        case monitorPro = "monitor-pro"
        case transmissiveStrip = "transmissive-strip"
        case reflectiveStrip = "reflective-strip"
        case reflective3TStrip = "reflective_3T_strip"

      }
}

struct info: Codable {    
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
