//
//  DatePickupTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 29/07/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import UIKit

protocol DatePickupTableViewCellDelegate {
    func datePickupTableViewCellDelegateTapped(title:String , index:NSInteger)
}

class DatePickupTableViewCell: UITableViewCell {

   
    @IBOutlet weak var myLabel: UILabel?
    @IBOutlet weak var droButton: UIButton?
    
    
    var delegate :DatePickupTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    @IBAction func dropDownButtonCalled(_ sender: Any) {
        self.delegate?.datePickupTableViewCellDelegateTapped(title: "", index: 0)
    }
   
    
    func configueCellData(label:String, textField:String , dataArr : [String])
    {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
