//
//  MedicineSearchByLetterController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class MedicineSearchByLetterController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var mId: [Int] = []
    var names: [String] = []
    var manufacturer: [String] = []
    var mtype: [String] = []
    var mGeneric: [String] = []
    
    var animals: NSDictionary = [:]
    var animalSectionTitles: NSArray = []
    var animalIndexTitles: NSArray = []
    
    var myObject: NSMutableArray = []
    // A dictionary object
    var dictionary: [NSDictionary] = []
    var tmpDict: [NSDictionary] = []
    // Define keys
    var ntitle: NSString = ""
    var thumbnail: NSString = ""
    var author: NSString = ""
    
    
    func downloadData() {
        var a = ""
        
        if(uId=="")
        {
            a = "http://103.48.16.179/api/medicinesByLetter/A"
        }
        else if(uId=="1")
        {
            a = "http://103.48.16.179/api/medicinesByLetter/A/generic/"
        }
        else if(uId=="2")
        {
            a = "http://103.48.16.179/api/medicinesByLetter/A/manufacturer/"
        }
        
        let b = uName
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        mId = []
        names = []
        manufacturer = []
        mtype = []
        mGeneric = []
        
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            dictionary = allMedicins
            //tmpDict = allMedicins
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    let aObject = allMedicins[index] as! [String : AnyObject]
                    
                    mId.append(aObject["id"] as! Int)
                    names.append(aObject["name"] as! String)
                    manufacturer.append(aObject["manufacturer_name"] as! String)
                    mtype.append(aObject["type"] as! String)
                    mGeneric.append(aObject["generic_name"] as! String)
                    
//                    if let medicineDict = allMedicins[index] as? NSDictionary {
//                        myObject.add(medicineDict)
//                    }
                }
            }
        }
        catch {
            
        }
        
        animalIndexTitles = ["*       *","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
        
        self.tableView.reloadData()
    }
    
    
    public var uId = ""
    public var uName = ""
    
    
    var complaintViewController: ComplaintDetailsController? = nil
    var objects = [Any]()
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.detailItemId {
            uId = detail.description
        }
        
        if let detail = self.detailItemDetail {
            uName = detail.description
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

    
    let searchBar = UISearchBar(frame: CGRect.zero)
    func searchBarSetup() {
        
        navigationController?.navigationBar.addSubview(searchBar)
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
        
        mId = []
        names = []
        manufacturer = []
        mtype = []
        mGeneric = []
        
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
                
                let aObject = data[index] as! [String : AnyObject]
                let name = aObject["name"] as! String
                let mf = aObject["manufacturer_name"] as! String
                let type = aObject["type"] as! String
                let gen = aObject["generic_name"] as! String
                
                let stxt = text.uppercased()
                
                if(name.uppercased().contains(stxt) || mf.uppercased().contains(stxt) || type.uppercased().contains(stxt) || gen.uppercased().contains(stxt)){
                
                mId.append(aObject["id"] as! Int)
                names.append(aObject["name"] as! String)
                manufacturer.append(aObject["manufacturer_name"] as! String)
                mtype.append(aObject["type"] as! String)
                mGeneric.append(aObject["generic_name"] as! String)
                }
                
            }
        }
    }
    
    func searchTableView(data: [NSMutableDictionary]) {
        if data.count>0 {
            for index in 0...data.count-1 {
                
                let aObject = data[index] as! [String : AnyObject]
                
                mId.append(aObject["id"] as! Int)
                names.append(aObject["name"] as! String)
                manufacturer.append(aObject["manufacturer_name"] as! String)
                mtype.append(aObject["type"] as! String)
                mGeneric.append(aObject["generic_name"] as! String)
                
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.configureView()
        
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
        
        //self.tableView.contentInset = UIEdgeInsetsMake(-105, 0, 0, 0);
        
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchMedicineTableView
        if cell == nil {
            cell = SearchMedicineTableView(style: .subtitle, reuseIdentifier: "Cell")
        }
            
        cell.companyName.text = self.manufacturer[indexPath.row]
        cell.medicinName.text = self.names[indexPath.row]
        cell.genericName.text = self.mGeneric[indexPath.row]
        cell.medicinImg.image = UIImage(named: "NoImage")
        cell.medicinImg.setRounded()
        cell.medicinType.image = UIImage(named: "capsule")
        cell.medicinType.setRounded()
                
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
   
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        //self.tableView.sectionIndexColor = UIColor.green
        //self.tableView.sectionIndexBackgroundColor = UIColor.clear
        //self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blue
        return self.animalIndexTitles as? [String]
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        //self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableViewScrollPosition.top , animated: false)
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        var a = ""
        var c = title
        
        if(uId=="")
        {
            a = "http://103.48.16.179/api/medicinesByLetter/"
            a = a + c
        }
        else if(uId=="1")
        {
            var d = "/generic/"
            a = "http://103.48.16.179/api/medicinesByLetter/"
            a = a + c
            a = a + d
        }
        else if(uId=="2")
        {
            var d = "/manufacturer/"
            a = "http://103.48.16.179/api/medicinesByLetter/"
            a = a + c
            a = a + d
        }
        
        let b = uName
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        myObject = []
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
                    
                    mId.append(aObject["id"] as! Int)
                    names.append(aObject["name"] as! String)
                    manufacturer.append(aObject["manufacturer_name"] as! String)
                    mtype.append(aObject["type"] as! String)
                    mGeneric.append(aObject["generic_name"] as! String)
                    
//                    if let medicineDict = allMedicins[index] as? NSDictionary {
//                        myObject.add(medicineDict)
//                    }
                }
            }
        }
        catch {
            
        }
        
        self.tableView.reloadData()
        
        self.dismiss(animated: false, completion: nil)

        return 1
    }
    
    
    var detailViewController: DetailViewController? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMCellDtl" {
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
            }
        }
    }

    
}
