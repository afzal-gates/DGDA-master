//
//  MedicinesController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

class MedicinesController: UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let searchBar = UISearchBar(frame: CGRect.zero)
    func searchBarSetup() {
        
        
        //navigationController?.navigationBar.addSubview(searchBar)
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
       
        if searchText.isEmpty {
            //dataAry = initialDataAry
            self.tableView.reloadData()
        }else {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(ind:Int,text:String) {
        
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
    
    


}
