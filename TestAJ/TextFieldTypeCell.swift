//
//  TextFieldTypeCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 22/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import DropDown

protocol TextFieldTypeCellDelegate {
    func buttonTapped(title:String , index:NSInteger)
    func textFieldTypeCellDelegateDroDownSelected(title:String , index:NSInteger , celltype:String)
}
class TextFieldTypeCell: UITableViewCell,UITextFieldDelegate {

//    @IBOutlet weak var myTextField: UITextField?
    @IBOutlet weak var myLabel: UILabel?
    @IBOutlet weak var droButton: UIButton?
    var dropDown: DropDown?
    var dropDownArray : [String]?
    var cellName = ""
    var delegate :TextFieldTypeCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown?.anchorView = droButton // UIView or UIBarButtonItem
        
//        dropDown?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        dropDown?.hide()
        
        DropDown.startListeningToKeyboard()

        
        
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.myLabel?.text = "\(item)"
            self.delegate?.textFieldTypeCellDelegateDroDownSelected(title: "\(item)", index: index, celltype:self.cellName)
        }

    }
    
    @IBAction func dropDownButtonCalled(_ sender: Any) {
        dropDown?.show()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    func configueCellData(label:String, textField:String , dataArr : [String])
    {
        dropDown?.dataSource = dataArr 
        dropDown?.reloadAllComponents()
//        myTextField?.attributedPlaceholder = NSAttributedString(string: textField,
//                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
