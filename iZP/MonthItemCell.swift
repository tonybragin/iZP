//
//  MonthItemCell.swift
//  iZP
//
//  Created by TONY on 24/06/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit

class MonthItemCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var getInLabel: UILabel!
    @IBOutlet weak var getOutLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
