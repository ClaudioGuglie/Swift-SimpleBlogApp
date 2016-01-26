//
//  ReportCell.swift
//  ZEF
//
//  Created by Claudio on 11/18/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}

