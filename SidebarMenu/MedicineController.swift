//
//  MedicineController.swift
//  ReportToDGDA
//
//  Created by Afzal on 3/25/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit


class MedicineController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    struct News {
        let title : String
        let text : String
        let link : String
        
        init(dictionary: [String:String]) {
            self.title = dictionary["title"] ?? ""
            self.text = dictionary["text"] ?? ""
            self.link = dictionary["link"] ?? ""
        }
    }
    
    var newsData = [News]()
    var names: [String] = []
    var mId: [Int] = []
    var manufacturer: [String] = []
    var mtype: [String] = []
    var mGeneric: [String] = []
    
    
    func downloadData() {
        let a = "http://103.48.16.179/api/medicinesSearch/"
        let b = txtSearch.text!
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        names = []
        manufacturer = []
        mtype = []
        mGeneric = []
        mId = []
        
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    let aObject = allMedicins[index] as! [String : AnyObject]
                    
                    mId.append(aObject["id"] as! Int)
                    names.append(aObject["name"] as! String)
                    manufacturer.append(aObject["manufacturer_name"] as! String)
                    mtype.append(aObject["type"] as! String)
                    mGeneric.append(aObject["generic_name"] as! String)
                }
                
            }

            self.tableView.reloadData()
        }
        catch {
            
        }
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
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)        
        
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
        if segue.identifier == "showCellDtl" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let oId = mId[indexPath.row] as! NSInteger
                let object = names[indexPath.row] as! NSString
                let type = mtype[indexPath.row] as! NSString
                let mcompany = manufacturer[indexPath.row] as! NSString
                let ogeneric = mGeneric[indexPath.row] as! NSString
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItemId = oId
                controller.detailItem = object
                controller.detailItemType = type
                controller.detailItemGeneric = ogeneric
                controller.detailItemCompany = mcompany
                //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                //controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nameofTheSegue"
        {
            if segue.destination is DetailViewController{
                // do whatever you want with the data you want to pass.
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
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.companyName.text = self.manufacturer[indexPath.row]
        cell.medicinName.text = self.names[indexPath.row]
        cell.genericName.text = self.mGeneric[indexPath.row]
        cell.medicinImg.image = UIImage(named: "NoImage")
        cell.medicinImg.setRounded()
        cell.medicinType.image = UIImage(named: "capsule")
        cell.medicinType.setRounded()
                
        return cell
    }
    
    
    
    //func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     //   return "Section \(section)"
    //}
}
