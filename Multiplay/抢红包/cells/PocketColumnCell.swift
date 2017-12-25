//
//  PocketColumnCell.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-25.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit

class PocketColumnCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet var cellUserName: UILabel!
    @IBOutlet var cellUserTime: UILabel!
    @IBOutlet var cellUserAmount: UILabel!
}
