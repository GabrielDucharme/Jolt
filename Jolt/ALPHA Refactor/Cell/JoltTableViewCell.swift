//
//  JoltTableViewCell.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-04-30.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class JoltTableViewCell: UITableViewCell {

    @IBOutlet weak var joltContent: UILabel!
    @IBOutlet weak var joltCreatedOnLabel: UILabel!
    @IBOutlet weak var joltImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
