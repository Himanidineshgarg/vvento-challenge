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
  // let moltin: Moltin = Moltin(withClientID: "j6hSilXRQfxKohTndUuVrErLcSJWP15P347L6Im0M4", withLocale: Locale(identifier: "en_US"))

  // let moltin: Moltin = Moltin(withClientID: "8E9WJmwE2oWV8tVNsu6SW65RmDmgT3WoD85gv4xENN", withLocale: Locale(identifier: "en_US"))
   // let moltin: Moltin = Moltin(withClientID: "8E9WJmwE2oWV8tVNsu6SW65RmDmgT3WoD85gv4xENN")
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
        
//        self.moltin.category.include([.products]).all { (result: Result<PaginatedResponse<[ProductCategory]>>) in
//            switch result {
//            case .success(let response):
//                self.categories = response.data ?? []
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        
        
        
    }

   // }
//        self.moltin.product.all { result in
//            switch result {
//            case .success(let response):
//                print(response)
////                self.categories = response.data ?? []
////                                DispatchQueue.main.async {
////                                    self.collectionView.reloadData()
//                            }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailViewController,
            segue.identifier == "CategoriesToProducts",
            let category = sender as? ProductCategory {
            controller.products = category.products
            controller.category = category
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

        let itemWidth: CGFloat = collectionView.frame.width / 2

        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.masterNibName, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        let category = self.categories[indexPath.row]
        cell.categoryTitleLabel.text = category.name.uppercased()
        cell.categoryBackgroundImage.load(urlString: category.backgroundImage)
        cell.backgroundColor = category.backgroundColor
        cell.backgroundColor = UIColor.purple

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CategoriesToProducts", sender: self.categories[indexPath.row])
    }

}
