//
//  CompanyInfoController.swift
//  ReportToDGDA
//
//  Created by Md. Afzal Hossain on 7/26/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

class CompanyInfoController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
