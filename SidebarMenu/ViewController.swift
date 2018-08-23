//
//  ViewController.swift
//  SidebarMenu
//
//  Created by Afzal on 3/15/17.
//  Copyright © 2017 AppCoda. All rights reserved.SWRevealViewController
//

import Foundation
import SystemConfiguration

public var userId = "0"

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


class ViewController: UIViewController  {
    
    
    @IBOutlet var drop: DropMenuButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtNID: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtProfession: UITextField!
        
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var btnClear: UIButton!
    
    let cellReuseIdentifier = "cell"
    
    
    func verifyUrl(urlString: String?) ->Bool
    {
        if let urlString=urlString{
            if let url=URL(string: urlString){
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    @IBAction func saveData(_ sender: Any)
    {
        var btxt = (drop.titleLabel?.text!)! as String
        let row = cityList.index(of: btxt)
        
        if userId == "" {
            userId = "0"
        }
        
        let a:Int? = Int(userId)
        if a! > 0 {
        let json: Dictionary<String, Any> = ["id": userId,"name":txtName.text,"phone":txtPhone.text,"nid":txtNID.text,"address":txtAddress.text,"email": txtEmail.text, "profession":txtProfession.text,"division_id":cId[row!], "_method":"PATCH"]
        
        
        //let json: Dictionary<String, Any> = ["complaint_details":"Texhnovista Limited(TVL)","app_user_id":"2","submit_date":"20170401","complaint_type_id":16,"is_sms_notification": 0]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://103.48.16.179/api/appuserupdate")!
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
                
                
                //let x = responseJSON["message"] as! String
                //print(x)
                print(responseJSON)
                
                let uId = userId as! String
                
                var success: Bool
                
                success = DBManager.getSharedInstance().updateUserData(uId, name: self.txtName.text, nationalid: self.txtNID.text , address: self.txtAddress.text , phone: self.txtPhone.text , email: self.txtEmail.text , profession: self.txtProfession.text, city: String(self.cId[row!]))
            }
        }
        
        task.resume()
            
        }
        else{
            
            let json: Dictionary<String, Any> = ["name":txtName.text,"phone":txtPhone.text,"nid":txtNID.text,"address":txtAddress.text,"email": txtEmail.text, "profession":txtProfession.text,"division_id":cId[row!]]
            
            
            //let json: Dictionary<String, Any> = ["complaint_details":"Texhnovista Limited(TVL)","app_user_id":"2","submit_date":"20170401","complaint_type_id":16,"is_sms_notification": 0]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "http://103.48.16.179/api/appuser")!
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
                    
                    
                    let uId = String(responseJSON["user_id"] as! Int)
                    print(uId)
                    print(responseJSON)
                    
                    var success: Bool
                    
                    success = DBManager.getSharedInstance().saveUserData(uId, name: self.txtName.text, nationalid: self.txtNID.text , address: self.txtAddress.text , phone: self.txtPhone.text , email: self.txtEmail.text , profession: self.txtProfession.text, city: String(self.cId[row!]))
                    self.saveButton.setTitle( "UPDATE" , for: .normal )
                    
                    
                    self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                    
                }
            }
            
            task.resume()
            
        }
    
    }

    @IBAction func clearData(_ sender: Any) {
        txtName.text = ""
        txtNID.text = ""
        txtAddress.text = ""
        txtPhone.text = ""
        txtEmail.text = ""
        txtProfession.text = ""
        //drop.setTitle(cityList[0], for: .normal)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    var cId: [Int] = []
    var cityList: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()       
        
        cId=[]
        cityList = []
        
        let sUrl = "http://103.48.16.179/api/divisions"
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        
        do {
            let data = try Data(contentsOf: url as URL)
            
            var names = [String]()
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let citys = json?["data"] as? [[String: Any]]
            for city in citys! {
                
                if let ids = city["id"] as? Int {
                    cId.append(ids)
                    
                    if let name = city["name"] as? String {
                        names.append(name)
                        cityList.append(name)
                    }
                    
                }
                else{
                    cId.append(0)
                    
                    if let name = city["name"] as? String {
                        names.append(name)
                        cityList.append(name)
                    }
                }
            }
            
        }
        catch {
            
        }
        drop.initMenu(cityList)
        
    }
    
    override func viewDidLayoutSubviews()
    {
        // Assumption is we're supporting a small maximum number of entries
        // so will set height constraint to content size
        // Alternatively can set to another size, such as using row heights and setting frame
        //heightConstraint.constant = 120 //tableView.contentSize.height
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
            let data = DBManager.getSharedInstance().getUserData()
            if (data == nil) {
                //self.saveButton.titleLabel?.text =  "SAVE"
                self.saveButton.setTitle( "SAVE" , for: .normal )
                if self.cityList.count > 0 {
                    self.drop.setTitle( self.cityList[0], for: .normal )
                }
                else
                {
                    self.drop.setTitle( "-- Please Select --", for: .normal )
                }
            }
            else{
                if Int(userId) == 0 {
                    
                    userId = (data?[0] as! String?)!
                    
                    self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                    
                    //let yourVCObject = self.storyboard?.instantiateViewController(withIdentifier: "dashboard") as? DashboardController
                    
                    //self.present(yourVCObject!, animated: true, completion: nil)
                }
                else{
                    
                    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.view.tintColor = UIColor.black
                    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                    loadingIndicator.startAnimating();
                    
                    alert.view.addSubview(loadingIndicator)
                    
                    present(alert, animated: true, completion: nil)
                    
                    userId = (data?[0] as! String?)!
                    self.txtName.text = data?[1] as! String?
                    
                    self.txtNID.text = data?[2] as! String?
                    self.txtAddress.text = data?[3] as! String?
                    self.txtPhone.text = data?[4] as! String?
                    self.txtEmail.text = data?[5] as! String?
                    self.txtProfession.text = data?[6] as! String?
                    var cityId = data?[7] as! String?
                    
                    var row = self.cId.index(of: Int(cityId!)!)
                    if row == nil{
                        row = 0
                    }
                    self.drop.setTitle( self.cityList[row!], for: .normal )
                    
                    self.saveButton.setTitle( "UPDATE" , for: .normal )
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
//                    })
                    
                    self.dismiss(animated: false, completion: nil)
                }
            }
        
        
       
        //LoadingOverlay.shared.showOverlay(view: self.view)
        //To to long tasks
        //LoadingOverlay.shared.hideOverlayView()
        /*
        let turl = "http://www.google.com"
        
        if verifyUrl(urlString: turl) == true {
            let alert=UIAlertController(title: "Alert 1", message: "One has won", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
            //show it
            show(alert, sender: self);
        }
        
         if isInternetAvailable() == false {
         let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
         alert.show()
         } else {
         let alert = UIAlertView(title: "Internet Connection", message: "You are now connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
         alert.show()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "billInfo") as! SWRevealViewController
            self.present(secondViewController, animated: true, completion: nil)
         }
        */

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
