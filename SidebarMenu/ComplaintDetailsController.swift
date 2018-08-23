//
//  ComplaintDetailsController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/5/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import SystemConfiguration


class ComplaintDetailsController: UIViewController {
    
    var typeList : [String] = []
    var idList : [Int] = []
    
    @IBAction func clearUI(_ sender: Any) {
        self.drop.setTitle(typeList[0], for: .normal)
//        self.drop.setTitle( "-- Please Select --" , for: .normal )
        complainTextbox.text = ""
        isSMS.setOn(false, animated: false)
    }
    
    @IBAction func submitData(_ sender: Any)
    {
        var btxt = (drop.titleLabel?.text!)! as String
        let row = typeList.index(of: btxt)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.string(from: Date())
        
        let json: Dictionary<String, Any> = ["app_user_id": userId,"complaint_details":self.complainTextbox.text,"submit_date":date,"complaint_type_id":idList[row!],"is_sms_notification":"0"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://103.48.16.179/api/complaint")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: AnyObject] {
                
                let uId = responseJSON["message"] as! String
                print(uId)
                print(responseJSON)
                
            }
        }
        
        task.resume()
        
    
    }



    public var cId = ""
    public var cDetail = ""
    public var cType = ""
    public var cSMS = ""

    @IBOutlet weak var isSMS: UISwitch!
    
    @IBOutlet var drop: DropMenuButton!
    
    @IBOutlet weak var complainTextbox: UITextField!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var values = ["-- Please Select --","General", "Others", "Over Pricing"]
    
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
        
        if let detail = self.detailItemSMS {
            cSMS = detail.description
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
    
    var detailItemSMS: NSInteger? {
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
        
        let sUrl = "http://103.48.16.179/api/getComplaintTypes"
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        idList = []
        typeList = []
        
        do {
            let data = try Data(contentsOf: url as URL)
            //let allCitys = try JSONSerialization.jsonObject(with: allCityData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
            
            var names = [String]()
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let citys = json?["data"] as? [[String: Any]]
            for city in citys! {
                
                if let ids = city["id"] as? Int {
                    idList.append(ids)
                    
                    if let name = city["name"] as? String {
                        names.append(name)
                        typeList.append(name)
                    }
                    
                }
                else{
                    idList.append(0)
                    
                    if let name = city["name"] as? String {
                        names.append(name)
                        typeList.append(name)
                    }

                }
                
            }
            
            print(names)
            
        }
        catch {
            
        }
        
        drop.initMenu(typeList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        complainTextbox.text = cDetail
        
        var row = self.typeList.index(of: self.cType)
        if row == nil{
            row = 0
        }
        
        self.drop.setTitle( self.typeList[row!], for: .normal )
        
        if cSMS == "0"{
            self.isSMS.setOn(false, animated: false)
        }
        else
        {
            self.isSMS.setOn(true, animated: false)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
