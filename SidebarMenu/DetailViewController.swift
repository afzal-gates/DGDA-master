//
//  DetailViewController.swift
//  ReportToDGDA
//
//  Created by Afzal on 3/25/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    public var mId = ""
    public var Presentations: String = ""
    public var Descriptions: String = ""
    public var Indication: String = ""
    public var Doase_Admin: String = ""
    public var SideEffect: String = ""
    public var Precaution: String = ""
    
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var typeLable: UILabel!
    
    @IBOutlet weak var genericLable: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var medicinImg: UIImageView!
    
//    let mIdLable: NSInteger
    
    
    struct Section {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = false) {
            self.name = name
            self.items = items
            self.collapsed = true
        }
    }
    
    var sections = [Section]()
    var x = 0
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.detailItemId {
            mId = detail.description
        }
        
        if let detail = self.detailItem {
            if let label = self.nameLable {
                label.text = detail.description
            }
        }
        
        if let detail = self.detailItemType {
            if let label = self.typeLable {
                label.text = detail.description
            }
        }

        if let detail = self.detailItemGeneric {
            if let label = self.genericLable {
                label.text = detail.description
            }
        }

        if let detail = self.detailItemCompany {
            if let label = self.companyLabel {
                label.text = detail.description
            }
        }
        
        
    }
    
    var detailPresentations: NSInteger? {
        didSet {
            self.configureView()
        }
    }
    
    var detailDescriptions: NSInteger? {
        didSet {
            self.configureView()
        }
    }
    var detailIndication: NSInteger? {
        didSet {
            self.configureView()
        }
    }
    var detailDoase_Admin: NSInteger? {
        didSet {
            self.configureView()
        }
    }
    var detailSideEffect: NSInteger? {
        didSet {
            self.configureView()
        }
    }
    var detailPrecaution: NSInteger? {
        didSet {
            self.configureView()
        }
    }
    
    
    var detailItemId: NSInteger? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var detailItem: NSString? {
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
    var detailItemGeneric: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var detailItemCompany: NSString? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    @IBAction func switchFav(_ sender: Any) {
        
        var success: Bool
        
        if x == 0 {
            x = 1
            
            self.btnFav.setBackgroundImage(UIImage(named: "fav_2"), for: UIControlState.normal)
            
            if (nameLable.text?.isEmpty==false)
            {
                success = DBManager.getSharedInstance().saveMedicineData(mId, name: nameLable.text, type: typeLable.text, generic_name: genericLable.text, manufacturer_name: companyLabel.text, medicine_image_path: "", presentation: self.Presentations, descriptions: self.Descriptions, indications: self.Indication, dosage_administration: self.Doase_Admin, side_effects: self.SideEffect, precaution: self.Precaution)
                
            }
            
            
        }
        else{
            x = 0
            self.btnFav.setBackgroundImage(UIImage(named: "fav_6"), for: UIControlState.normal)
            success = DBManager.getSharedInstance().deleteMedicineId(mId)
            
        }

    }
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        x = 0
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.medicinImg.image = UIImage(named: "NoImage")
        self.medicinImg.setRounded()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.configureView()
        
        let data = DBManager.getSharedInstance().getDataByMedicineId(mId)
        
        if data != nil {
            x = 0            
            self.btnFav.setBackgroundImage(UIImage(named: "fav_2"), for: UIControlState.normal)
        }
        else
        {
            x = 1
            self.btnFav.setBackgroundImage(UIImage(named: "fav_6"), for: UIControlState.normal)
        }
        
        let a = "http://103.48.16.179/api/medicineinfo/"
        let sUrl = a + mId
        
        let urlStr : NSString = sUrl.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let url : NSURL = NSURL(string: urlStr as String)!
        
        do {
            let MedicineData = try Data(contentsOf: url as URL)
            let Medicins = try JSONSerialization.jsonObject(with: MedicineData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            
            if let userDict = Medicins[0] as? NSDictionary {
                let p = userDict["presentation"] as? String
                if p == nil {
                    self.Presentations = ""
                }else {
                    return self.Presentations = p!
                }
                
                let d = userDict["descriptions"] as? String
                if d == nil {
                    self.Descriptions = ""
                }else {
                    return self.Descriptions = d!
                }
                
                let i = userDict["indications"] as? String
                if i == nil { self.Indication = "" }else {return self.Indication = i! }
                
                let dos = userDict["dosage_administration"] as? String
                if dos == nil { self.Doase_Admin = "" }else {return self.Doase_Admin = dos! }
                
                let s = userDict["side_effects"] as? String
                if s == nil { self.SideEffect = "" }else {return self.SideEffect = i! }
                
                
                let pre = userDict["precaution"] as? String
                if pre == nil { self.Precaution = "" }else {return self.Precaution = pre! }
                let price = userDict["price"] as? Int
                priceLabel.text = "Price: " + String(price!)
                
                sections = [
                    Section(name: "Presentations", items: [Presentations]),
                    Section(name: "Descriptions", items: [Descriptions]),
                    Section(name: "Indication", items: [Indication]),
                    Section(name: "Doages & Administration", items: [Doase_Admin]),
                    Section(name: "Side Effects", items: [SideEffect]),
                    Section(name: "Precaution", items: [Precaution])
                ]               
            }
        }
        catch {
            
        }
        
//        let imageView = UIImageView(frame: CGRect(x: 200, y: 0, width: 20, height: 20))
//        imageView.contentMode = UIViewContentMode.center
//        let image = UIImage(named: "bg.png")
//        imageView.image = image
        
//        let backgroundImage = UIImage(named: "bg.png")
//        let imageView = UIImageView(image: backgroundImage)
//        self.tableView.backgroundView = imageView
        
        let image = UIImage(named: "bg.png")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.layer.frame = CGRect(x: 80, y:40, width: 200, height: 200)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:  return "Manufacture"
//        case 1:  return "Products"
//        default: return ""
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }
        
        // For section 1, the total count is items count plus the number of headers
        var count = sections.count
        
        for section in sections {
            count += section.items.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.rowHeight
        }
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Header has fixed height
        if row == 0 {
            return 20.0
        }
        
        return sections[section].collapsed! ? 0 : 20.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
            cell.titleLabel.text = sections[section].name
            cell.toggleButton.tag = section
            //cell.toggleButton.setTitle(sections[section].collapsed! ? "+" : "-", for: .normal)
            cell.toggleButton.addTarget(self, action: #selector(toggleCollapse), for: .touchUpInside)
            
            cell.toggleButton.setBackgroundImage(UIImage(named: sections[section].collapsed! ? "plus" : "minus"), for: UIControlState.normal)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
            cell?.textLabel?.text = sections[section].items[row - 1]
            return cell!
        }
    }
    
    //
    // MARK: - Event Handlers
    //
    func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed!
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        let end = start + sections[section].items.count
        
        tableView.beginUpdates()
        for i in start ..< end + 1 {
            tableView.reloadRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    //
    // MARK: - Helper Functions
    //
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in sections {
            indices.append(index)
            index += section.items.count + 1
        }
        
        return indices
    }

    
}

