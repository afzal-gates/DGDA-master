//
//  ExitFromDGDAController.swift
//  SidebarMenu
//
//  Created by Afzal on 3/14/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ExitFromDGDAController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exit(0)
        /*
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            let alert = UIAlertView(title: "Internet Connection", message: "You are now connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }
 */
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
