//
//  ProbeRadioTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 29/07/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import UIKit

class ProbeRadioTableViewCell: UITableViewCell {

    @IBOutlet weak var mySwitch: UISwitch?
    @IBOutlet weak var muLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        mySwitch?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);
        mySwitch?.onTintColor = UIColor.init(colorLiteralRed: 26.0/255.0, green: 174.0/255.0, blue: 136.0/255.0, alpha: 1)
//        mySwitch?.setalter = UIColor.init(colorLiteralRed: 26.0/255.0, green: 174.0/255.0, blue: 136.0/255.0, alpha: 1)
    }
    
}
