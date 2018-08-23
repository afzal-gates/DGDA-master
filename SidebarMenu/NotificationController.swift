//
//  NotificationController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/5/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation


class NotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var cStatus: [String] = []
    var cId: [Int] = []
    var cDetail: [String] = []
    var ctype: [String] = []
    var cDate: [String] = []
    var cSMS: [Int] = []
    var cAdvice: [String] = []
    
    var dictionary: [NSDictionary] = []
    
    
    func downloadData() {
        let a = "http://103.48.16.179/api/complaints/"
        let b = "1" //userId
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        cStatus = []
        cDetail = []
        ctype = []
        cDate = []
        cSMS = []
        cAdvice = []
        cId = []
        
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            dictionary = allMedicins
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    if let userDict = allMedicins[index] as? NSDictionary {
                       
                        cId.append(userDict["id"] as! Int)
                        cStatus.append(userDict["complaint_status"] as! String)
                        
                        let ct = nullToNil(value: userDict["complainType"] as AnyObject)
                        if ct == nil {
                            ctype.append("")
                        }
                        else
                        {
                            ctype.append(userDict["complainType"] as! String)
                        }
                        
                        cDetail.append(userDict["complaint_details"] as! String)
                        cDate.append(userDict["submit_date"] as! String)
                        
                        let av = nullToNil(value: userDict["complaint_report_advice"] as AnyObject)
                        if av == nil {
                            cAdvice.append("")
                        }
                        else
                        {
                            cAdvice.append(userDict["complaint_report_advice"] as! String)
                        }
                        
                        cSMS.append(userDict["is_sms_notification"] as! Int)
                    }
                }
            }
            
        }
        catch {
            
        }
        
        self.tableView.reloadData()
    }
    
    func nullToNil(value : AnyObject?) -> String? {
        if value is NSNull {
            return nil
        } else {
            return ""
        }
    }
    
    
    var complaintViewController: NotificationDetailsController? = nil
    var objects = [Any]()
    
    
    let searchBar = UISearchBar(frame: CGRect.zero)
    func searchBarSetup() {
        
        self.navBar.addSubview(searchBar)
        searchBar.sizeToFit()
        var frame = searchBar.frame
        frame.origin.x = frame.size.width-60
        frame.origin.y = -5
        frame.size.width = 60
        searchBar.frame = frame // set new frame with margins
        searchBar.delegate = self
        
    }
    
    // MARK: - search bar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // now reframe the searchBar to add some margins
        var frame = searchBar.frame
        frame.origin.x = 50
        frame.size.width = ((UIScreen.main.bounds.width)-60)
        searchBar.frame = frame // set new frame with margins
        searchBar.delegate = self
        
    }
    
    
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // now reframe the searchBar to add some margins
        
        cStatus = []
        cDetail = []
        ctype = []
        cDate = []
        cSMS = []
        cAdvice = []
        cId = []
        
        if searchText.isEmpty {
            searchTableView(data: dictionary as! [NSMutableDictionary])
            self.tableView.reloadData()
        }else {
            searchTableView(data: dictionary as! [NSMutableDictionary], text: searchText)
            self.tableView.reloadData()
        }
    }
    
    
    func searchTableView(data: [NSMutableDictionary] ,text:String) {
        if data.count>0 {
            for index in 0...data.count-1 {
                
                let userDict = data[index] as! [String : AnyObject]
                let name = userDict["complaint_details"] as! String
                
                let stxt = text.uppercased()
                
                if(name.uppercased().contains(stxt)){
                    
                    cId.append(userDict["id"] as! Int)
                    cStatus.append(userDict["complaint_status"] as! String)
                    
                    let ct = nullToNil(value: userDict["complainType"] as AnyObject)
                    if ct == nil {
                        ctype.append("")
                    }
                    else
                    {
                        ctype.append(userDict["complainType"] as! String)
                    }
                    
                    cDetail.append(userDict["complaint_details"] as! String)
                    cDate.append(userDict["submit_date"] as! String)
                    
                    let av = nullToNil(value: userDict["complaint_report_advice"] as AnyObject)
                    if av == nil {
                        cAdvice.append("")
                    }
                    else
                    {
                        cAdvice.append(userDict["complaint_report_advice"] as! String)
                    }
                    
                    cSMS.append(userDict["is_sms_notification"] as! Int)
                }
                
            }
        }
    }
    
    func searchTableView(data: [NSMutableDictionary]) {
        if data.count>0 {
            for index in 0...data.count-1 {
                
                let userDict = data[index] as! [String : AnyObject]
                
                cId.append(userDict["id"] as! Int)
                cStatus.append(userDict["complaint_status"] as! String)
                
                let ct = nullToNil(value: userDict["complainType"] as AnyObject)
                if ct == nil {
                    ctype.append("")
                }
                else
                {
                    ctype.append(userDict["complainType"] as! String)
                }
                
                cDetail.append(userDict["complaint_details"] as! String)
                cDate.append(userDict["submit_date"] as! String)
                
                let av = nullToNil(value: userDict["complaint_report_advice"] as AnyObject)
                if av == nil {
                    cAdvice.append("")
                }
                else
                {
                    cAdvice.append(userDict["complaint_report_advice"] as! String)
                }
                
                cSMS.append(userDict["is_sms_notification"] as! Int)
                
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBarSetup()
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
        
        downloadData()
        self.dismiss(animated: false, completion: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
                
        let image = UIImage(named: "bg.png")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        
        let hit=self.view.frame.height/4;
        let wdt=self.view.frame.width/2;
        
        let px = self.tableView.frame.midX/2.5;
        let py = self.tableView.frame.midY/2;
        
        iv.layer.frame = CGRect(x: px, y:py, width: wdt, height: hit)
        //iv.layer.frame = CGRect(x: 80, y:self.tableView.frame.midY-100, width: 200, height: 200)
        let tableViewBackgroundView = UIView()
        tableViewBackgroundView.addSubview(iv)
        self.tableView.backgroundView = tableViewBackgroundView
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.backgroundColor = .clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotify" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let oId = cId[indexPath.row] 
                let object = cDetail[indexPath.row] as NSString
                let type = ctype[indexPath.row] as NSString
                let status = cStatus[indexPath.row] as NSString
                let date = cDate[indexPath.row] as NSString
                let sms = cSMS[indexPath.row]
                let advice = cAdvice[indexPath.row] as NSString
                
                let controller = (segue.destination as! UINavigationController).topViewController as! NotificationDetailsController
                controller.detailItemId = oId
                controller.detailItemDetail = object
                controller.detailItemType = type
                controller.detailItemStatus = status
                controller.detailItemDate = date
                controller.detailItemSMS = String(sms) as NSString?
                controller.detailItemAdvice = advice
                
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotifyTableViewCell
        
        var type = self.cStatus[indexPath.row]
       
        //cell.submitDate.text = self.cDate[indexPath.row]
        cell.complainDetails.text = self.cDetail[indexPath.row]
        //cell.complainType.text = self.ctype[indexPath.row]
        //cell.complaintStatus.text = self.cStatus[indexPath.row]
        cell.iconButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 40)
        cell.iconButton.setTitle(String.fontAwesomeIcon(name: .flag ), for: .normal)
        if type != "Open" {
            cell.iconButton.titleLabel?.textColor = UIColor.black
        }
        return cell
    }
    
}
