//
//  NotificationDetailsController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/13/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import SystemConfiguration


class NotificationDetailsController: UIViewController {
    
    public var cId = ""
    public var cDetail = ""
    public var cType = ""
    public var cDate = ""
    public var cStatus = ""
    public var cSMS = ""
    public var cAdvice = ""
    
    @IBOutlet weak var complainType: UILabel!
    
    @IBOutlet weak var complainDetails: UILabel!
    
    
    @IBOutlet weak var complainDate: UILabel!
    
    @IBOutlet weak var complainStatus: UILabel!
    
    @IBOutlet weak var complainSMS: UILabel!
    
    
    @IBOutlet weak var complainAdvice: UILabel!
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.detailItemId {
            cId = detail.description
        }
        
        if let detail = self.detailItemDetail {
            cDetail = detail.description
        }
        
        if let detail = self.detailItemType {
            cType = detail.description
        }
        
        
        if let detail = self.detailItemStatus {
            cStatus = detail.description
        }
        
        if let detail = self.detailItemDate {
            cDate = detail.description
        }
        
        
        if let detail = self.detailItemSMS {
            cSMS = detail.description
        }
        
        if let detail = self.detailItemAdvice {
            cAdvice = detail.description
        }
        
    }
    
    var detailItemId: NSInteger? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var detailItemDetail: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var detailItemType: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var detailItemDate: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var detailItemStatus: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var detailItemSMS: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var detailItemAdvice: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.configureView()
        
        if cSMS == "0" {
            cSMS = "disabled"
        }
        else
        {
            cSMS = "enabled"            
        }
        
        complainDetails.text = cDetail
        complainType.text = "Complain Type: " + cType
        complainDate.text = "Submit Date: " + cDate
        complainStatus.text = "Status: " + cStatus
        complainSMS.text = "SMS notification is " + cSMS
        complainAdvice.text = cAdvice
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
