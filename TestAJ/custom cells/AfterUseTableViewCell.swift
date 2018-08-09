//
//  AfterUseTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 26/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
protocol AfterUseTableViewCellDelegate {
    func crossButtonclicked(index:Int)
    func radioButtonClickedAfterUseTableViewCell(index:Int,radioSelected:String)
}
class AfterUseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var nnaImageView: UIImageView?

    @IBOutlet weak var radioButton: UIButton?
    @IBOutlet weak var crossButton: UIButton?

    var delegate : AfterUseTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        nnaImageView?.isHidden = true

        // Initialization code
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
        
        self.delegate?.radioButtonClickedAfterUseTableViewCell(index: crossButton?.tag ?? 0 ,radioSelected: value)
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
            crossButton?.isSelected = true
            nnaImageView?.isHidden = false
            self.alpha = 0.5
            radioButton?.isHidden = true

            radioButton?.isUserInteractionEnabled = false
        }
        self.delegate?.crossButtonclicked(index: sender.tag)

        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
