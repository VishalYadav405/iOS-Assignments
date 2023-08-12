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
    let product_id: String
    let checkout_url: String
    let title: String
    let price: String
    let description: String
    let shipping_info: String
    let discounted_price: String
    let image_url: String
    let button_text: String

}
