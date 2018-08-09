//
//  HeaderTableViewCell.swift
//  testAlamofire
//
//  Created by user on 21/07/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
protocol HeaderTableViewCellDelegate {
    func datePickerDelegateMethod()
}
class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var mylabel: UILabel?
    @IBOutlet weak var datelabel: UILabel?
    @IBOutlet weak var checktitleView: UIView?
    
    var delegate : HeaderTableViewCellDelegate?

    
    @IBAction func datePicker(_ sender: UIButton) {
        self.delegate?.datePickerDelegateMethod()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checktitleView?.backgroundColor = .white
        checktitleView?.layer.borderColor = UIColor.init(colorLiteralRed: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1).cgColor

    }
    
    func configureCell(title:String)
    {
        mylabel?.text = title
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
