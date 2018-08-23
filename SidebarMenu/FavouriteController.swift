//
//  FavouriteController.swift
//  ReportToDGDA
//
//  Created by Afzal on 3/30/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation


class FavouriteController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
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
    var mId: [String] = []
    var manufacturer: [String] = []
    var mtype: [String] = []
    var mGeneric: [String] = []
    
    var dictionary: NSMutableArray = []
    
    func downloadData() {
        
        //let url = URL(string:searchURL)
        names = []
        manufacturer = []
        mtype = []
        mGeneric = []
        mId = []
        do {
            
            let allMedicins = DBManager.getSharedInstance().getAllFavourite()
            
            dictionary = allMedicins!
            
            if (allMedicins?.count)!>0 {
                for index in 0...(allMedicins?.count)!-1 {
                    
                    let aObject = allMedicins?[index] as! NSMutableArray
                    mId.append(aObject[0] as! String)
                    names.append(aObject[1] as! String)
                    manufacturer.append(aObject[4] as! String)
                    mtype.append(aObject[2] as! String)
                    mGeneric.append(aObject[3] as! String)
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
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
        
        downloadData()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    var detailViewController: DetailViewController? = nil
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
        
        names = []
        manufacturer = []
        mtype = []
        mGeneric = []
        mId = []
        
        if searchText.isEmpty {
            searchTableView(data: dictionary)
            self.tableView.reloadData()
        }else {
            searchTableView(data: dictionary, text: searchText)
            self.tableView.reloadData()
        }
    }
    
    
    func searchTableView(data: NSMutableArray ,text:String) {
        if data.count>0 {
            for index in 0...data.count-1 {
                
                let aObject = data[index] as! NSMutableArray
                
                let name = aObject[1] as! String
                let mf = aObject[4] as! String
                let type = aObject[2] as! String
                let gen = aObject[3] as! String
                
                let stxt = text.uppercased()
                
                if(name.uppercased().contains(stxt) || mf.uppercased().contains(stxt) || type.uppercased().contains(stxt) || gen.uppercased().contains(stxt)){
                    
                    mId.append(aObject[0] as! String)
                    names.append(aObject[1] as! String)
                    manufacturer.append(aObject[4] as! String)
                    mtype.append(aObject[2] as! String)
                    mGeneric.append(aObject[3] as! String)
                }
                
            }
        }
    }
    
    func searchTableView(data: NSMutableArray) {
        if data.count>0 {
            for index in 0...data.count-1 {
                
                let aObject = data[index] as! NSMutableArray
                
                mId.append(aObject[0] as! String)
                names.append(aObject[1] as! String)
                manufacturer.append(aObject[4] as! String)
                mtype.append(aObject[2] as! String)
                mGeneric.append(aObject[3] as! String)
                
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
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
        
        downloadData()
        self.dismiss(animated: false, completion: nil)
        
        
        let image = UIImage(named: "bg.png")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        
        let hit=self.view.frame.height/4;
        let wdt=self.view.frame.width/2;
        
        let px = self.tableView.frame.midX/2.5;
        let py = self.tableView.frame.midY/2;
        
        iv.layer.frame = CGRect(x: px, y:py, width: wdt, height: hit)
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
        if segue.identifier == "showFavDtl" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let oId = mId[indexPath.row] as NSString
                let object = names[indexPath.row] as! NSString
                let type = mtype[indexPath.row] as! NSString
                let mcompany = manufacturer[indexPath.row] as! NSString
                let ogeneric = mGeneric[indexPath.row] as! NSString
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItemId = Int(oId as String)
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
