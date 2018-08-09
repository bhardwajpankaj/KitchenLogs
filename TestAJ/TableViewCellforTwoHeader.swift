//
//  TableViewCellforTwoHeader.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 23/07/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import SwiftyJSON
protocol TableViewCellforTwoHeaderDelegate {
    func tableViewCellforTwoHeaderFridgeDelegate(index:Int, temp: String , comment: String ,section:Int)
    func tableViewCellforTwoHeaderFreezerDelegate(index:Int, temp: String , comment: String,section:Int)
}
class TableViewCellforTwoHeader: UITableViewCell,UITableViewDataSource,UITableViewDelegate,AppliancesTableViewCellDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var mylabel: UILabel?
    
    @IBOutlet weak var myScrollView: UIScrollView?
//    var myTableView : UITableView?
//    var tableView1 : UITableView?
    var myTableView3 : UITableView?
    var gridIndex : NSInteger?
    var dictData : JSON?
    var delegate : TableViewCellforTwoHeaderDelegate?
    var newTableView : UITableView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gridIndex = 4
        // for var i in 0..<3{

        myScrollView?.isScrollEnabled = false
        //Appliances cell
        
        //  }
        
//        tableView1? = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 25 * 66))
//        tableView1?.dataSource = self
//        tableView1?.delegate = self
//        tableView1?.separatorColor = .clear
//        self.myScrollView?.addSubview(tableView1 ?? UITableView())
//        tableView1?.isScrollEnabled = false
//                tableView1?.backgroundColor = .black
//        //Appliances cell
//        tableView1?.register(UINib(nibName: "AppliancesTableViewCell", bundle: nil), forCellReuseIdentifier: "AppliancesTableViewCell")
        
        
        newTableView = UITableView()
        
        newTableView?.frame = CGRect(x:0, y: 0, width: screenSize.width, height: 40000)
        newTableView?.dataSource = self
        newTableView?.delegate = self
        newTableView?.separatorColor = .clear
        self.myScrollView?.addSubview(newTableView ?? UITableView())
        newTableView?.isScrollEnabled = false
//                newTableView?.backgroundColor = .red
        //Appliances cell
        newTableView?.register(UINib(nibName: "AppliancesTableViewCell", bundle: nil), forCellReuseIdentifier: "AppliancesTableViewCell")
        

        
        myTableView3 = UITableView(frame: CGRect(x: CGFloat(Int(screenSize.width) * 1), y: 0, width: screenSize.width, height: 40000))
        myTableView3?.dataSource = self
        myTableView3?.delegate = self
        myTableView3?.separatorColor = .clear
        self.myScrollView?.addSubview(myTableView3 ?? UITableView())
        myTableView3?.isScrollEnabled = false
        //        myTableView3?.backgroundColor = .white
        //Appliances cell
        myTableView3?.register(UINib(nibName: "AppliancesTableViewCell", bundle: nil), forCellReuseIdentifier: "AppliancesTableViewCell")
        
        
        myScrollView?.isPagingEnabled = true
        myScrollView?.contentSize = CGSize(width: 2.0 * screenSize.width, height: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(gridIndex == 4)
        {
            return 58
        }
        if(gridIndex == 5)
        {
            return 58
        }
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        view.backgroundColor = .white
        if(gridIndex == 4)
        {
            let label = UILabel(frame: CGRect(x: 10, y: 26, width: tableView.frame.size.width, height: 17))
            label.text = "FRIDGE (Under 8C)"
            label.font = UIFont(name: "Montserrat-Regular", size: 14)
            view.addSubview(label)
            
        }
        if(gridIndex == 5)
        {
            let label = UILabel(frame: CGRect(x: 10, y: 26, width: tableView.frame.size.width, height: 17))
            label.text = "Freezer (Under -18C)"
            label.font = UIFont(name: "Montserrat-Regular", size: 14)
            view.addSubview(label)
            
        }
        
        
        return view;
    }
    
    
    func setupCellContentWithHeight(height:CGFloat,index:NSInteger , dict:JSON){
        
        dictData = dict
        gridIndex = index
        if(gridIndex == 4 )
        {
            newTableView?.reloadData()
            myScrollView?.setContentOffset(CGPoint(x: screenSize.width * 0.0 ,y :0), animated: true)
            
            
        }else if(gridIndex == 5 )
        {
            myTableView3?.reloadData()
            myScrollView?.setContentOffset(CGPoint(x: screenSize.width * 1.0 ,y :0), animated: true)
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if(gridIndex == 4 )
        {
            
        if let  numberOfFridges = dictData?["entryDefaults"][0]["numberOfFridges"].int {
                numberOfRows = numberOfFridges
            }
        }else
        {
            
            if let  numberOfFreezers = dictData?["entryDefaults"][0]["numberOfFreezers"].int {
                numberOfRows = numberOfFreezers
            }
        }
        
        return numberOfRows
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath == self.selectedIndexPath) {
            let size = 122
            return CGFloat(size)
        }
        if(gridIndex == 4)
        {
            return 66
        }else if(gridIndex == 5)
        {
            return 66
        }else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = UITableViewCell()
        if(gridIndex == 4)
        {
        
            let cell: AppliancesTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AppliancesTableViewCell") as? AppliancesTableViewCell
        
            cell?.delegate = self
            cell?.enterTempTextField?.delegate = self
            cell?.enterCommentTextField?.delegate = self
            cell?.appliancesCellBottomHeightConstraint?.constant = -1
            cell?.dropDownButton?.tag = indexPath.section
            
            //            cell.setupCellContentWithHeight(height: 25 * 40)
            cell?.enterTempTextField?.tag = indexPath.row
            cell?.enterCommentTextField?.tag = indexPath.row
            cell?.enterCommentTextField?.placeholder = "\(8)" + "°C or below else add comment"

            cell?.myLabel?.text = "Fridge  " + "\(indexPath.row + 1)"
            cell?.myImageView?.image = #imageLiteral(resourceName: "fridgeIcon")
            cell?.mySubLabel?.text = "\(8)" + "°"

            return cell ?? customCell
        }else if(gridIndex == 5)
        {
            let cell: AppliancesTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AppliancesTableViewCell") as? AppliancesTableViewCell
            cell?.delegate = self
            cell?.enterTempTextField?.delegate = self
            cell?.enterCommentTextField?.delegate = self
            cell?.dropDownButton?.tag = indexPath.section
            cell?.enterTempTextField?.tag = indexPath.row
            cell?.enterCommentTextField?.tag = indexPath.row
            cell?.mySubLabel?.text = "\(-18)" + "°"
            cell?.enterCommentTextField?.placeholder = "-18°C or below else add comment"


            //            cell.setupCellContentWithHeight(height: 25 * 40)
            cell?.appliancesCellBottomHeightConstraint?.constant = -1
            cell?.myImageView?.image = #imageLiteral(resourceName: "freezer")
            cell?.myLabel?.text = "Freezer  " + "\(indexPath.row + 1)"
            return cell ?? UITableViewCell()
        }
        
        return customCell
    }
    func dropDowntapped(index:Int, section:Int)
    {
        let indexpath = NSIndexPath(row: index, section: 0)
        
            myTableView3?.reloadData()
            newTableView?.reloadData()
            if (indexpath as IndexPath == self.selectedIndexPath) {
                self.selectedIndexPath = nil
            }else{
                self.selectedIndexPath = indexpath as IndexPath
            }
        
        //        let indexpath = NSIndexPath(row: index, section: 1)
        //        if (indexpath as IndexPath == self.selectedIndexPath) {
        //            self.selectedIndexPath = nil
        //        }else{
        //            self.selectedIndexPath = indexpath as IndexPath
        //        }
    }
    internal var selectedIndexPath: IndexPath? {
        didSet{
            //(own internal logic removed)
            
            //these magical lines tell the tableview something's up, and it checks cell heights and animates changes
            if (gridIndex == 4) {
                newTableView?.beginUpdates()
                newTableView?.endUpdates()
            }else if(gridIndex == 5)
            {
                myTableView3?.beginUpdates()
                myTableView3?.endUpdates()
                
            }
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (gridIndex == 4) {
            let cell1 : AppliancesTableViewCell? = newTableView?.cellForRow(at: NSIndexPath(row: textField.tag, section: 0) as IndexPath) as? AppliancesTableViewCell
            
            self.delegate?.tableViewCellforTwoHeaderFridgeDelegate(index: textField.tag, temp: cell1?.enterTempTextField?.text ?? "", comment: cell1?.enterCommentTextField?.text ?? "",section:0)
            self.dropDowntapped(index: textField.tag ?? 0, section: 0)
        }else
        {
         let cell1 : AppliancesTableViewCell? = myTableView3?.cellForRow(at: NSIndexPath(row: textField.tag, section: 0) as IndexPath) as? AppliancesTableViewCell
        self.delegate?.tableViewCellforTwoHeaderFreezerDelegate(index: textField.tag, temp: cell1?.enterTempTextField?.text ?? "", comment: cell1?.enterCommentTextField?.text ?? "",section: 0)
            self.dropDowntapped(index: textField.tag ?? 0, section: 0)

        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
