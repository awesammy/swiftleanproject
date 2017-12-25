//
//  PocketMainCell.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-25.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit

class PocketMainCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet var cellMyName: UILabel!
    @IBOutlet var cellPocketInfo: UILabel!
    @IBOutlet var cellMyAmount: UILabel!
}
