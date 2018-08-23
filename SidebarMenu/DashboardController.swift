//
//  DashboardController.swift
//  SidebarMenu
//
//  Created by Afzal on 3/24/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

//import Foundation

import UIKit


class DashboardController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var validateButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var medicineButton: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var complaintButton: UIButton!
    
    
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var AdrButton: UIButton!
    
    @IBOutlet weak var counterfeitButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //exit(0)
        //searchButton.font = UIFont.fontAwesome(ofSize: 80)
        //searchButton.text = String.fontAwesomeIcon(name: .github)
        
        //validateButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        //validateButton.setTitle(String.fontAwesomeIcon(name: .qrcode), for: .normal);
        
        validateButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        validateButton.titleLabel?.textAlignment = NSTextAlignment.center
        let str = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .qrcode)+"\nValidate")
        str.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        str.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 9))
        validateButton.setAttributedTitle(str, for: .normal)
        
        
//        searchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        searchButton.setTitle(String.fontAwesomeIcon(name: .search ), for: .normal)
        
        searchButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        searchButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strSrc = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .search)+"\nSearch")
        strSrc.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strSrc.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 7))
        searchButton.setAttributedTitle(strSrc, for: .normal)
        
//        medicineButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        medicineButton.setTitle(String.fontAwesomeIcon(name: .ambulance ), for: .normal)
        
        medicineButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        medicineButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strM = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .ambulance)+"\nMedicines")
        strM.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strM.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 10))
        medicineButton.setAttributedTitle(strM, for: .normal)
        
//        favouriteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        favouriteButton.setTitle(String.fontAwesomeIcon(name: .starO ), for: .normal)
        
        favouriteButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        favouriteButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strF = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .starO)+"\nFavourite")
        strF.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strF.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 10))
        favouriteButton.setAttributedTitle(strF, for: .normal)
        
//        complaintButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        complaintButton.setTitle(String.fontAwesomeIcon(name: .flag ), for: .normal)
        
        complaintButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        complaintButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strC = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .flag)+"\nComplaint")
        strC.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strC.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 10))
        complaintButton.setAttributedTitle(strC, for: .normal)
        
//        notificationButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        notificationButton.setTitle(String.fontAwesomeIcon(name: .bell ), for: .normal)
        
        notificationButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        notificationButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strN = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .bell)+"\nNotification")
        strN.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strN.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 13))
        notificationButton.setAttributedTitle(strN, for: .normal)
        
//        AdrButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        AdrButton.setTitle(String.fontAwesomeIcon(name: .dotCircleO ), for: .normal)
        
        AdrButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        AdrButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strA = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .dotCircleO)+"\nADR Reporting")
        strA.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strA.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 14))
        AdrButton.setAttributedTitle(strA, for: .normal)
        
//        counterfeitButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        counterfeitButton.setTitle(String.fontAwesomeIcon(name: .sunO ), for: .normal)
        
        counterfeitButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        counterfeitButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strCF = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .sunO)+"\nCounterfeit")
        strCF.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strCF.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 12))
        counterfeitButton.setAttributedTitle(strCF, for: .normal)
        
//        profileButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        profileButton.setTitle(String.fontAwesomeIcon(name: .user ), for: .normal)
        
        profileButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        profileButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strP = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .user)+"\nProfile")
        strP.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strP.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 8))
        profileButton.setAttributedTitle(strP, for: .normal)
        
        
//        aboutButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 80)
//        aboutButton.setTitle(String.fontAwesomeIcon(name: .briefcase ), for: .normal)
        
        aboutButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        aboutButton.titleLabel?.textAlignment = NSTextAlignment.center
        let strAb = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .briefcase)+"\nAbout Us")
        strAb.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 80), range: NSMakeRange(0, 1))
        strAb.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSMakeRange(1, 9))
        aboutButton.setAttributedTitle(strAb, for: .normal)
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.backImage.image = UIImage(named: "bg.png")
        //self.backImage.setRounded()
        
        validateButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        searchButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        medicineButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        favouriteButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        complaintButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        notificationButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        AdrButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        counterfeitButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        profileButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        aboutButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
    
    @IBAction func btnAbout(_ sender: Any) {
        
        let alert = UIAlertView(title: "Company Info", message: "Technovista Ltd.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
