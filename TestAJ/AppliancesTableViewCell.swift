//
//  AppliancesTableViewCell.swift
//  testAlamofire
//
//  Created by user on 21/07/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
protocol AppliancesTableViewCellDelegate {
    func dropDowntapped(index:Int, section:Int)
}
class AppliancesTableViewCell: UITableViewCell {

    var delegate : AppliancesTableViewCellDelegate?

    @IBOutlet weak var myLabel: UILabel?
    @IBOutlet weak var mySubLabel: UILabel?
    @IBOutlet weak var myImageView: UIImageView?
    @IBOutlet weak var arrowImageView: UIImageView?
    @IBOutlet weak var enterCommentTextField: UITextField?
    @IBOutlet weak var enterTempTextField: UITextField?
    @IBOutlet weak var dropDownButton: UIButton?
    @IBOutlet weak var bgView: UIView?
    @IBOutlet weak var appliancesCellBottomHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var appliancestopHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var appliancesbottomConstraint: NSLayoutConstraint?

    @IBAction func dropDownClicked(_ sender: UIButton) {
        var section = dropDownButton?.tag ?? 0
        var row = enterCommentTextField?.tag ?? 0
        
        
        self.delegate?.dropDowntapped(index: row, section: section )
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView?.layer.borderColor = UIColor.init(colorLiteralRed: 218.0/255.0, green: 220.0/255.0, blue: 221.0/255.0, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
