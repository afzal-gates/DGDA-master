//
//  SearchMedicineTableView.swift
//  ReportToDGDA
//
//  Created by Afzal on 3/25/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

import UIKit

class SearchMedicineTableView: UITableViewCell {
    
    
    @IBOutlet weak var medicinName: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var genericName: UILabel!
    @IBOutlet weak var medicinImg: UIImageView!
    @IBOutlet weak var medicinType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
