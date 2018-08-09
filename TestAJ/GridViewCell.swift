//
//  GridViewCell.swift
//  testAlamofire
//
//  Created by user on 21/07/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
protocol GridViewCellDelegate {
    func buttonTapped(title:String , index:NSInteger)
    func markAllGridViewCellDelegateTapped(index:NSInteger)
}
class GridViewCell: UITableViewCell {

    @IBOutlet weak var checklistLbl: UILabel?
    @IBOutlet weak var appliancesLbl: UILabel?
    @IBOutlet weak var foodLbl: UILabel?
    
    @IBOutlet weak var radio1: UIImageView?
    @IBOutlet weak var radio2: UIImageView?
    @IBOutlet weak var radio3: UIImageView?

    @IBOutlet weak var markAllButton: UIButton?

    @IBOutlet weak var appliancesButton1: UIButton?
    @IBOutlet weak var appliancesButton2: UIButton?
    @IBOutlet weak var appliancesButtonBottom: UIView?
    @IBOutlet weak var appliancesView: UIView?
    @IBOutlet weak var appliancesBottomHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var gridRadioHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var viewAllHeightConstraint: NSLayoutConstraint?
    
    var delegate : GridViewCellDelegate?
    
    var fridgeBackView : Int = 0
    @IBAction func gridButtonClicked(_ sender: UIButton) {
        
        
        let title = self.setButtonUI(index: sender.tag)
        self.delegate?.buttonTapped(title: title, index: sender.tag)

    }
    
    @IBAction func markAllTapped(_ sender: UIButton) {
        
        self.delegate?.markAllGridViewCellDelegateTapped(index: sender.tag)
    }
    @IBAction func fridgeButtonClicked(_ sender: UIButton) {
        
        
        let title = self.setButtonUI(index: sender.tag)
        self.delegate?.buttonTapped(title: title, index: sender.tag)
        
    }
    
    func setButtonUI(index:NSInteger)->String{
        
        checklistLbl?.font = UIFont(name: "Montserrat-Regular", size: 14)
        appliancesLbl?.font = UIFont(name: "Montserrat-Regular", size: 14)
        foodLbl?.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        radio1?.image = #imageLiteral(resourceName: "radio")
        radio2?.image = #imageLiteral(resourceName: "radio")
        radio3?.image = #imageLiteral(resourceName: "radio")
        
        if (index == 0) {
            radio1?.image = #imageLiteral(resourceName: "androidRadioButtonChecked")
            markAllButton?.tag = 0

            checklistLbl?.font = UIFont(name: "Montserrat-Bold", size: 14)
            return (checklistLbl?.text) ?? ""
        }else if(index == 1)
        {
            radio2?.image = #imageLiteral(resourceName: "androidRadioButtonChecked")
            markAllButton?.tag = 1

            appliancesLbl?.font = UIFont(name: "Montserrat-Bold", size: 14)
            return (appliancesLbl?.text) ?? ""
            
        }else if(index == 2)
        {        markAllButton?.tag = 2

            radio3?.image = #imageLiteral(resourceName: "androidRadioButtonChecked")
            foodLbl?.font = UIFont(name: "Montserrat-Bold", size: 14)
            return (foodLbl?.text) ?? ""
        }else if(index == 4)
        {
            fridgeBackView = 4
            
            UIView.animate(withDuration: 0.2, animations: {
                self.appliancesButtonBottom?.frame = CGRect(x: (self.appliancesButton1?.frame.origin.x) ?? 0, y: (self.appliancesButton1?.frame.size.height) ?? 0, width: (self.appliancesButton1?.frame.size.width) ?? 0, height: 2)
            }, completion: {
                finished in
                self.appliancesButton1?.titleLabel?.textColor = UIColor.init(colorLiteralRed: 39.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
                self.appliancesButton2?.titleLabel?.textColor = UIColor.init(colorLiteralRed: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
            })
           

            return (appliancesButton1?.titleLabel?.text) ?? ""
        }else if(index == 5)
        {
            fridgeBackView = 5
            UIView.animate(withDuration: 0.2, animations: {
                self.appliancesButtonBottom?.frame = CGRect(x: (self.appliancesButton2?.frame.origin.x) ?? 0, y: (self.appliancesButton2?.frame.size.height) ?? 0, width: (self.appliancesButton2?.frame.size.width) ?? 0, height: 2)
            }, completion: {
                finished in
                self.appliancesButton1?.titleLabel?.textColor = UIColor.init(colorLiteralRed: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
                self.appliancesButton2?.titleLabel?.textColor = UIColor.init(colorLiteralRed: 39.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
            })
            
            
            return (appliancesButton2?.titleLabel?.text) ?? ""
        }
        return ""
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checklistLbl?.font = UIFont(name: "Montserrat-Bold", size: 14)
        markAllButton?.tag = 0

    }
    func configureGrid(titleArray:Array<String> , index:NSInteger)
    {
        checklistLbl?.text = titleArray[0]
        appliancesLbl?.text = titleArray[1]
        foodLbl?.text = titleArray[2]
        self.setButtonUI(index: index)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
