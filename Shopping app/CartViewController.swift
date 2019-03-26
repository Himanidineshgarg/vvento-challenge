//
//  CartViewController.swift
//  Shopping app
//
//  Created by Dinesh Grag on 25/03/19.
//  Copyright © 2019 Dinesh Grag. All rights reserved.
//


import UIKit
import moltin

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let moltin = Moltin(withClientID: "8E9WJmwE2oWV8tVNsu6SW65RmDmgT3WoD85gv4xENN")

    
    var cartItems: [CartItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.moltin.cart.items(forCartID: AppDelegate.cartID) { (result) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.cartItems = result.data ?? []
                    print(self.cartItems)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkout(_ sender: Any) {
        let customer = Customer(withEmail: "himanidineshgarg@gmail.com", withName: "himani garg")
        let address = Address(withFirstName: "himani", withLastName: "garg")
        address.line1 = "New Aggarwal colony,Raikot"
        address.county = "Somewhere"
        address.country = "India"
        address.postcode = "141109"
        self.moltin.cart.checkout(cart: AppDelegate.cartID, withCustomer: customer, withBillingAddress: address, withShippingAddress: nil) { (result) in
            switch result {
            case .success(let order):
                self.payForOrder(order)
            default: break
            }
        }
    }

    func payForOrder(_ order: Order) {
        let paymentMethod = ManuallyAuthorizePayment()
        self.moltin.cart.pay(forOrderID: order.id, withPaymentMethod: paymentMethod) { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showOrderStatus(withSuccess: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showOrderStatus(withSuccess: false, withError: error)
                }
            }
        }
    }

    func showOrderStatus(withSuccess success: Bool, withError error: Error? = nil) {
        let title = success ? "Order paid!" : "Order error"
        let message = success ? "Complete!" : error?.localizedDescription
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.cartItems.count

    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        let cartItem = self.cartItems[indexPath.row]
        cell.textLabel?.text = String(format: "%@ %@", cartItem.name, "novel successfully added to cart.Please click on checkout button for payment.")
        cell.textLabel?.numberOfLines = 0;
        return cell
    }
}
