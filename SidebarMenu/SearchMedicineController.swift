//
//  SearchMedicineController.swift
//  ReportToDGDA
//
//  Created by Afzal on 3/25/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        //self.layer.masksToBounds = true
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        //self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.borderWidth = 3
    }
}

class SearchMedicineController: UIViewController, BarcodeDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    func barcodeReaded(barcode: String) {
        txtSearch.text = barcode
        print(barcode)
        removeBlurredBackgroundView()
    }
    
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
        
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    var list = ["1", "2", "3"]
    
    @IBAction func didPressButton(_ sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
         //   label.text = "Selected"
        } else{
         //   label.text = "Not Selected"
        }
    }
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var mId: [String] = []
    var names: [String] = []
    var manufacturer: [String] = []
    var mtype: [String] = []
    var mGeneric: [String] = []
    
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
                
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
    
    
    func downloadData() {
        let a = "http://103.48.16.179/api/fakeMedicineChecker/"
        let b = txtSearch.text!
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        
        //let url = URL(string:searchURL)
        mId = []
        names = []
        manufacturer = []
        mtype = []
        mGeneric = []
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    let aObject = allMedicins[index] as! [String : AnyObject]
                    mId.append(aObject["id"] as! String)
                    names.append(aObject["name"] as! String)
                    manufacturer.append(aObject["manufacturer_name"] as! String)
                    mtype.append(aObject["type"] as! String)
                    mGeneric.append(aObject["generic_name"] as! String)
                }
                
            }
            
        }
        catch {
            
            mId.append("0")
            names.append("Fake")
            manufacturer.append("")
            mtype.append("")
            mGeneric.append("")
        }
        
        self.tableView.reloadData()
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
    
    
    @IBAction func openScaner(_ sender: Any) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        self.overlayBlurredBackgroundView()
    }
    
    
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        
        view.addSubview(blurredBackgroundView)
        
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    @IBOutlet weak var btnQC: UIButton!
    @IBOutlet weak var btnQA: UIButton!
    
    var vQC: Int = 0
    var vQA: Int = 1
    
    let image1 = UIImage(named: "radio_1.png")
    let image2 = UIImage(named: "radio_2.png")
    
    @IBAction func toggleQC(_ sender: Any) {
        if vQC==0{
            btnQC.setImage(image2, for: .normal)
            btnQA.setImage(image1, for: .normal)
            vQC=1
            vQA=0
            txtSearch.text = ""
        }
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.overlayBlurredBackgroundView()
    }
    
    @IBAction func toggleQA(_ sender: Any) {
        if vQA==0{
            btnQA.setImage(image2, for: .normal)
            btnQC.setImage(image1, for: .normal)
            vQA=1
            vQC=0
            txtSearch.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCellDtl_V" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = names[indexPath.row] as! NSString
                let type = mtype[indexPath.row] as! NSString
                let mcompany = manufacturer[indexPath.row] as! NSString
                let ogeneric = mGeneric[indexPath.row] as! NSString
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.detailItemType = type
                controller.detailItemGeneric = ogeneric
                controller.detailItemCompany = mcompany
                
            }
            
        }
        
        if segue.identifier == "ShowModalView" {
            
            if let viewController = segue.destination as? BarcodeViewController {
                viewController.delegate = self
                viewController.modalPresentationStyle = .overFullScreen
            }
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchMedicineTableView
        
        cell.companyName.text = self.manufacturer[indexPath.row]
        cell.medicinName.text = self.names[indexPath.row]
        cell.genericName.text = self.mGeneric[indexPath.row]
        
        if self.names[indexPath.row] != "Fake" {
        
        cell.medicinImg.image = UIImage(named: "NoImage")
        cell.medicinImg.setRounded()
        cell.medicinType.image = UIImage(named: "capsule")
        cell.medicinType.setRounded()
        }
        return cell
    }
    
    
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
//        return 1
//        
//    }
    
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//
//        return list.count
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        self.view.endEditing(true)
//        return list[row]
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        self.textBox.text = self.list[row]
//        //self.dropDown.isHidden = true
//
//    }
    
    
}

