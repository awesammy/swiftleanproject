//
//  PlayerAvailableCell.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-24.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit

class PlayerAvailableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var cellColorLabel: UILabel!
    @IBOutlet var cellNameLabel: UILabel!
    @IBOutlet var cellTimeLabel: UILabel!
    
    var dataId = ""

}
