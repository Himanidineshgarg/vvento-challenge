//
//  CustomProduct.swift
//  Shopping app
//
//  Created by Dinesh Grag on 25/03/19.
//  Copyright © 2019 Dinesh Grag. All rights reserved.
//

import UIKit
import moltin

class CustomProduct: Product {
    var backgroundColor: UIColor?

    enum ProductCodingKeys: String, CodingKey {
        case backgroundColor = "background_colour"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductCodingKeys.self)
        let color: String = try container.decode(String.self, forKey: .backgroundColor)
        self.backgroundColor = UIColor(hexString: color)
        try super.init(from: decoder)
    }
}
