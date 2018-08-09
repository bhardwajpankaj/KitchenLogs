//
//  TextFieldTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 29/07/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import UIKit
protocol TextFieldTableViewCellDelegate {
    func textFieldTableViewCellDelegate(str:String)
}
class TextFieldTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var mytextField: UITextField?

    var delegate : TextFieldTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        mytextField?.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.delegate?.textFieldTableViewCellDelegate(str: mytextField?.text ?? "")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
