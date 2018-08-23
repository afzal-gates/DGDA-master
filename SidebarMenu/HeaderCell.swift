//
//  HeaderCell.swift
//  ReportToDGDA
//
//  Created by Afzal on 3/26/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var toggleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
