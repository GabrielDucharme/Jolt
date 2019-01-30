//
//  HabitHeaderTableViewCell.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-01-29.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import UIKit

class HabitHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var habitDescription: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
