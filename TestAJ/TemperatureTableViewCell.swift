//
//  TemperatureTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 24/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
protocol TemperatureTableViewCellDelegate {
    func temperatureTableViewCellDelegateSelected(degree:String , index:NSInteger , tempValue:String)
    func temperatureOnOff(index:NSInteger)
}
class TemperatureTableViewCell: UITableViewCell {

    @IBOutlet weak var mySwitch: UISwitch?
    @IBOutlet weak var myTextField: UITextField?
    @IBOutlet weak var muLabel: UILabel?
    @IBOutlet weak var celciusLabel: UILabel?

    @IBOutlet weak var fButton: UIButton?
    @IBOutlet weak var cButton: UIButton?
    var delegate :TemperatureTableViewCellDelegate?

    @IBOutlet weak var farenheitLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mySwitch?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);
//        mySwitch?.backgroundColor = UIColor.init(colorLiteralRed: 26.0/255.0, green: 174.0/255.0, blue: 136.0/255.0, alpha: 1)
        mySwitch?.onTintColor = UIColor.init(colorLiteralRed: 26.0/255.0, green: 174.0/255.0, blue: 136.0/255.0, alpha: 1)
        
        celciusLabel?.backgroundColor = UIColor.white
        celciusLabel?.textColor = UIColor.init(colorLiteralRed: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1)
        
        farenheitLabel?.backgroundColor = UIColor.init(red: 94.0/255.0, green: 201.0/255.0, blue: 213.0/255.0, alpha: 1)
        farenheitLabel?.textColor = UIColor.init(colorLiteralRed: 92.0/255.0, green: 120.0/255.0, blue: 121.0/255.0, alpha: 1)
        mySwitch?.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        
        self.delegate?.temperatureTableViewCellDelegateSelected(degree: "F", index: 0, tempValue: myTextField?.text ?? "")

    }
    
    func switchChanged(mySwitch: UISwitch) {
        if(mySwitch.isOn){
            self.alpha = 1
            myTextField?.isUserInteractionEnabled = true
            fButton?.isUserInteractionEnabled = true
            cButton?.isUserInteractionEnabled = true
            self.delegate?.temperatureOnOff(index: 1)
        }else
        {
            myTextField?.isUserInteractionEnabled = false
            fButton?.isUserInteractionEnabled = false
            cButton?.isUserInteractionEnabled = false
            self.alpha = 0.7
            self.delegate?.temperatureOnOff(index: 0)

        }
        // Do something
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func farenheitButtonClicked(_ sender: UIButton) {
        
        self.delegate?.temperatureTableViewCellDelegateSelected(degree: "F", index: 0, tempValue: myTextField?.text ?? "")
        celciusLabel?.backgroundColor = UIColor.init(red: 94.0/255.0, green: 201.0/255.0, blue: 213.0/255.0, alpha: 1)
        celciusLabel?.textColor = UIColor.init(colorLiteralRed: 92.0/255.0, green: 120.0/255.0, blue: 121.0/255.0, alpha: 1)
        farenheitLabel?.backgroundColor = UIColor.white
        farenheitLabel?.textColor = UIColor.init(colorLiteralRed: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1)
        fButton?.isSelected = true
        cButton?.isSelected = false
        
    }
    
    @IBAction func celciusButtonClicked(_ sender: UIButton) {
        self.delegate?.temperatureTableViewCellDelegateSelected(degree: "C", index: 0, tempValue: myTextField?.text ?? "")

        farenheitLabel?.backgroundColor = UIColor.init(red: 94.0/255.0, green: 201.0/255.0, blue: 213.0/255.0, alpha: 1)
        farenheitLabel?.textColor = UIColor.init(colorLiteralRed: 92.0/255.0, green: 120.0/255.0, blue: 121.0/255.0, alpha: 1)
        celciusLabel?.backgroundColor = UIColor.white
        celciusLabel?.textColor = UIColor.init(colorLiteralRed: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1)
        fButton?.isSelected = false
        cButton?.isSelected = true
        
    }
}
