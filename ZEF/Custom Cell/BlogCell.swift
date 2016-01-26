//
//  BlogCell.swift
//  ZEF
//
//  Created by Claudio 11/13/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

class BlogCell: UITableViewCell {
    
    @IBOutlet weak var appImgView: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usersLbl: UILabel!
    @IBOutlet weak var lastHourLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func getTypeImageName(name: String) -> String
    {
        var imageName = ""
        
        switch(name)
        {
        case "COMPARISON":
            imageName = "Comparison"
            break;
        case "SURVEY":
            imageName = "Survey"
            break;
        case "SELECTOR":
            imageName = "Selector"
            break;
        case "ELECTION":
            imageName = "Election"
            break;

        default:
            break;
        }
        
        return imageName
    }
}
