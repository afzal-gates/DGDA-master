//
//  ComplaintController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/8/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import UIKit



class ComplaintController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
    //,TKExamplesExampleViewController, TKCalendarDataSource, TKCalendarDelegate
{
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var btnRefresh: UIButton!
    
    var textField_Date: UITextField!
    var datePicker : UIDatePicker!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    
    var cStatus: [String] = []
    var cId: [Int] = []
    var cDetail: [String] = []
    var ctype: [String] = []
    var cDate: [String] = []
    var cSection: [String] = []
    var cSMS: [Int] = []
    
    
    var nStatus: [[String]] = []
    var nId: [[Int]] = []
    var nDetail: [[String]] = []
    var ntype: [[String]] = []
    var nDate: [[String]] = []
    var nSMS: [[Int]] = []
    
    var complaintViewController: ComplaintDetailsController? = nil
    var objects = [Any]()

    @IBAction func txtFromDateBeingEdit(_ sender: Any) {
        
        textField_Date = self.txtFromDate
        self.pickUpDate(textField_Date)
    }
    @IBAction func txtToDateBeingEdit(_ sender: Any) {
        textField_Date = self.txtToDate
        self.pickUpDate(textField_Date)

    }
    
       
    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
//        var frm : CGRect = textField.frame
//        var xy = frm.origin.y+50
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ComplaintController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ComplaintController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        //dateFormatter1.dateStyle = .short
        //dateFormatter1.timeStyle = .none
        textField_Date.text = dateFormatter1.string(from: datePicker.date)
        textField_Date.resignFirstResponder()
    }
    func cancelClick() {
        textField_Date.resignFirstResponder()
    }
    
    
    @IBAction func searchData(_ sender: Any) {
        
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
    }
    
    
    
    @IBAction func clearData(_ sender: Any) {
        self.txtFromDate.text = ""
        self.txtToDate.text = ""
        downloadData()
    }
    
    func downloadData() {
        var a = ""
        if txtFromDate.text != "" && txtToDate.text != "" {
            a = "http://103.48.16.179/api/complaintsDateBetween/" + self.txtFromDate.text! + "/" + self.txtToDate.text! + "/"
        }
        else if txtFromDate.text != "" || txtToDate.text != "" {
            let dt = self.txtFromDate.text! != "" ? self.txtFromDate.text!:self.txtToDate.text!
            a = "http://103.48.16.179/api/complaints/" + dt + "/"
        }
        else
        {
            a = "http://103.48.16.179/api/complaints/"
        }
        let b = "1" // userId
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        cStatus = []
        cDetail = []
        ctype = []
        cDate = []
        cId = []
        cSMS = []
        cSection = []
        
        nId = []
        nStatus = []
        nDetail = []
        ntype = []
        nDate = []
        nSMS = []
        
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    if let userDict = allMedicins[index] as? NSDictionary {
                        
                        cId.append(userDict["id"] as! Int)
                        cStatus.append(userDict["complaint_status"] as! String)
                        if !(userDict["complainType"] is NSNull) {
                            ctype.append(userDict["complainType"] as! String)
                        }
                        else
                        {
                           ctype.append("")
                        }
                        cDetail.append(userDict["complaint_details"] as! String)
                        
                        let date = userDict["submit_date"] as! String
                        
                        cDate.append(date)
                        
                        cSMS.append(userDict["is_sms_notification"] as! Int)
                        
                        if(!cSection.contains(date)){
                            if (cSection.count>0){
                                nId.append(cId)
                                nStatus.append(cStatus)
                                ntype.append(ctype)
                                nDetail.append(cDetail)
                                nDate.append(cDate)
                                nSMS.append(cSMS)
                                if((allMedicins.count-1)>index)
                                {
                                    cId=[]
                                    cStatus=[]
                                    ctype=[]
                                    cDetail=[]
                                    cSMS=[]
                                    cDate=[]
                                }
                            }
                            cSection.append(date)
                        }
                        
                    }
                    
                }
                
            }
            
            nId.append(cId)
            nStatus.append(cStatus)
            ntype.append(ctype)
            nDetail.append(cDetail)
            nDate.append(cDate)
            nSMS.append(cSMS)
            
            self.tableView.reloadData()
        }
        catch {
            
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
        
        self.btnSearch.setBackgroundImage(UIImage(named: "search_btn"), for: .normal)
        self.btnRefresh.setBackgroundImage(UIImage(named: "reset_btn"), for: .normal)
        
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
        //iv.layer.frame = CGRect(x: 80, y:40, width: 200, height: 200)
        let tableViewBackgroundView = UIView()
        tableViewBackgroundView.addSubview(iv)
        self.tableView.backgroundView = tableViewBackgroundView
        
        txtFromDate.leftViewMode = UITextFieldViewMode.always
        
        txtToDate.leftViewMode = UITextFieldViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x:txtFromDate.frame.size.width - (txtFromDate.frame.size.width + 30), y: 0, width: 20, height: 20))
        let image2 = UIImage(named: "ic_calendar_32")
        imageView2.image = image2
        txtFromDate.rightView = imageView2
        txtFromDate.rightViewMode = .always

        
        let imageView3 = UIImageView(frame: CGRect(x:txtToDate.frame.size.width - (txtToDate.frame.size.width + 30), y: 0, width: 20, height: 20))
        let image3 = UIImage(named: "ic_calendar_32")
        imageView3.image = image3
        txtToDate.rightView = imageView3
        txtToDate.rightViewMode = .always
        
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
        if segue.identifier == "showComplainWD" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let oId = nId[indexPath.section][indexPath.row]
                let object = nDetail[indexPath.section][indexPath.row] as NSString
                let type = ntype[indexPath.section][indexPath.row] as! NSString
//                let status = cStatus[indexPath.row] as NSString
                //let ogeneric = cDate[indexPath.row] as! NSString
                let sms = nSMS[indexPath.section][indexPath.row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! ComplaintDetailsController
                controller.detailItemId = oId
                controller.detailItemDetail = object
                controller.detailItemType = type
                controller.detailItemSMS = sms
                //controller.detailItemGeneric = ogeneric
                //controller.detailItemCompany = mcompany
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < cSection.count {
            return cSection[section]
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(white: 1, alpha: 0.5)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.blue
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nId[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotifyTableViewCell
        
        //cell.submitDate.text = self.cDate[indexPath.row]
        cell.complainDetails.text = self.nDetail[indexPath.section][indexPath.row]
        //cell.complainType.text = self.ctype[indexPath.row]
        cell.complaintStatus.text = self.nStatus[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
}
