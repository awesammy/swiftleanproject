//
//  OthersPocketCell.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-25.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit

class OthersPocketCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellPocketButton.layer.cornerRadius = 10.0
        cellPocketButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var cellPocketButton: UIButton!
    @IBOutlet var cellSenderName: UILabel!
    @IBOutlet var cellSendTime: UILabel!
    
    var cellSenderPocketID = ""
    var cellSenderID = ""
    var cellPocketType = ""
}
