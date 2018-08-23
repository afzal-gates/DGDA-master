//
//  NotifyTableViewController.swift
//  ReportToDGDA
//
//  Created by Afzal on 4/5/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation



import UIKit

class NotifyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var complainDetails: UILabel!
    @IBOutlet weak var complainType: UILabel!
    @IBOutlet weak var complaintStatus: UILabel!
    @IBOutlet weak var isRead: UILabel!
    @IBOutlet weak var complaintAdvice: UILabel!
    @IBOutlet weak var isSms: UILabel!
    @IBOutlet weak var submitDate: UILabel!
    
    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
