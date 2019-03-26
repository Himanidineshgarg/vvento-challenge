//
//  ProductCategory.swift
//  Shopping app
//
//  Created by Dinesh Grag on 25/03/19.
//  Copyright © 2019 Dinesh Grag. All rights reserved.
//


import UIKit
import moltin

class ProductCategory: moltin.Category {
    var backgroundColor: UIColor?
    var backgroundImage: String?

    enum ProductCategoryCodingKeys: String, CodingKey {
        case backgroundColor = "background_colour"
        case backgroundImage = "background_image"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductCategoryCodingKeys.self)
        if let color: String = try container.decodeIfPresent(String.self, forKey: .backgroundColor) {
            self.backgroundColor = UIColor(hexString: color)
        }
        self.backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        try super.init(from: decoder)
    }
}
