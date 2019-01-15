//
//  HabitTableViewCell.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-03-24.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {

    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var habitStartedAtLabel: UILabel!
    @IBOutlet weak var habitTimeSpentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
