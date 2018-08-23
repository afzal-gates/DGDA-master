//
//  CounterfeitController.swift
//  SidebarMenu
//
//  Created by Afzal on 3/24/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class CounterfeitController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //@IBOutlet weak var webUIView: UIWebView!
    
    @IBOutlet weak var webUIView: UIWebView!
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
        
        webUIView.loadRequest(URLRequest(url: URL(string: "http://103.48.16.179/complaints/counterfeit-mobile")!))
        
        self.dismiss(animated: false, completion: nil)
        
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

