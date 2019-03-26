//
//  MasterViewController.swift
//  Shopping app
//
//  Created by Dinesh Grag on 25/03/19.
//  Copyright © 2019 Dinesh Grag. All rights reserved.
//

import UIKit
import moltin

class MasterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let masterNibName = "CategoryCollectionViewCell"
    let moltin = Moltin(withClientID: "8E9WJmwE2oWV8tVNsu6SW65RmDmgT3WoD85gv4xENN")

    var categories: [ProductCategory] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

       self.collectionView.register(UINib(nibName: self.masterNibName, bundle: Bundle.main), forCellWithReuseIdentifier: self.masterNibName)

        
        moltin.product.all { (result: Result<PaginatedResponse<[ProductCategory]>>) in
                        switch result {
                        case .success(let response):
                            self.categories = response.data ?? []
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
            case .failure(let error):
                print(error)
            }
        }
        

        
        
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

extension MasterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemWidth: CGFloat = collectionView.frame.width
        
        return CGSize(width: itemWidth, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.masterNibName, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        let category = self.categories[indexPath.row]
        cell.categoryTitleLabel.text = category.name.uppercased()
        cell.categoryBackgroundImage.load(urlString: category.backgroundImage)
        cell.backgroundColor = UIColor.black

        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
            self.moltin.cart.addProduct(withID: category.id, ofQuantity: 1, toCart: AppDelegate.cartID, completionHandler: { (_) in
                DispatchQueue.main.async {
                    //test custom cart
                    let customCartPrice = CartItemPrice(amount: 111, includes_tax: false)
                    let customCartItem = CustomCartItem(withName: category.name, sku: "sku", quantity: 1, description: "test desc", price: customCartPrice)
                    print(customCartItem)
                    self.moltin.cart.addCustomItem(customCartItem, toCart: AppDelegate.cartID, completionHandler: {
                        
                        (_) in
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "DetailToCart", sender: nil)
                        }
                    })
                }
            })
            
        
    }
    
}


