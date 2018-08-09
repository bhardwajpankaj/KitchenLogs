//
//  CommentTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 24/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
protocol CommentTableViewCellDelegate {
    func commentTableViewCellDelegate(str:String, cellName:String)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var myTextField: UITextField?

    @IBOutlet weak var myLabel: UILabel?
    var delegate :CommentTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.delegate?.commentTableViewCellDelegate(str: myTextField?.text ?? "", cellName: myLabel?.text ?? "")
    }
    
}
