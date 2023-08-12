//
//  Product.swift
//  Assignment1
//
//  Created by Inito on 12/08/23.
//

import Foundation
import RealmSwift

class Product: Object{
    @objc dynamic var product_id = ""
    @objc dynamic var checkout_url = ""
    @objc dynamic var title = ""
    @objc dynamic var button_text = ""
}
