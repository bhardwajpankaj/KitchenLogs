//
//  DatePickerView.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 23/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
