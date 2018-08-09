//
//  TableViewCell2.swift
//  testAlamofire
//
//  Created by user on 21/07/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol TableViewCell2Delegate {
    func tableViewCell2DelegateRadioClicked(index:Int, gridNo:NSInteger , isSelected: String)
    
    func tableViewCell2FridgeDelegate(index:Int, temp: String , comment: String)
    func tableViewCell2FreezerDelegate(index:Int, temp: String , comment: String)

    func tableViewCell2FoodDelegate(index:Int, temp: String , comment: String , section : Int)

}

class TableViewCell2: UITableViewCell,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AfterUseTableViewCellDelegate,AppliancesTableViewCellDelegate,ChecklistTableViewCellDelegate {
    
    func radioButtonClickedAfterUseTableViewCell(index: Int ,radioSelected:String) {
        self.delegate?.tableViewCell2DelegateRadioClicked(index: index, gridNo: gridIndex ?? 0 , isSelected: radioSelected)
    }
    
    func crossButtonclickedChecklistTableViewCell(index:Int)
    {
        
    }
    func radioButtonClickedChecklistTableViewCell(index: Int, radioSelected: String) {
    
        self.delegate?.tableViewCell2DelegateRadioClicked(index: index, gridNo: gridIndex ?? 0 , isSelected: radioSelected)

    }

    
    @IBOutlet weak var mylabel: UILabel?
    
    @IBOutlet weak var myScrollView: UIScrollView?
    
    var delegate : TableViewCell2Delegate?
    var myTableView : UITableView?
    var myTableView2 : UITableView?
    var myTableView3 : UITableView?
    var gridIndex : NSInteger?
    var screen : String?
    var dictData : JSON?
    var isMarkAll :Bool?
    var refreshData = false
    var refreshDataForPage = false
    
    var minCookingTemp = 0
    var reHeatingTemp = 0
    var hotHoldingTemp = 0
    var fridgeTemp = 0
    
    var hotHoldingNameArray = NSMutableArray()
    var cookedNameArray = NSMutableArray()
    var reheatingNameArray = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gridIndex = 0
        // for var i in 0..<3{
        myTableView = UITableView(frame: CGRect(x: CGFloat(Int(screenSize.width) * 0), y: 0, width: screenSize.width, height: 30000))
        myTableView?.dataSource = self
        myTableView?.delegate = self
        myTableView?.separatorColor = .clear
        myTableView?.isScrollEnabled = false
//                    myTableView?.backgroundColor = .random
        myTableView?.register(UINib(nibName: "ChecklistTableViewCell", bundle: nil), forCellReuseIdentifier: "ChecklistTableViewCell")
        myTableView?.register(UINib(nibName: "AfterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "AfterUseTableViewCell")
        self.myScrollView?.addSubview(myTableView ?? UITableView())
        myScrollView?.isScrollEnabled = false
        //Appliances cell
        
        //  }
        
        myTableView2 = UITableView(frame: CGRect(x: CGFloat(Int(screenSize.width) * 1), y: 0, width: screenSize.width, height: 30000))
        myTableView2?.dataSource = self
        myTableView2?.delegate = self
        myTableView2?.separatorColor = .clear
        self.myScrollView?.addSubview(myTableView2 ?? UITableView())
        myTableView2?.isScrollEnabled = false
//                myTableView2?.backgroundColor = .random
        //Appliances cell
        myTableView2?.register(UINib(nibName: "AppliancesTableViewCell", bundle: nil), forCellReuseIdentifier: "AppliancesTableViewCell")
        myTableView2?.register(UINib(nibName: "ChecklistTableViewCell", bundle: nil), forCellReuseIdentifier: "ChecklistTableViewCell")
        myTableView2?.register(UINib(nibName: "AfterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "AfterUseTableViewCell")

        
        myTableView3 = UITableView(frame: CGRect(x: CGFloat(Int(screenSize.width) * 2), y: 0, width: screenSize.width, height: 30000))
        myTableView3?.dataSource = self
        myTableView3?.delegate = self
        myTableView3?.separatorColor = .clear
        self.myScrollView?.addSubview(myTableView3 ?? UITableView())
        myTableView3?.isScrollEnabled = false
//                myTableView3?.backgroundColor = .white
        //Appliances cell
        myTableView3?.register(UINib(nibName: "AppliancesTableViewCell", bundle: nil), forCellReuseIdentifier: "AppliancesTableViewCell")
        myTableView3?.register(UINib(nibName: "ChecklistTableViewCell", bundle: nil), forCellReuseIdentifier: "ChecklistTableViewCell")
        myTableView3?.register(UINib(nibName: "AfterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "AfterUseTableViewCell")

        
        myScrollView?.isPagingEnabled = true
        myScrollView?.contentSize = CGSize(width: 3.0 * screenSize.width, height: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (gridIndex == 0)
        {
            return 0
        }else if(gridIndex == 1)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check") ?? false)
            {
                return 0
            }
            return 58
        }else if(gridIndex == 2)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check") ?? false)
            {
                return 0
            }
            return 71
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        
        if (gridIndex == 0)
        {
            
        }else if(gridIndex == 1)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check") ?? false)
            {
                return nil
            }
            let label = UILabel(frame: CGRect(x: 10, y: 26, width: tableView.frame.size.width, height: 17))
            label.font = UIFont(name: "Montserrat-Regular", size: 14)
            view.addSubview(label)
            if (section == 0) {
                label.text = "FRIDGE (under 8C)"
            }else
            {
                label.text = "FREEZER (Under -18C)"
            }
            
            
        }else if(gridIndex == 2)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check") ?? false)
            {
                return nil
            }
            let label = UILabel(frame: CGRect(x: 10, y: 26, width: tableView.frame.size.width, height: 17))
            label.font = UIFont(name: "Montserrat-Regular", size: 14)
            view.addSubview(label)
            if (section == 0) {
                label.text = "COOKED (Above 82C)"

            }else if(section == 1)
            {
                label.text = "HOT-HOLDING (Above 63C)"

            }else if(section == 2)
            {
                label.text = "REHEATING (Above 75C)"
                
            }
            
 
            
        }
        
        
        return view;
    }
    
    
    func setupCellContentWithHeight(height:CGFloat,index:NSInteger, dict:JSON, screenName : String , markAll:Bool , refresh:Bool){
        gridIndex = index
        screen = screenName
        
        
        if(index == 0){
            if(refresh){
                refreshDataForPage = true
            }else{
                refreshDataForPage = false
            }
        }
        refreshData = refresh
        isMarkAll = markAll
        if (gridIndex == 0) {
            dictData = dict
            myTableView?.reloadData()
            myScrollView?.setContentOffset(CGPoint(x: 0,y :0), animated: true)
            
        }else if(gridIndex == 1)
        {
            myTableView2?.reloadData()
            myScrollView?.setContentOffset(CGPoint(x: screenSize.width * 1.0 ,y :0), animated: true)
            fridgeTemp = dictData?["entryDefaults"][0]["fridgeTemp"].int ?? 0

            
        }else if(gridIndex == 2)
        {
            dictData = dict

            
            minCookingTemp = dictData?["entryDefaults"][0]["minCookingTemp"].int ?? 0
            reHeatingTemp = dictData?["entryDefaults"][0]["reHeatingTemp"].int ?? 0
            hotHoldingTemp = dictData?["entryDefaults"][0]["hotHoldingTemp"].int ?? 0
            fridgeTemp = dictData?["entryDefaults"][0]["fridgeTemp"].int ?? 0

            
            hotHoldingNameArray.removeAllObjects()
            cookedNameArray.removeAllObjects()
            reheatingNameArray.removeAllObjects()
            let foodArray = dict["entryDefaults"][0]["foods"].array?.count ?? 0
            for i in 0..<foodArray{
                if(self.dictData?["entryDefaults"][0]["foods"][i]["hotHolding"].boolValue ?? false){
                    hotHoldingNameArray.add(self.dictData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
                }
                if(self.dictData?["entryDefaults"][0]["foods"][i]["cooked"].boolValue ?? false){
                    cookedNameArray.add(self.dictData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
                }
                if(self.dictData?["entryDefaults"][0]["foods"][i]["reheating"].boolValue ?? false){
                    reheatingNameArray.add(self.dictData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
                }
            }

            myTableView3?.reloadData()
            myScrollView?.setContentOffset(CGPoint(x: screenSize.width * 2.0 ,y :0), animated: true)
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows:Int = 0
        if (gridIndex == 0) {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                if let  array = dictData?["cleaning"][0]["categories"][0]["items"].array {
                    numberOfRows = array.count
//                    self.setRadioButtonsTab1(dataArray: numberOfRows)
                }
            }else if(screen?.equalsIgnoreCase(string: "closing check")  ?? false)
            {
                if let  array = dictData?["closing"][0]["items"].array {
                    numberOfRows = array.count
                }
            }else
            {
                if let  array = dictData?["opening"][0]["items"].array {
                    numberOfRows = array.count
                }
            }
        }else if(gridIndex == 1)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                if let  array = dictData?["cleaning"][0]["categories"][1]["items"].array {
                    numberOfRows = array.count
//                    self.setRadioButtonsTab2(dataArray: numberOfRows)
                }
            }else
            {
                if (section == 0) {
                    if let  numberOfFridges = dictData?["entryDefaults"][0]["numberOfFridges"].int {
                        numberOfRows = numberOfFridges
                    }
                }else
                {
                    
                    if let  numberOfFreezers = dictData?["entryDefaults"][0]["numberOfFreezers"].int {
                        numberOfRows = numberOfFreezers
                    }
                }
                
            }
            
        }else if(gridIndex == 2)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                if let  array = dictData?["cleaning"][0]["categories"][2]["items"].array {
                    numberOfRows = array.count
//                    self.setRadioButtonsTab3(dataArray: numberOfRows)
                }
            }else
            {
                if (section == 0) {
                    return cookedNameArray.count

                }else if(section == 1)
                {
                    return hotHoldingNameArray.count

                }else if(section == 2)
                {
                    return reheatingNameArray.count
                    
                }
//                if let  array = dictData?["entryDefaults"][0]["foods"].array {
//                    numberOfRows = array.count
//                }
            }
        }else
        {
            return 1
        }
        
        return numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (gridIndex == 0) {
            return 1
            
        }else if(gridIndex == 1)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                return 1
            }
            return 2
        }else if(gridIndex == 2)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                return 1
            }
            return 3
        }else
        {
            return 1
        }
    }
    //
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (gridIndex == 0) {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                return 169
            }
            return 84
            
        }else if(gridIndex == 1)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                return 169
            }
            if (indexPath == self.selectedIndexPath) {
                let size = 132
                return CGFloat(size)
            }
            
            if(screen?.equalsIgnoreCase(string: "opening check")  ?? false)
            {
                return 66 + 9
            }
            return 66 + 9
        }else if(gridIndex == 2)
        {
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                return 169
            }
            if (indexPath == self.selectedIndexPath) {
                let size = 132
                return CGFloat(size)
            }
            if(screen?.equalsIgnoreCase(string: "opening check")  ?? false)
            {
                return 66 + 9
            }
            return 66 + 9
        }else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = UITableViewCell()
        if (gridIndex == 0) {
            
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                let cell: AfterUseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AfterUseTableViewCell") as? AfterUseTableViewCell
                cell?.delegate = self
                cell?.crossButton?.tag = indexPath.row
                cell?.selectionStyle = .none
                if(refreshData){
                    cell?.radioButton?.isSelected = false
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "androidRadioButtonOn"), for: UIControlState.normal)
                }
                
                if (isMarkAll ?? false) {
                    cell?.radioButton?.isSelected = true
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "shapeg"), for: UIControlState.selected)
                }
                
                if let  cellString = dictData?["cleaning"][0]["categories"][0]["items"][indexPath.row]["task"].string {
                    cell?.titleLabel?.text = cellString
                }
                
                if let  cellString = dictData?["cleaning"][0]["categories"][0]["items"][indexPath.row]["description"].string {
                    cell?.descLabel?.text = cellString
                }
                
                return cell ?? customCell
                
            }else if(screen?.equalsIgnoreCase(string: "closing check")  ?? false)
            {
                let cell: ChecklistTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ChecklistTableViewCell") as? ChecklistTableViewCell
                cell?.delegate = self
                cell?.crossButton?.tag = indexPath.row
                cell?.selectionStyle = .none
                if(refreshData){
                    cell?.radioButton?.isSelected = false
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "androidRadioButtonOn"), for: UIControlState.normal)
                    
                }
                
                if (isMarkAll ?? false) {
                    cell?.radioButton?.isSelected = true
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "shapeg"), for: UIControlState.selected)
                }
                
                if let cellString =  dictData?["closing"][0]["items"][indexPath.row]["description"].string
                {
                    cell?.titleLabel?.text = cellString
                    
                }
                return cell ?? customCell
                
            }else
            {
                let cell: ChecklistTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ChecklistTableViewCell") as? ChecklistTableViewCell
                cell?.delegate = self

                cell?.selectionStyle = .none
                cell?.crossButton?.tag = indexPath.row

                if(refreshData){
                    cell?.radioButton?.isSelected = false
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "androidRadioButtonOn"), for: UIControlState.normal)
                    
                }
                
                if (isMarkAll ?? false) {
                    cell?.radioButton?.isSelected = true
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "shapeg"), for: UIControlState.selected)
                }
                
                
                if let cellString =  dictData?["opening"][0]["items"][indexPath.row]["description"].string
                {
                    cell?.titleLabel?.text = cellString
                    
                }
                return cell ?? customCell
                
            }
        }else if(gridIndex == 1)
        {
            
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                let cell: AfterUseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AfterUseTableViewCell") as? AfterUseTableViewCell
                cell?.delegate = self
                cell?.crossButton?.tag = indexPath.row

                cell?.selectionStyle = .none
//                if ((tab2Array?.count)! > 0) {
//                    if (tab2Array?[indexPath.row] as? Int == 0) {
//                        cell?.radioButton?.imageView?.image = #imageLiteral(resourceName: "androidRadioButtonOn")
//                    }else
//                    {
//                        cell?.radioButton?.imageView?.image = #imageLiteral(resourceName: "shapeg")
//                    }
//                }
                if(refreshData){
                    cell?.radioButton?.isSelected = false
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "androidRadioButtonOn"), for: UIControlState.normal)
                    
                }
                if (isMarkAll ?? false) {
                    cell?.radioButton?.isSelected = true
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "shapeg"), for: UIControlState.selected)
                }
                
                if let  cellString = dictData?["cleaning"][0]["categories"][1]["items"][indexPath.row]["task"].string {
                    cell?.titleLabel?.text = cellString
                }
                
                if let  cellString = dictData?["cleaning"][0]["categories"][1]["items"][indexPath.row]["description"].string {
                    cell?.descLabel?.text = cellString
                }

                return cell ?? customCell
                
            }else
            {
                let cell: AppliancesTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AppliancesTableViewCell") as? AppliancesTableViewCell
                cell?.selectionStyle = .none
                cell?.dropDownButton?.tag = indexPath.section
                cell?.delegate = self
                cell?.enterTempTextField?.delegate = self
                cell?.enterCommentTextField?.delegate = self
                
                
                
                cell?.selectionStyle = .none
//                cell?.appliancesCellBottomHeightConstraint?.constant = 9
//                cell?.appliancestopHeightConstraint?.constant = 66

                if (indexPath == self.selectedIndexPath) {
                    cell?.arrowImageView?.image = #imageLiteral(resourceName: "group3")
                    
                }else{
                    cell?.arrowImageView?.image = #imageLiteral(resourceName: "dropdownIcon")
                    
                }
                
                
                if (indexPath.section == 0) {
                    cell?.enterTempTextField?.tag = 555 + indexPath.row
                    cell?.enterCommentTextField?.tag = 555 + indexPath.row
                    //            cell.setupCellContentWithHeight(height: 25 * 40)
                    cell?.myLabel?.text = "Fridge  " + "\(indexPath.row + 1)"
                    cell?.myImageView?.image = #imageLiteral(resourceName: "fridgeIcon")
                    cell?.mySubLabel?.text = "8°"
                    cell?.enterCommentTextField?.placeholder = "\(fridgeTemp)" + "°C or below else add comment"

                }else
                {
                    cell?.enterTempTextField?.tag = indexPath.row
                    cell?.enterCommentTextField?.tag = indexPath.row
                    //            cell.setupCellContentWithHeight(height: 25 * 40)
                    cell?.myLabel?.text = "Freezer  " + "\(indexPath.row + 1)"
                    cell?.myImageView?.image = #imageLiteral(resourceName: "freezer")
                    cell?.mySubLabel?.text = "-18°"
                    cell?.enterCommentTextField?.placeholder = "-18°C or below else add comment"

                    
                }
                return cell ?? customCell
                
            }
            
            
        }else if(gridIndex == 2)
        {
            
            //            cell.setupCellContentWithHeight(height: 25 * 40)
            if(screen?.equalsIgnoreCase(string: "cleaning check")  ?? false)
            {
                let cell: AfterUseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AfterUseTableViewCell") as? AfterUseTableViewCell
                cell?.delegate = self
                cell?.crossButton?.tag = indexPath.row
                cell?.selectionStyle = .none
//                if ((tab3Array?.count)! > 0) {
//                    if (tab3Array?[indexPath.row] as? Int == 0) {
//                        cell?.radioButton?.imageView?.image = #imageLiteral(resourceName: "androidRadioButtonOn")
//                    }else
//                    {
//                        cell?.radioButton?.imageView?.image = #imageLiteral(resourceName: "shapeg")
//                    }
//                }
                if(refreshData){
                    cell?.radioButton?.isSelected = false
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "androidRadioButtonOn"), for: UIControlState.normal)
                    
                }
                if (isMarkAll ?? false) {
                    cell?.radioButton?.isSelected = true
                    cell?.radioButton?.setImage(#imageLiteral(resourceName: "shapeg"), for: UIControlState.selected)
                }
                
                if let  cellString = dictData?["cleaning"][0]["categories"][2]["items"][indexPath.row]["task"].string {
                    cell?.titleLabel?.text = cellString
                }
                
                if let  cellString = dictData?["cleaning"][0]["categories"][2]["items"][indexPath.row]["description"].string {
                    cell?.descLabel?.text = cellString
                }
                return cell ?? customCell
                
            }else
            {
                let cell: AppliancesTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AppliancesTableViewCell") as? AppliancesTableViewCell
                cell?.delegate = self
                let cellIndex = indexPath.row

                cell?.dropDownButton?.tag = indexPath.section
//                cell?.appliancesCellBottomHeightConstraint?.constant = 9
//                cell?.appliancestopHeightConstraint?.constant = 66
                cell?.selectionStyle = .none
                cell?.enterTempTextField?.delegate = self
                cell?.enterCommentTextField?.delegate = self
                cell?.enterTempTextField?.tag = cellIndex
                cell?.enterCommentTextField?.tag = cellIndex
                
                if (indexPath == self.selectedIndexPath) {
                    cell?.arrowImageView?.image = #imageLiteral(resourceName: "group3")
                    
                }else{
                    cell?.arrowImageView?.image = #imageLiteral(resourceName: "dropdownIcon")
                    
                }
                var cellString = ""
                if (indexPath.section == 0) {
                    cellString = cookedNameArray [indexPath.row] as? String ?? ""
                    cell?.mySubLabel?.text = "\(minCookingTemp)" + "°"
                    cell?.enterCommentTextField?.placeholder = "Temperature above " + "\(minCookingTemp)" + "°C else add comment"

                    
                }else if(indexPath.section == 1)
                {
                    cellString = hotHoldingNameArray[indexPath.row] as? String ?? ""

                    cell?.mySubLabel?.text = "\(hotHoldingTemp)" + "°"
                    cell?.enterCommentTextField?.placeholder = "Temperature above " + "\(hotHoldingTemp)" + "°C else add comment"

                }else if(indexPath.section == 2)
                {
                    cellString = reheatingNameArray[indexPath.row] as? String ?? ""
                    cell?.mySubLabel?.text = "\(reHeatingTemp)" + "°"
                    cell?.enterCommentTextField?.placeholder = "Temperature above " + "\(reHeatingTemp)" + "°C else add comment"

                }
                
                 cell?.myImageView?.image = #imageLiteral(resourceName: "defaultIcon")
                    
                    if (cellString.equalsIgnoreCase(string: "chicken")) {
                        cell?.myImageView?.image = #imageLiteral(resourceName: "group2")
                    }
                    cell?.myLabel?.text = cellString

                return cell ?? customCell
                
            }
            
        }
        
        return customCell
    }
    
    func crossButtonclicked(index: Int) {
        var cell : AfterUseTableViewCell?
        if (gridIndex == 0) {
            cell = self.myTableView?.cellForRow(at: IndexPath(row: index, section: 0)) as? AfterUseTableViewCell
        }
        if (gridIndex == 1) {
            cell = self.myTableView2?.cellForRow(at: IndexPath(row: index, section: 0)) as? AfterUseTableViewCell
        }
        if (gridIndex == 2) {
            cell = self.myTableView3?.cellForRow(at: IndexPath(row: index, section: 0)) as? AfterUseTableViewCell
        }
        
//        cell?.backgroundColor = UIColor.init(colorLiteralRed: 221.0/255.0, green: 232.0/255.0, blue: 213.0/255.0, alpha: 1)
    }
    
    
    func dropDowntapped(index:Int, section:Int)
    {
        

        if(gridIndex == 1){

            var sectionNo = 1
            var indexNo = index
            if (index >= 555) {
                sectionNo = 0
                indexNo = indexNo - 555
            }
            let indexpath = NSIndexPath(row: indexNo, section: section)

            myTableView2?.reloadData()
            if (indexpath as IndexPath == self.selectedIndexPath) {
                self.selectedIndexPath = nil
            }else{
                self.selectedIndexPath = indexpath as IndexPath
            }
        }else if(gridIndex == 2)
        {
            var row = index
            
            let indexpath = NSIndexPath(row: row, section: section)

            myTableView3?.reloadData()
            if (indexpath as IndexPath == self.selectedIndexPath) {
                self.selectedIndexPath = nil
            }else{
                self.selectedIndexPath = indexpath as IndexPath
            }

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
            if (gridIndex == 1) {
                self.myTableView2?.beginUpdates()
                self.myTableView2?.endUpdates()
            }else if(gridIndex == 2)
            {
                self.myTableView3?.beginUpdates()
                self.myTableView3?.endUpdates()
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if((gridIndex == 1 || gridIndex == 2) && ((screen?.equalsIgnoreCase(string: "opening check")) ?? false)){
//            myTableView3?.reloadData()
//            myTableView2?.reloadData()
//            if (indexPath == self.selectedIndexPath) {
//                self.selectedIndexPath = nil
//            }else{
//                self.selectedIndexPath = indexPath
//            }
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (gridIndex == 1) {
            if(textField.tag >= 555)
            {
                
                 let cell1 : AppliancesTableViewCell? = myTableView2?.cellForRow(at: NSIndexPath(row: textField.tag - 555, section: 0) as IndexPath) as? AppliancesTableViewCell
                
                
                    
                    if(Int(textField.text ?? "") ?? 0 > fridgeTemp){
                        
                        self.dropDowntapped(index: textField.tag - 555, section: cell1?.dropDownButton?.tag ?? 0)
                        
                    }
               
                
                self.delegate?.tableViewCell2FridgeDelegate(index: textField.tag - 555 , temp: cell1?.enterTempTextField?.text ?? "", comment: cell1?.enterCommentTextField?.text ?? "")
            }else
            {
                let cell1 : AppliancesTableViewCell? = myTableView2?.cellForRow(at: NSIndexPath(row: textField.tag, section: 1) as IndexPath) as? AppliancesTableViewCell
                
                if(Int(textField.text ?? "") ?? 0 >  -18){
                    
                    self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                    
                }
                self.delegate?.tableViewCell2FreezerDelegate(index: textField.tag, temp: cell1?.enterTempTextField?.text ?? "", comment: cell1?.enterCommentTextField?.text ?? "")
            }
        }else if(gridIndex == 2)
        {
            let section =  0;
            
            let row = 0;
            
            let cell1 : AppliancesTableViewCell? = myTableView3?.cellForRow(at: NSIndexPath(row: row, section: section) as IndexPath) as? AppliancesTableViewCell
            
            if(section ==  0)
            {
                
                if(Int(textField.text ?? "") ?? 0 < minCookingTemp || textField.text ?? "" != ""){
                    
                    self.dropDowntapped(index: row, section: section)
//                    cell1?.enterCommentTextField?.becomeFirstResponder()
                }
                
            }else if(section == 1)
            {
                if(Int(textField.text ?? "") ?? 0 < hotHoldingTemp || textField.text ?? "" != "") {
                    
                    self.dropDowntapped(index: row, section: section)
//                    cell1?.enterCommentTextField?.becomeFirstResponder()

                }
                
                
            }else if(section == 2)
            {
                if(Int(textField.text ?? "") ?? 0 < reHeatingTemp || textField.text ?? "" != "" ){
                    
                    self.dropDowntapped(index: row, section: section)
//                    cell1?.enterCommentTextField?.becomeFirstResponder()

                }
                
            }
            
            
            self.delegate?.tableViewCell2FoodDelegate(index: row, temp: cell1?.enterTempTextField?.text ?? "", comment: cell1?.enterCommentTextField?.text ?? "" , section : section )

        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
