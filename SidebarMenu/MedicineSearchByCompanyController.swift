//
//  MedicineSearchByCompanyController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation


class MedicineSearchByCompanyController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var mId: [Int] = []
    var names: [String] = []
    
    var animals: NSDictionary = [:]
    var animalSectionTitles: NSArray = []
    var animalIndexTitles: NSArray = []
    
    var myObject: NSMutableArray = []
    // A dictionary object
    var dictionary: [NSDictionary] = []
    // Define keys
    var ntitle: NSString = ""
    var thumbnail: NSString = ""
    var author: NSString = ""
    
    
    func downloadData() {
        
        let a = "http://103.48.16.179/api/manufacturer"
        let b = ""
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        mId = []
        names = []
        
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            dictionary = allMedicins
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    let aObject = allMedicins[index] as! [String : AnyObject]
                    
                    mId.append(aObject["id"] as! Int)
                    names.append(aObject["name"] as! String)
                    
                }
            }
        }
        catch {
            
        }
        
        animalIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
        
        self.tableView.reloadData()
    }
    
    
    var complaintViewController: ComplaintDetailsController? = nil
    var objects = [Any]()
    
    
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
        iv.layer.frame = CGRect(x: 80, y:self.tableView.frame.midY-100, width: 200, height: 200)
        let tableViewBackgroundView = UIView()
        tableViewBackgroundView.addSubview(iv)
        self.tableView.backgroundView = tableViewBackgroundView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        mId = []
        names = []
        
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
                
                if(name.uppercased().contains(text.uppercased())){
                    
                    mId.append(aObject["id"] as! Int)
                    names.append(aObject["name"] as! String)
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
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        cell.textLabel?.text = self.names[indexPath.row]
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        return 1
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        
//        //self.tableView.sectionIndexColor = UIColor.green
//        
//        return self.animalIndexTitles as? [String]
//    }
    
//    func tableView(tableView: UITableView, heightForSectionIndexTitles section: Int) -> CGFloat {
//        return 10.0
//    }
    
//    func tableView(_ tableView: UITableView, viewForSectionIndexTitle section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width+100, height:90))
//        footerView.backgroundColor =  UIColor.white
//        return footerView
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(section==0){
//            return 10.0
//        }
//        else
//        {
//            
//            return 20.0
//        }
//    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        let a = "http://103.48.16.179/api/manufacturer"
        let b = "" //title
        
        let sUrl = a + b
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        myObject = []
        mId = []
        names = []
        
        do {
            let allMedicineData = try Data(contentsOf: url as URL)
            let allMedicins = try JSONSerialization.jsonObject(with: allMedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            if allMedicins.count>0 {
                for index in 0...allMedicins.count-1 {
                    
                    let aObject = allMedicins[index] as! [String : AnyObject]
                    
                    mId.append(aObject["id"] as! Int)
                    names.append(aObject["name"] as! String)
                    
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
        if segue.identifier == "showCCellDtl" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let oId = mId[indexPath.row] as! NSInteger
                //let name = names[indexPath.row] as! NSString
                
                let controller = (segue.destination as! UINavigationController).topViewController as! MedicineSearchByLetterController
                controller.detailItemId = 2
                controller.detailItemDetail = String(oId) as NSString?
            }
        }
    }
    
    
}
