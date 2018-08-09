//
//  ChecklistTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 21/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
protocol ChecklistTableViewCellDelegate {
    func crossButtonclickedChecklistTableViewCell(index:Int)
    func radioButtonClickedChecklistTableViewCell(index:Int ,radioSelected:String)

}
class ChecklistTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel?
    var delegate : ChecklistTableViewCellDelegate?

    @IBOutlet weak var radioButton: UIButton?
    @IBOutlet weak var crossButton: UIButton?
    @IBOutlet weak var nnaImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nnaImageView?.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func radioButtonClicked(_ sender: UIButton) {
        
        var value = "NO"
        if(sender.isSelected)
        {
            value = "NO"
            sender.isSelected = false
            radioButton?.setImage(#imageLiteral(resourceName: "androidRadioButtonOn"), for: UIControlState.normal)
            
        }else
        {
            value = "YES"
            sender.isSelected = true
            radioButton?.setImage(#imageLiteral(resourceName: "shapeg"), for: UIControlState.selected)
            
        }
        self.delegate?.radioButtonClickedChecklistTableViewCell(index: crossButton?.tag ?? 0 ,radioSelected: value)

    }
    
    @IBAction func crossButtonClicked(_ sender: UIButton) {
        
        if(crossButton?.isSelected ?? false){
            crossButton?.isSelected = false
            nnaImageView?.isHidden = true
            radioButton?.isHidden = false

            self.alpha = 1
            radioButton?.isUserInteractionEnabled = true
        }else
        {
            radioButton?.isHidden = true

            crossButton?.isSelected = true
            nnaImageView?.isHidden = false
            self.alpha = 0.5
            radioButton?.isUserInteractionEnabled = false
        }
        
        self.delegate?.crossButtonclickedChecklistTableViewCell(index: sender.tag)
    }
    
    class func checklistTableViewCellHeight()->NSInteger {
        // type method
        return 84;
    }
}
