//
//  UIImageView.swift
//  Shopping app
//
//  Created by Dinesh Grag on 25/03/19.
//  Copyright © 2019 Dinesh Grag. All rights reserved.
//

import UIKit

extension UIImageView {

    func load(urlString string: String?) {
        guard let imageUrl = string,
            let url = URL(string: imageUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
