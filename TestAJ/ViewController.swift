
//
//  ViewController.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 12/04/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
//import SJSegmentedScrollView
import SwiftyJSON
import UserNotifications
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}
class ViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,GridViewCellDelegate,HeaderTableViewCellDelegate,UITextFieldDelegate,AppliancesTableViewCellDelegate,AfterUseTableViewCellDelegate,DatePickupTableViewCellDelegate,TextFieldTypeCellDelegate,TextFieldTableViewCellDelegate,TemperatureTableViewCellDelegate,CommentTableViewCellDelegate,TableViewCell2Delegate,TableViewCellforTwoHeaderDelegate{
    
    var tempMessegaTitle = "Temperature out of range"
    
    var myDictOfDict:NSDictionary = [
        "Opening check" : ["Checklist", "Appliances", "Food"]
        ,   "Cleaning check" : ["After use", "End of day", "Deep Clean"]
    ]
    
    var deliveryCheckArray = ["Invoice Number","Supplier","Use By", "Packaging State" , "Set temperature" ,"Leave a comment"]
    var deliveryCheckArrayDetail = [["","",""],["Supplier 1"," Supplier 2","Supplier 3"],["Use 1","Use 2","Use 3"],["pristine","packaging damaged","packaging opened","content damaged"],["","",""],["","",""]]
    
    var foodCheckArray = ["Chicken 1","Chicken 2","Chicken 3"]
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var saveButton: UIButton?
    var configDictionary = [String: String]()
    var currentGridButtonindex:NSInteger?
    var checkListEnabled : Bool?
    var appliancesEnabled : Bool?
    var foodEnabled : Bool?
    var headerView: GridViewCell?
    var fridge1Enabled : Bool?
    var fridge2Enabled : Bool?
    var markAllEnabled : Bool?
    var datepickerBGView : UIView?
    var datPicker : UIDatePicker?
    var screenTitle :String?
    
    var isDropDownSelectd : Bool?
    
    var completeData : JSON?
    var viewLogData : JSON?
    //    var closingData : JSON?
    //    var cleaningData : JSON?
    var entryDefaultsData : JSON?
    let myArray: NSArray = ["First","Second","Third"]
    var selectedDateLong : String?
    var selectedDateUseByLong : String?
    
    var selectedDateMid = ""
    var selectedDateUseByMid : String?
    
    var invoiceSelected = ""
    var packagingSelected = ""
    var supplierSelected = ""
    var tempSelected = ""
    var degreeSelected = "C"
    var commentSelected = ""
    
    var isUseByClicked : Bool?
    var isRefreshData = false
    
    var isMarAllTab1 = false
    var isMarAllTab2 = false
    var isMarAllTab3 = false

    var deliVeryTempOnOff = 1

    var locIDOpening = ""
    var bussIdOpening = ""
    
    var locIDClosing = ""
    var bussIdClosing = ""
    
    var locIDCleaning = ""
    var bussIdCleaning = ""
    
    var cleaningId = ""
    var entryDefaultsId = ""
    var frigdeArray = [JSON]()
    var freezerArray = [JSON]()
    var isProbeWorking : Bool?
    
    var tab1Array = NSMutableArray()
    var tab2Array = NSMutableArray()
    var tab3Array = NSMutableArray()
    
    var hotHoldingNameArray = NSMutableArray()
    var cookedNameArray = NSMutableArray()
    var reheatingNameArray = NSMutableArray()
    
    var foodArray = [JSON]()
    var foodArray2 = [JSON]()
    var foodArray3 = [JSON]()

    var isInvoiceField : Bool?
    
    var iceTest = false
    var boilingWater = false

    var minCookingTemp = 0
    var reHeatingTemp = 0
    var hotHoldingTemp = 0
    var fridgeTemp = 0
    var alert = UIAlertController()
    
    @IBOutlet var myTableView: UITableView?
    
    
    func setfridgeArrayData(dataArray:Int , isSelected:String){
        frigdeArray.removeAll()
        for _ in 0 ..< dataArray {
            frigdeArray.append(["temp":"", "comment":""])
        }
    }
    func setfreezerArrayData(dataArray:Int , isSelected:String){
        freezerArray.removeAll()
        for _ in 0 ..< dataArray {
            freezerArray.append(["temp":"", "comment":""])
        }
    }
    func setfoodArrayData1(dataArray:Int , isSelected:String){
        foodArray.removeAll()
        for _ in 0 ..< dataArray {
            foodArray.append(["temp":"", "comment":""])
        }
    }
    
    func setfoodArrayData2(dataArray:Int , isSelected:String){
        foodArray2.removeAll()
        for _ in 0 ..< dataArray {
            foodArray2.append(["temp":"", "comment":""])
        }
    }
    func setfoodArrayData3(dataArray:Int , isSelected:String){
        foodArray3.removeAll()
        for _ in 0 ..< dataArray {
            foodArray3.append(["temp":"", "comment":""])
        }
    }
    
    func setRadioButtonsTab1(dataArray:Int , isSelected:String){
        tab1Array.removeAllObjects()
        for _ in 0 ..< dataArray {
            tab1Array.add(isSelected)
        }
    }
    
    func setRadioButtonsTab2(dataArray:Int, isSelected:String){
        tab2Array.removeAllObjects()
        for _ in 0 ..< dataArray {
            tab2Array.add(isSelected)
        }
    }
    
    func setRadioButtonsTab3(dataArray:Int, isSelected:String){
        tab3Array.removeAllObjects()
        for _ in 0 ..< dataArray {
            tab3Array.add(isSelected)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(view:self.view, msg: "")
        fridge1Enabled = true
        
       getAllData()
        
    }
    func getViewLogData()
    {
        super.loadViewLogData(dict:["locationId": self.locIDOpening,"businessId": self.bussIdOpening], sucess: { (isTrue) in
            if (isTrue){
            self.viewLogData = ItsRequest.sharedInstance.loadJSON(key: "view_log")
            }
            self.myTableView?.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        })
    }
    func getAllData(){
        
            
            ItsRequest.sharedInstance.requestGETURL("api/templates/default/all", "", success: { (json) in
                
                if (json["data"].count != 0) {
                    //Now you got your value
                    ItsRequest.sharedInstance.saveJSON(j: json["data"], key: "aLLData")
                    self.initializedata()
                    LoadingOverlay.shared.hideOverlayView()
                    self.myTableView?.reloadData()
                }
                if (json["code"].int == 401 && json["message"].string == "Invalid token") {
                    self.alert.dismiss(animated: false, completion: { 
                        
                    })
                    LoadingOverlay.shared.showOverlay(view:self.view, msg: "")
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    let sb = UIStoryboard(name: "Main", bundle: nil)

                    let nextViewController : LoginVC? = sb.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    //self.present(nextViewController ?? UIViewController(), animated:true, completion:nil)
                    LoadingOverlay.shared.hideOverlayView()
                }
            }) { (error) in
                LoadingOverlay.shared.hideOverlayView()
                
            }
    }
    override func viewDidAppear(_ animated: Bool) {
        isInvoiceField = true
       if let notificationName = UserDefaults.standard.value(forKey: "notification") as? String{
        if (notificationName.equalsIgnoreCase(string: "Opening Check")) {
            self.cellDidSelectWithIndexAndtitle(index: 0, title: "Opening Check")
        }else if(notificationName.equalsIgnoreCase(string: "Closing Check")){
            self.cellDidSelectWithIndexAndtitle(index: 0, title: "Closing Check")

        }else if(notificationName.equalsIgnoreCase(string: "Cleaning Check"))
       {
        self.cellDidSelectWithIndexAndtitle(index: 0, title: "Cleaning Check")

        }
        UserDefaults.standard.removeObject(forKey: "notification")
        }
    }
    func initializedata()
    {
        completeData = ItsRequest.sharedInstance.loadJSON(key: "aLLData")
        entryDefaultsData = completeData?["entryDefaults"]
        
        
        
        locIDOpening = (self.completeData?["opening"][0]["locationId"].string ?? "null")
        bussIdOpening = (self.completeData?["opening"][0]["businessId"].string ?? "null")
        
        locIDClosing = (self.completeData?["closing"][0]["locationId"].string ?? "null")
        bussIdClosing = (self.completeData?["closing"][0]["businessId"].string ?? "null")
        
        locIDCleaning = (self.completeData?["cleaning"][0]["locationId"].string ?? "null")
        bussIdCleaning = (self.completeData?["cleaning"][0]["businessId"].string ?? "null")
        
        
        cleaningId = (self.completeData?["cleaning"][0]["_id"].string ?? "null")
        entryDefaultsId = (self.completeData?["entryDefaults"][0]["_id"].string ?? "null")
        
        // opening
        self.setRadioButtonsTab1(dataArray: self.completeData?["opening"][0]["items"].array?.count ?? 0 , isSelected: "NO")
        // appliances
        self.setfridgeArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0 , isSelected: "NO")
        self.setfreezerArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0 , isSelected: "NO")
        // food
        
        
        minCookingTemp = completeData?["entryDefaults"][0]["minCookingTemp"].int ?? 0
        reHeatingTemp = completeData?["entryDefaults"][0]["reHeatingTemp"].int ?? 0
        hotHoldingTemp = completeData?["entryDefaults"][0]["hotHoldingTemp"].int ?? 0
        fridgeTemp = completeData?["entryDefaults"][0]["fridgeTemp"].int ?? 0
        
        hotHoldingNameArray.removeAllObjects()
        cookedNameArray.removeAllObjects()
        reheatingNameArray.removeAllObjects()
        let foodArray = self.completeData?["entryDefaults"][0]["foods"].array?.count ?? 0
        for i in 0..<foodArray{
            if(self.completeData?["entryDefaults"][0]["foods"][i]["hotHolding"].boolValue ?? false){
                hotHoldingNameArray.add(self.completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
            }
            if(self.completeData?["entryDefaults"][0]["foods"][i]["cooked"].boolValue ?? false){
                cookedNameArray.add(self.completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
            }
            if(self.completeData?["entryDefaults"][0]["foods"][i]["reheating"].boolValue ?? false){
                reheatingNameArray.add(self.completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
            }
        }
        
        self.setfoodArrayData1(dataArray: cookedNameArray.count , isSelected: "NO")
        self.setfoodArrayData2(dataArray: hotHoldingNameArray.count , isSelected: "NO")
        self.setfoodArrayData3(dataArray: reheatingNameArray.count , isSelected: "NO")

        
    }
    func keyboardWillShow(notification: NSNotification) {
        if(!(screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false)){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(!(screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false)){

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let notification = NotificationHelper();
        notification.getNotificationConfigs { (msg) in
            
//            self.alert = UIAlertController(title: "Notification Scheduled list", message: msg, preferredStyle: UIAlertControllerStyle.alert)
//            self.alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(self.alert, animated: true, completion: nil)
        }
        
        let date = Date()
        
        let formatterLong = DateFormatter()
        formatterLong.dateFormat = "MMM dd hh:mm  a"
        let resultLong = formatterLong.string(from: date)
        
        let formatterMid = DateFormatter()
        formatterMid.dateFormat = "dd-MM-yyyy"
        let resultMid = formatterMid.string(from: date)
        
        selectedDateMid = resultMid
        selectedDateLong = resultLong
        
        selectedDateUseByLong = resultLong
        selectedDateUseByMid = resultMid
        
        
        initComponents()
        checkListEnabled = true
        appliancesEnabled = false
        foodEnabled = false
        fridge1Enabled = true
        fridge2Enabled = false
        isUseByClicked = false
        screenTitle = "Opening Check"
        currentGridButtonindex = 0
        // Do any additional setup after loading the view, typically from a nib.
        myTableView?.separatorColor = .clear
        //        myTableView?.style = .none
        // header cell
        myTableView?.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        myTableView?.register(UINib(nibName: "GridViewCell", bundle: nil), forCellReuseIdentifier: "GridViewCell")
        myTableView?.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "TableViewCell2")
        myTableView?.register(UINib(nibName: "TableViewCellforTwoHeader", bundle: nil), forCellReuseIdentifier: "TableViewCellforTwoHeader")
        
        myTableView?.register(UINib(nibName: "TemperatureTableViewCell", bundle: nil), forCellReuseIdentifier: "TemperatureTableViewCell")
        
        myTableView?.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        myTableView?.register(UINib(nibName: "AfterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "AfterUseTableViewCell")
        
        myTableView?.register(UINib(nibName: "ProbeRadioTableViewCell", bundle: nil), forCellReuseIdentifier: "ProbeRadioTableViewCell")
        myTableView?.register(UINib(nibName: "ViewLogTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewLogTableViewCell")
        
        myTableView?.register(UINib(nibName: "VieLogHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "VieLogHeaderTableViewCell")
        
        myTableView?.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        
        myTableView?.register(UINib(nibName: "DatePickupTableViewCell", bundle: nil), forCellReuseIdentifier: "DatePickupTableViewCell")
        
        
        
        myTableView?.register(UINib(nibName: "TextFieldTypeCell", bundle: nil), forCellReuseIdentifier: "TextFieldTypeCell")
        myTableView?.register(UINib(nibName: "AppliancesTableViewCell", bundle: nil), forCellReuseIdentifier: "AppliancesTableViewCell")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissKeyboard))
        myTableView?.addGestureRecognizer(tap)
        
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
    
    }
    internal var selectedIndexPath: IndexPath? {
        didSet{
            //(own internal logic removed)
            
            //these magical lines tell the tableview something's up, and it checks cell heights and animates changes
            self.myTableView?.beginUpdates()
            self.myTableView?.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }
        if(screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false){
            return 71
            
        }else
        {
            
        }
        if (screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false) {
            return 26.0 + 30.0
        }
        if (screenTitle?.equalsIgnoreCase(string: "cleaning check")  ?? false) {
            return 110
        }
        
        
        if ((screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false)  || (screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "Pest control")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "Probe Check")  ?? false) || screenTitle?.equalsIgnoreCase(string: "View Log")  ?? false){
            return 0
        }else{
            var height = 55
            height += Int((checkListEnabled == true ? 55.0 : 0.0) + (appliancesEnabled == true ? 0.0 : 0.0) + (foodEnabled == true ? 0.0 : 0.0))
            return CGFloat(height)
        }
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //        var headerView: GridViewCell? = tableView.dequeueReusableCell(withIdentifier: "GridViewCell") as? GridViewCell
        if (headerView == nil) {
            headerView = tableView.dequeueReusableCell(withIdentifier: "GridViewCell") as? GridViewCell
        }
        if(screenTitle?.equalsIgnoreCase(string: "food")  ?? false)
        {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
            view.backgroundColor = .white

            let uilbl = UILabel()
            uilbl.frame = CGRect(x: 10, y: 30, width: screenSize.width, height: 30)
            uilbl.font = UIFont(name: "Montserrat-Regular", size: 14.0)
            uilbl.textColor = UIColor.init(colorLiteralRed: 39.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
//            uilbl.backgroundColor = .orange
            if(section == 1){
                uilbl.text = "COOKED (Above 82C)"


            }else if(section == 2)
            {
                uilbl.text = "HOT-HOLDING (Above 63C)"

            }else if(section == 3)
            {
                uilbl.text = "REHEATING (Above 75C)"

            }
            view.addSubview(uilbl)

            // Do your customization
            return view
        }
        
        if(screenTitle?.equalsIgnoreCase(string: "View Log")  ?? false)
        {
            headerView?.viewAllHeightConstraint?.constant = 0
            headerView?.gridRadioHeightConstraint?.constant = 0
            headerView?.appliancesBottomHeightConstraint?.constant = 0
            return nil
        }
        headerView?.delegate = self
        if (screenTitle?.equalsIgnoreCase(string: "Cleaning Check") ?? false) {
            headerView?.configureGrid(titleArray:["After use", "End of day", "Deep Clean"] , index:currentGridButtonindex ?? 0)
            
            headerView?.viewAllHeightConstraint?.constant = 55
            headerView?.gridRadioHeightConstraint?.constant = 55
            headerView?.appliancesBottomHeightConstraint?.constant = 0
            
        }else if (screenTitle?.equalsIgnoreCase(string: "Opening Check")  ?? false) {
            headerView?.configureGrid(titleArray:["Checklist", "Appliances", "Food"], index:currentGridButtonindex ?? 0)
            headerView?.viewAllHeightConstraint?.constant = 55
            headerView?.gridRadioHeightConstraint?.constant = 55
            headerView?.appliancesBottomHeightConstraint?.constant = 0
            
        }else if (screenTitle?.equalsIgnoreCase(string: "Closing Check") ?? false) {
            headerView?.configureGrid(titleArray:["Checklist", "Appliances", "Food"], index:currentGridButtonindex ?? 0)
            headerView?.viewAllHeightConstraint?.constant = 55
            headerView?.gridRadioHeightConstraint?.constant = 55
            headerView?.appliancesBottomHeightConstraint?.constant = 0
            
        }else if (screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false) {
            headerView?.viewAllHeightConstraint?.constant = 0
            headerView?.gridRadioHeightConstraint?.constant = 0
            headerView?.appliancesBottomHeightConstraint?.constant = 26
            
        }else if ((screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "Pest control")  ?? false)) {
            headerView?.viewAllHeightConstraint?.constant = 0
            headerView?.gridRadioHeightConstraint?.constant = 0
            headerView?.appliancesBottomHeightConstraint?.constant = 0
            
        }else
        {
            headerView?.viewAllHeightConstraint?.constant = 0
            headerView?.gridRadioHeightConstraint?.constant = 0
            headerView?.appliancesBottomHeightConstraint?.constant = 0
            
        }
        
        
        
        
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if(screenTitle?.equalsIgnoreCase(string: "View Log")  ?? false)
            {
                return 1
            }
            return 1
        }else
        {
            if(screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false)
            {
                    if (section == 1) {
                        return cookedNameArray.count

                    }else if(section == 2)
                    {
                        return hotHoldingNameArray.count

                    }else if(section == 3)
                    {
                        return reheatingNameArray.count

                    }
                    
                return 0
                
            }else if (screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false){
                return deliveryCheckArray.count
            }else if(screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false)
            {
                return 2
            }else if(screenTitle?.equalsIgnoreCase(string: "Probe check")  ?? false)
            {
                return 3
            }else if(screenTitle?.equalsIgnoreCase(string: "Pest Control")  ?? false)
            {
                return 2
            }else if (screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false){
                return 1
            }else if (screenTitle?.equalsIgnoreCase(string: "View log")  ?? false){
                
                return viewLogData?.array?.count ?? 0
            }else{
                return 1
                
            }
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var noofSections = 2
        if (screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false) {
            noofSections  = 2
            
        }
        if (screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false) {
            noofSections  = 4
            
        }
        return noofSections
        
    }
    
    func setUIComponents(title:String) {
        if (title.equalsIgnoreCase(string: "Opening Check")) {
            configDictionary = ["grid": "value"]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            
            if(screenTitle?.equalsIgnoreCase(string: "View Log")  ?? false)
            {
                return 0
            }
            return 159
        }else //if(indexPath.section == 2)
        {
            if(screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false)
            {
                if indexPath == self.selectedIndexPath {
                    let size = 132
                    return CGFloat(size)
                }else{
                    return 75
                }
                
            }else if (screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false){
                if (indexPath.row == 4) {
                    return 173
                }else if (indexPath.row == 5) {
                    return 173 + 100 + 55 // for save log button
                }
                return 67
            }else if (screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false){
                if (indexPath.row == 0) {
                    return 73
                }else {
                    return 173 + 100  // for save log button
                }
            }else if (screenTitle?.equalsIgnoreCase(string: "Pest control")  ?? false){
                if (indexPath.row == 0) {
                    return 73
                }else {
                    return 173 + 100  // for save log button
                }
            }else if (screenTitle?.equalsIgnoreCase(string: "Probe Check")  ?? false){
                if (indexPath.row == 0) {
                    return 100
                }else {
                    return 100  // for save log button
                }
            }else if (screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false){
                var cellHeight: CGFloat?
                
                if (fridge1Enabled ?? false) {
                    if let  numberOfFridges = completeData?["entryDefaults"][0]["numberOfFridges"].int {
                        cellHeight = 66 * CGFloat(numberOfFridges) + (9 * CGFloat(numberOfFridges)) // margin for header
                    }
                }
                
                if(fridge2Enabled ?? false){
                    if let  numberOfFreezers = completeData?["entryDefaults"][0]["numberOfFreezers"].int {
                        cellHeight = (cellHeight ?? 0) + (66 * CGFloat(numberOfFreezers * 2)) + (9 * CGFloat(numberOfFreezers))
                    }
                }
                cellHeight = (cellHeight ?? 0) + 120 // margin for header
                
                return cellHeight ?? 0
                //                return 25 * 66
            }else if (screenTitle?.equalsIgnoreCase(string: "View log")  ?? false){
                if(indexPath.row == 0){
                    return 121
                }
                return 121
            }else {
                var cellHeight = 0
                if(screenTitle?.equalsIgnoreCase(string: "cleaning check")  ?? false)
                {
                    if (checkListEnabled ?? false) {
                        if let  array = completeData?["cleaning"][0]["categories"][0]["items"].array {
                            cellHeight = 169 * array.count
                        }
                    }else if(appliancesEnabled ?? false)
                    {
                        if let  array = completeData?["cleaning"][0]["categories"][1]["items"].array {
                            cellHeight = 169 * array.count
                        }
                        
                    }else if(foodEnabled ?? false)
                    {
                        if let  array = completeData?["cleaning"][0]["categories"][2]["items"].array {
                            cellHeight = 169 * array.count
                        }
                    }
                }else
                {
                    
                    if (checkListEnabled ?? false) {
                        if(screenTitle?.equalsIgnoreCase(string: "closing check")  ?? false){
                            if let  array = completeData?["closing"][0]["items"].array {
                                cellHeight = 84 * array.count
                            }
                        }else
                        {
                            if let  array = completeData?["opening"][0]["items"].array {
                                cellHeight = 84 * array.count
                            }
                        }
                        
                    }else if(appliancesEnabled ?? false)
                    {
                        if let  numberOfFridges = completeData?["entryDefaults"][0]["numberOfFridges"].int {
                            cellHeight = 66 * numberOfFridges + (9 * numberOfFridges)
                        }
                        if let  numberOfFreezers = completeData?["entryDefaults"][0]["numberOfFreezers"].int {
                            cellHeight = cellHeight + (66 * (numberOfFreezers * 2)) + (9 * numberOfFreezers)
                        }
                        cellHeight = cellHeight + 120 // margin for header
                        
                    }else if(foodEnabled ?? false)
                    {
                        if let  array = completeData?["entryDefaults"][0]["foods"].array {
//                            cellHeight = ((66 + 30) * array.count + ( 55 * array.count)) + 3 * 71
                            cellHeight = (cookedNameArray.count * 100) + (hotHoldingNameArray.count * 100) + (reheatingNameArray.count * 100) + 213
                        }
                    }
                }
                return CGFloat(cellHeight)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell: HeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as? HeaderTableViewCell
            cell?.configureCell(title:(screenTitle ?? ""))
            cell?.delegate = self
            cell?.datelabel?.text = selectedDateLong
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.selectionStyle = .none
            
            return cell ?? UITableViewCell()
        }else //if(indexPath.section == 2)
        {
            if(screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false)
            {
                let cell: AppliancesTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AppliancesTableViewCell") as? AppliancesTableViewCell
                cell?.delegate = self
                var cellString = ""
                
                let cellIndex = indexPath.row
                if (indexPath.section == 1) {
                    cellString = cookedNameArray [indexPath.row] as? String ?? ""
                    cell?.mySubLabel?.text = "\(minCookingTemp)" + "°"
                    cell?.enterCommentTextField?.placeholder = "Temperature above " + "\(minCookingTemp)" + "°C else add comment"

                    
                }else if(indexPath.section == 2)
                {
                    cellString = hotHoldingNameArray[indexPath.row] as? String ?? ""
                    cell?.mySubLabel?.text = "\(hotHoldingTemp)" + "°"
                    cell?.enterCommentTextField?.placeholder = "Temperature above " + "\(hotHoldingTemp)" + "°C else add comment"

                }else if(indexPath.section == 3)
                {
                    cellString = reheatingNameArray[indexPath.row] as? String ?? ""
                    cell?.mySubLabel?.text = "\(reHeatingTemp)" + "°"
                    cell?.enterCommentTextField?.placeholder = "Temperature above " + "\(reHeatingTemp)" + "°C else add comment"

                }
                cell?.dropDownButton?.tag = indexPath.row
                cell?.myLabel?.text = cellString
                cell?.myImageView?.image = #imageLiteral(resourceName: "defaultIcon")
                
                if (cellString.equalsIgnoreCase(string: "chicken")) {
                    cell?.myImageView?.image = #imageLiteral(resourceName: "group2")
                }
                cell?.enterTempTextField?.tag = cellIndex
                cell?.enterCommentTextField?.tag = cellIndex
                
                //            cell.setupCellContentWithHeight(height: 25 * 40)
                //                cell?.myLabel?.text = "\(foodCheckArray[indexPath.row])"
                cell?.enterCommentTextField?.delegate = self
                cell?.enterTempTextField?.delegate = self
                //                cell?.appliancesCellBottomHeightConstraint?.constant = 9
                cell?.appliancestopHeightConstraint?.constant = 66
                
                if (indexPath == self.selectedIndexPath) {
                    cell?.arrowImageView?.image = #imageLiteral(resourceName: "group3")
                    
                }else{
                    cell?.arrowImageView?.image = #imageLiteral(resourceName: "dropdownIcon")
                    
                }
                
                cell?.selectionStyle = .none
                return cell ?? UITableViewCell()
            }else if(screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false){
                
                
                
                if (indexPath.row == 4) {
                    let cell: TemperatureTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "TemperatureTableViewCell") as? TemperatureTableViewCell
                    cell?.myTextField?.delegate = self
                    cell?.delegate = self
                        cell?.myTextField?.text = tempSelected

                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                    
                    return cell ?? UITableViewCell()
                }else if (indexPath.row == 5) {
                    let cell: CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell
                    cell?.myTextField?.delegate = self
                    cell?.delegate = self
                        cell?.myTextField?.text = commentSelected
                        
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                    
                    return cell ?? UITableViewCell()
                }else if (indexPath.row == 0) {
                    let cell: TextFieldTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as? TextFieldTableViewCell
                    cell?.mytextField?.delegate = self
                    
                    cell?.mytextField?.text = invoiceSelected
                        
                    cell?.delegate = self
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                    
                    return cell ?? UITableViewCell()
                }else if (indexPath.row == 2) {
                    let cell: DatePickupTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DatePickupTableViewCell") as? DatePickupTableViewCell
                    cell?.myLabel?.text = selectedDateUseByLong
                    cell?.delegate = self
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                    
                    return cell ?? UITableViewCell()
                }else if(indexPath.row == 1)
                {
                    let cell: TextFieldTypeCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldTypeCell") as? TextFieldTypeCell
                    cell?.cellName = "\(deliveryCheckArray[indexPath.row])"
                    
                    if(isDropDownSelectd ?? false == false)
                    {
                        cell?.myLabel?.text = "\(deliveryCheckArray[indexPath.row])"
                        
                    }
                    cell?.selectionStyle = .none
                    cell?.delegate = self
                    var supplier = [String]()
                    
                    if let arraySupp =  completeData?["suppliers"].array
                    {
                        for sup in arraySupp {
                            supplier.append(sup["name"].string ?? "")
                        }
                    }
                    cell?.configueCellData(label:"", textField:"" , dataArr : supplier )
                    return cell ?? UITableViewCell()
                    
                }
                let cell: TextFieldTypeCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldTypeCell") as? TextFieldTypeCell
                cell?.delegate = self
                cell?.cellName = "\(deliveryCheckArray[indexPath.row])"
                
//                if(isDropDownSelectd ?? false == false)
//                {
                    cell?.myLabel?.text = "\(deliveryCheckArray[indexPath.row])"
                    
//                }
                
                cell?.configueCellData(label:"", textField:"" , dataArr : deliveryCheckArrayDetail[indexPath.row])
                
                //                cell?.myTextField?.delegate = self
                cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                
                return cell ?? UITableViewCell()
            }else if(screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false)
            {
                
                let cell: TableViewCellforTwoHeader? = tableView.dequeueReusableCell(withIdentifier: "TableViewCellforTwoHeader") as? TableViewCellforTwoHeader
                cell?.delegate = self
                cell?.setupCellContentWithHeight(height: 25.0 * (fridge1Enabled == true ? 84.0 : fridge2Enabled == true ? 66.0 : 0) , index:(fridge1Enabled == true ? 4 : fridge2Enabled == true ? 5 : 4),dict:completeData ?? [])
                cell?.selectionStyle = .none
                
                return cell ?? UITableViewCell()
            }else if(screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false)
            {
                
                if (indexPath.row == 0) {
                    let cell: TextFieldTypeCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldTypeCell") as? TextFieldTypeCell
                    cell?.delegate = self
                    cell?.cellName = "Type of Injury"
                    
                    cell?.myLabel?.text = "Type of Injury"
                    cell?.dropDownArray = ["Minor", "Serious", "Death"]
                    //                    cell?.myTextField?.delegate = self
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
//                    if(isDropDownSelectd ?? false == false)
//                    {
                        cell?.configueCellData(label:"", textField:"" , dataArr : ["Minor", "Serious", "Death"])
                        
//                    }
                    
                    return cell ?? UITableViewCell()
                }else{
                    
                    
                    let cell: CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell
                    cell?.myTextField?.delegate = self
                    cell?.myTextField?.placeholder = "Add details here"
                    cell?.myLabel?.text = "SUMMARY"
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                    cell?.delegate = self
                    cell?.myTextField?.text = ""
                    return cell ?? UITableViewCell()
                }
                
            }else if(screenTitle?.equalsIgnoreCase(string: "Pest Control")  ?? false)
            {
                
                if (indexPath.row == 0) {
                    let cell: TextFieldTypeCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldTypeCell") as? TextFieldTypeCell
                    cell?.delegate = self
                    cell?.cellName = "Sign of Pest"
                    
                    cell?.myLabel?.text = "Sign of Pest"
                    //                    cell?.dropDownArray = ["Droppings", "Cockroaches", "Other"]
                    //                    cell?.myTextField?.delegate = self
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
//                    if(isDropDownSelectd ?? false == false)
//                    {
                        cell?.configueCellData(label:"", textField:"" , dataArr : ["Droppings", "Cockroaches", "Other"])
                        
//                    }
                    return cell ?? UITableViewCell()
                }else{
                    
                    
                    let cell: CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as? CommentTableViewCell
                    cell?.myTextField?.delegate = self
                    cell?.myTextField?.placeholder = "Add details here"
                    cell?.myLabel?.text = "SUMMARY"
                    cell?.myTextField?.text = ""
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none;
                    
                    return cell ?? UITableViewCell()
                }
                
            }else if(screenTitle?.equalsIgnoreCase(string: "Probe Check")  ?? false)
            {
                
                if (indexPath.row == 0) {
                    
                    
                    let cell: ProbeRadioTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ProbeRadioTableViewCell") as? ProbeRadioTableViewCell
                    //                    cell?.delegate = self
                    cell?.selectionStyle = .none
                    cell?.mySwitch?.setOn(isProbeWorking ?? false, animated: true)
                    return cell ?? UITableViewCell()
                    
                }else if(indexPath.row == 1){
                    
                    let cell: AfterUseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AfterUseTableViewCell") as? AfterUseTableViewCell
                    cell?.delegate = self
                    cell?.crossButton?.tag = indexPath.row
                    cell?.selectionStyle = .none
                    cell?.crossButton?.isHidden = true
                    cell?.titleLabel?.text = "ICE TEST"
                    cell?.radioButton?.tag = 555
                    cell?.radioButton?.isSelected = iceTest
                    cell?.descLabel?.text = "Put probe in ice water and see that the probe shows 0 degrees"
                    
                    return cell ?? UITableViewCell()
                }else
                {
                    let cell: AfterUseTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AfterUseTableViewCell") as? AfterUseTableViewCell
                    cell?.delegate = self
                    cell?.crossButton?.tag = indexPath.row
                    cell?.selectionStyle = .none
                    cell?.radioButton?.isSelected = boilingWater

                    cell?.titleLabel?.text = "BOILING WATER TEST"
                    cell?.descLabel?.text = "Put probe in boiling water and see it shows 100 degree"
                    cell?.radioButton?.tag = 666
                    cell?.crossButton?.isHidden = true
                    return cell ?? UITableViewCell()
                    
                }
                
            }else if(screenTitle?.equalsIgnoreCase(string: "View Log")  ?? false)
            {
                
                let cell: ViewLogTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ViewLogTableViewCell") as? ViewLogTableViewCell
                cell?.selectionStyle = .none
                cell?.configutreCellData(viewLogData:viewLogData ?? [] , index:indexPath.row)
                return cell ?? UITableViewCell()
                
            }else
            {
                var inde:Int = 0
                if(checkListEnabled ?? false)
                {
                    inde = 0
                }else if(appliancesEnabled ?? false)
                {
                    inde = 1
                }else if(foodEnabled ?? false)
                {
                    inde = 2
                }else
                {
                    inde = 5
                }
                let cell: TableViewCell2? = tableView.dequeueReusableCell(withIdentifier: "TableViewCell2") as? TableViewCell2
                cell?.setupCellContentWithHeight(height:CGFloat(0), index:inde ,dict:completeData ?? [],screenName:screenTitle ?? "" ,markAll:markAllEnabled ?? false , refresh:isRefreshData)
                cell?.selectionStyle = .none
                cell?.delegate = self
                return cell ?? UITableViewCell()
            }
            
            
        }
        
    }
    
    func textFieldTypeCellDelegateDroDownSelected(title: String, index: NSInteger, celltype: String)
    {
        if (celltype == "Supplier") {
            supplierSelected = title
        }
        
        if (celltype == "Packaging State") {
            packagingSelected = title
            
        }
        
        isDropDownSelectd = true
    }
    
    func markAllGridViewCellDelegateTapped(index:NSInteger)
    {
        if (screenTitle?.equalsIgnoreCase(string: "Cleaning Check") ?? false)
        {
            switch index {
            case 0:
                isMarAllTab1 = true
                self.setRadioButtonsTab1(dataArray: self.completeData?["cleaning"][0]["categories"][0]["items"].array?.count ?? 0 , isSelected: "YES")
            case 1:
                isMarAllTab2 = true
                self.setRadioButtonsTab2(dataArray: self.completeData?["cleaning"][0]["categories"][1]["items"].array?.count ?? 0 ,isSelected: "YES")
            case 2:
                isMarAllTab3 = true
                self.setRadioButtonsTab3(dataArray: self.completeData?["cleaning"][0]["categories"][2]["items"].array?.count ?? 0 , isSelected: "YES")
            default:
                print("mark all ", index)
            }
        }else if(screenTitle?.equalsIgnoreCase(string: "opening Check") ?? false)
        {
            isMarAllTab1 = true
            self.setRadioButtonsTab1(dataArray: self.completeData?["opening"][0]["items"].array?.count ?? 0 , isSelected: "YES")
        }else if(screenTitle?.equalsIgnoreCase(string: "closing Check") ?? false)
        {
            isMarAllTab1 = true
            self.setRadioButtonsTab1(dataArray: self.completeData?["closing"][0]["items"].array?.count ?? 0 , isSelected: "YES")
        }
        markAllEnabled = true
        self.myTableView?.reloadData()
    }
    func crossButtonclickedChecklistTableViewCell()
    {
        
    }
    func crossButtonclicked(index:Int)
    {
        
    }
    func dropDowntapped(index:Int, section:Int)
    {
        let sec = 0
        let row = 0;
        let indexpath = NSIndexPath(row: index, section: sec)
       
        if (indexpath as IndexPath == self.selectedIndexPath) {
            self.selectedIndexPath = nil
        }else{
            self.selectedIndexPath = indexpath as IndexPath

        }
    }
    
    
    func initComponents()
    {
        datepickerBGView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(datepickerBGView ?? UIView())
        datepickerBGView?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        datPicker = UIDatePicker()
        //        datPicker?.datePickerMode = UIDatePickerMode.date
        datPicker?.frame = CGRect(x: 0, y: screenSize.height - 216, width: screenSize.width, height: 216)
        //you probably don't want to set background color as black
        datPicker?.backgroundColor = .white
        datepickerBGView?.addSubview(datPicker ?? UIDatePicker())
        datepickerBGView?.isHidden = true
        
        // ToolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: (datPicker?.frame.origin.y) ?? 0 - 30, width: screenSize.width, height: 30))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 196/255, green: 238/255, blue: 156/255 , alpha: 1)
        toolBar.backgroundColor = .clear
        toolBar.sizeToFit()
        toolBar.barTintColor = UIColor.white
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datepickerBGView?.addSubview(toolBar)
    }
    func datePickerDelegateMethod(){
        self.view.endEditing(true)
        isUseByClicked = false
        self.datepickerBGView?.alpha = 0
        self.datepickerBGView?.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.datepickerBGView?.alpha = 1
        }, completion: {
            finished in
            self.datepickerBGView?.isHidden = false
        })
        //        datepickerBGView?.visible = true
        
    }
    func doneClick()
    {
        let date = datPicker?.date ?? Date()
        
        let formatterLong = DateFormatter()
        formatterLong.dateFormat = "MMM dd hh:mm  a"
        let resultLong = formatterLong.string(from: date)
        
        let formatterMid = DateFormatter()
        formatterMid.dateFormat = "dd-MM-yyyy"
        let resultMid = formatterMid.string(from: date)
        
        if(isUseByClicked ?? false){
            selectedDateUseByLong = resultLong
            selectedDateUseByMid = resultMid
        }else
        {
            selectedDateMid = resultMid
            selectedDateLong = resultLong
        }
        
        self.myTableView?.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.datepickerBGView?.alpha = 0
        }, completion: {
            finished in
            self.datepickerBGView?.isHidden = true
        })
    }
    func cancelClick()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.datepickerBGView?.alpha = 0
        }, completion: {
            finished in
            self.datepickerBGView?.isHidden = true
        })
    }
    
    func refreshPageData()
    {
        tab1Array.removeAllObjects()
        tab2Array.removeAllObjects()
        tab3Array.removeAllObjects()
        foodArray.removeAll()
        frigdeArray.removeAll()
        freezerArray.removeAll()
        
        isMarAllTab1 = false
        isMarAllTab2 = false
        isMarAllTab3 = false
    }
    func refreshTabsData(){
        
        
        checkListEnabled = false
        appliancesEnabled = false
        foodEnabled = false
        fridge1Enabled = false
        fridge2Enabled = false
        
    }
    func buttonTapped(title:String , index:NSInteger)
    {
        isRefreshData = false
        if (currentGridButtonindex != index) {
            markAllEnabled = false
        }
        refreshTabsData()
        switch index {
        case 0:
            checkListEnabled = true
            break;
        case 1:
            appliancesEnabled = true
            break;
        case 2:
            foodEnabled = true
            break;
        case 4:
            fridge1Enabled = true
            break;
        case 5:
            fridge2Enabled = true
            break;
            
        default:
            print("no data")
        }
        //        tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
        currentGridButtonindex = index
        myTableView?.reloadData()
    }
    
    override func cellDidSelectWithIndexAndtitle(index: NSInteger, title: String) {
        screenTitle = title

        if(UIDevice.current.userInterfaceIdiom == .pad && (screenTitle?.equalsIgnoreCase(string: "pest control")  ?? false || (screenTitle?.equalsIgnoreCase(string: "injury log")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "probe check")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false) || (screenTitle?.equalsIgnoreCase(string: "delivery check")  ?? false)))
        {
            self.myTableView?.frame.size.width = 375
            self.view.backgroundColor = UIColor.black
        }else
        {
            self.myTableView?.frame.size.width = screenSize.width
            self.view.backgroundColor = UIColor.white
        }
        invoiceSelected = ""
        packagingSelected = ""
        supplierSelected = ""
        tempSelected = ""
        degreeSelected = "C"
        commentSelected = ""
        iceTest = false
        boilingWater = false
        print("side menu clicked",title)
        deliVeryTempOnOff = 1
        self.datPicker?.setDate(Date(), animated: false)
        self.doneClick()
        isRefreshData = true
        refreshPageData()
        checkListEnabled = true
        fridge1Enabled = true
        currentGridButtonindex = 0
        
        hotHoldingNameArray.removeAllObjects()
        cookedNameArray.removeAllObjects()
        reheatingNameArray.removeAllObjects()
        let foodArray = self.completeData?["entryDefaults"][0]["foods"].array?.count ?? 0
        for i in 0..<foodArray{
            if(self.completeData?["entryDefaults"][0]["foods"][i]["hotHolding"].boolValue ?? false){
                hotHoldingNameArray.add(self.completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
            }
            if(self.completeData?["entryDefaults"][0]["foods"][i]["cooked"].boolValue ?? false){
                cookedNameArray.add(self.completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
            }
            if(self.completeData?["entryDefaults"][0]["foods"][i]["reheating"].boolValue ?? false){
                reheatingNameArray.add(self.completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? "")
            }
        }
        
        myTableView?.reloadData()

        super.hideSideMenu()
        let indexPath = NSIndexPath(row: 0, section: 0)
        myTableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        if(screenTitle?.equalsIgnoreCase(string: "View Log")  ?? false)
        {
            LoadingOverlay.shared.showOverlay(view:self.view, msg: "Fetching data...")
            self.getViewLogData()
            saveButton?.isHidden = true
            print("true")
        }else
        {
            saveButton?.isHidden = false
        }
        
        
        if(screenTitle?.equalsIgnoreCase(string: "opening check")  ?? false)
        {
            // pankaj
            self.setRadioButtonsTab1(dataArray: self.completeData?["opening"][0]["items"].array?.count ?? 0 , isSelected: "NO")
            // appliances
            self.setfridgeArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0 , isSelected: "NO")
            self.setfreezerArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0 , isSelected: "NO")
            
            // food
            
            self.setfoodArrayData1(dataArray: cookedNameArray.count , isSelected: "NO")
            self.setfoodArrayData2(dataArray: hotHoldingNameArray.count , isSelected: "NO")
            self.setfoodArrayData3(dataArray: reheatingNameArray.count , isSelected: "NO")
        }
        
        if(screenTitle?.equalsIgnoreCase(string: "closing check")  ?? false)
        {
            self.setRadioButtonsTab1(dataArray: self.completeData?["closing"][0]["items"].array?.count ?? 0 , isSelected: "NO")
            // appliances
            self.setfridgeArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0 , isSelected: "NO")
            self.setfreezerArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0 , isSelected: "NO")
            
            // food
            self.setfoodArrayData1(dataArray: cookedNameArray.count , isSelected: "NO")
            self.setfoodArrayData2(dataArray: hotHoldingNameArray.count , isSelected: "NO")
            self.setfoodArrayData3(dataArray: reheatingNameArray.count , isSelected: "NO")

        }
        
        if(screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false)
        {
            // pankaj
            self.setfridgeArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0 , isSelected: "NO")
            self.setfreezerArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0 , isSelected: "NO")
        }
        
      
        if(screenTitle?.equalsIgnoreCase(string: "food")  ?? false)
        {
            self.setfoodArrayData1(dataArray: cookedNameArray.count , isSelected: "NO")
            self.setfoodArrayData2(dataArray: hotHoldingNameArray.count , isSelected: "NO")
            self.setfoodArrayData3(dataArray: reheatingNameArray.count , isSelected: "NO")

            
        }
        
        if(screenTitle?.equalsIgnoreCase(string: "cleaning check")  ?? false)
        {
            // pankaj
            self.setRadioButtonsTab1(dataArray: self.completeData?["cleaning"][0]["categories"][0]["items"].array?.count ?? 0 , isSelected: "NO")
            self.setRadioButtonsTab2(dataArray: self.completeData?["cleaning"][0]["categories"][1]["items"].array?.count ?? 0 , isSelected: "NO")
            self.setRadioButtonsTab3(dataArray: self.completeData?["cleaning"][0]["categories"][2]["items"].array?.count ?? 0 , isSelected: "NO")
        }
        
    }
    //*****************************************************************
    // delegate of cells
    
    func temperatureOnOff(index:NSInteger)
    {
        deliVeryTempOnOff = index
    }
    func tableViewCell2FoodDelegate(index:Int, temp: String , comment: String , section :Int)
    {
        if(section ==  0)
        {
            if(Int(temp) ?? 0 < minCookingTemp && comment == ""){
                let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be Above or equal to " + "\(minCookingTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                
                //self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                
            }
            foodArray[index] = ["temp":temp, "comment":comment]

           
        }else if(section == 1)
        {
            if(Int(temp) ?? 0 < hotHoldingTemp && comment == ""){
                let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be Above or equal to " + "\(hotHoldingTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                
                //self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                
            }
            foodArray2[index] = ["temp":temp, "comment":comment]

//            self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag)
        }else if(section == 2)
        {
            if(Int(temp ) ?? 0 < reHeatingTemp && comment == ""){
                let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be Above or equal to " + "\(reHeatingTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                
                //self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                
            }
            foodArray3[index] = ["temp":temp, "comment":comment]

        }

    }
    func tableViewCell2FreezerDelegate(index: Int, temp: String, comment: String) {
        
        if(Int(temp) ?? 0 > -18 && comment == ""){
            
            let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be less than or equal to " + "\(-18)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            super.present(alert, animated: true, completion: nil)
            
        }
        
        freezerArray[index] = ["temp":temp, "comment":comment]

    }
    
    func tableViewCell2FridgeDelegate(index: Int, temp: String, comment: String) {
        
        if(Int(temp) ?? 0 > fridgeTemp && comment == ""){
            
            let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be less than or equal to " + "\(fridgeTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            super.present(alert, animated: true, completion: nil)
            
        }
        
        frigdeArray[index] = ["temp":temp, "comment":comment]

    }

    func tableViewCellforTwoHeaderFridgeDelegate(index: Int, temp: String, comment: String ,section:Int) {
        
        if(Int(temp) ?? 0 > fridgeTemp){
            
            let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be less than or equal to " + "\(fridgeTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            super.present(alert, animated: true, completion: nil)
            
            self.dropDowntapped(index: index, section: section)

        }
        frigdeArray[index] = ["temp":temp, "comment":comment]

    }
    func tableViewCellforTwoHeaderFreezerDelegate(index: Int, temp: String, comment: String ,section:Int) {
        if(Int(temp) ?? 0 > -18){
            
            let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be less than or equal to " + "\(-18)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            super.present(alert, animated: true, completion: nil)
            self.dropDowntapped(index: index, section: section)

        }
        freezerArray[index] = ["temp":temp, "comment":comment]
    }
    
    func tableViewCell2DelegateRadioClicked(index: Int, gridNo: NSInteger, isSelected: String) {
     
        switch gridNo {
        case 0:
            tab1Array[index] = isSelected
        case 1:
            tab2Array[index] = isSelected
        case 2:
            tab3Array[index] = isSelected
        default:
            print("gadbad jhale")
        }
        
    }
    
    func commentTableViewCellDelegate(str:String, cellName:String)
    {
        if(cellName == "COMMENTS"){
            commentSelected = str
        }
    }
    func temperatureTableViewCellDelegateSelected(degree:String , index:NSInteger , tempValue:String)
    {
        tempSelected = tempValue
        degreeSelected = degree
        
    }
    func textFieldTableViewCellDelegate(str:String)
    {
        invoiceSelected = str
    }
    func datePickupTableViewCellDelegateTapped(title:String , index:NSInteger)
    {
        datePickerDelegateMethod()
        isUseByClicked = true
        
    }
    func addAnotherLogDidTap(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func timeAndDateDidTap() {
        print("1234")
    }
    override func openSideMenu(_ sender: Any) {
        markAllEnabled = false
//        self.myTableView?.reloadData()
        super.openSideMenu(sender)
        isRefreshData = false

        
    }
    @IBAction func navigationSideMenuClicked(_ sender: AnyObject) {
        
    }
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func radioButtonClickedAfterUseTableViewCell(index: Int, radioSelected: String)
    {
//        if (index == 555 || index == 666) {
            let cell2 : AfterUseTableViewCell? = self.myTableView?.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as? AfterUseTableViewCell
            let cell3 : AfterUseTableViewCell? = self.myTableView?.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath) as? AfterUseTableViewCell
        iceTest = cell2?.radioButton?.isSelected ?? false
        boilingWater = cell3?.radioButton?.isSelected ?? false
            if((cell2?.radioButton?.isSelected ?? false) && (cell3?.radioButton?.isSelected ?? false))
            {
                isProbeWorking = true
            }else
            {
                isProbeWorking = false
            }
            myTableView?.reloadData()
//        }
    }
    
    
    //***************************************** SAVE Requests *****************************************//
    //***************************************** SAVE Requests *****************************************//
    //***************************************** SAVE Requests *****************************************//
    
    
    
    @IBAction func saveLogClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        LoadingOverlay.shared.showOverlay(view:self.view, msg: "")
        
        let selectedDateUseByArray = selectedDateUseByLong?.characters.split{$0 == " "}.map(String.init)
        
        let hrs0mins1Useby = selectedDateUseByArray?[2].characters.split{$0 == ":"}.map(String.init)
        
        let selectedDateArray = selectedDateLong?.characters.split{$0 == " "}.map(String.init)
        let hrs0mins1 = selectedDateArray?[2].characters.split{$0 == ":"}.map(String.init)
//        let date = (selectedDateArray?[0] ?? "") + " " + (selectedDateArray?[1] ?? "")
//        let userEmail : String = UserDefaults.standard.value(forKey: "email") as? String ?? ""
        
        let amOrPm = selectedDateArray?[3] ?? ""
        
        var entryHrs : Int = Int((hrs0mins1?[0]) ?? "0") ?? 0
        if(amOrPm.equalsIgnoreCase(string:"pm")){
            entryHrs = entryHrs + 12
        }
        let amOrPmUseBy = selectedDateUseByArray?[3] ?? ""

        var useByHrs : Int = Int((hrs0mins1Useby?[0]) ?? "0") ?? 0
        if(amOrPmUseBy.equalsIgnoreCase(string:"pm")){
            useByHrs = useByHrs + 12
        }
        
        let userData : JSON = ItsRequest.sharedInstance.loadJSON(key: "userData")

        let useByMins = hrs0mins1Useby?[1] ?? ""
//        let useByHrs = hrs0mins1Useby?[0] ?? ""
        let entryMins = hrs0mins1?[1] ?? ""
//        let entryHrs = hrs0mins1?[0] ?? ""
        
        if(screenTitle?.equalsIgnoreCase(string: "FOOD")  ?? false)
        {
            var isDataMissing = false
            for i in 0..<foodArray.count{
                if(foodArray[i]["temp"].string == "" && foodArray[i]["comment"].string == "")
                {
                    isDataMissing = true
                    break
                }
            }
            if(isDataMissing) {
            let alert = UIAlertController(title: "Missing fields", message: "Please complete the form", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            super.present(alert, animated: true, completion: nil)
            LoadingOverlay.shared.hideOverlayView()
            return
            }
            
            
            let cookedArray = NSMutableArray()
            let reHeatingArray = NSMutableArray()
            let hotHoldingArray = NSMutableArray()
            
            
            for i in 0..<cookedNameArray.count {
                //                let commentRequiredCooked = completeData?["entryDefaults"][0]["foods"][i]["cooked"].string ?? ""
                let name = "\(cookedNameArray[i])"
                let temp = foodArray[i]["temp"].string
                let comment = foodArray[i]["comment"].string
                cookedArray.add(["name":name,"type":"cooked","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                
            }
            
            for i in 0..<hotHoldingNameArray.count {
                //                let commentRequiredHotHold = completeData?["entryDefaults"][0]["foods"][i]["hotHolding"].string ?? ""
                let name = "\(hotHoldingNameArray[i])"
                let temp = foodArray2[i]["temp"].string
                let comment = foodArray2[i]["comment"].string
                hotHoldingArray.add(["name":name,"type":"hotHolding","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                
            }
            
            for i in 0..<reheatingNameArray.count {
                //                let commentRequiredReHeat = completeData?["entryDefaults"][0]["foods"][i]["reheating"].string ?? ""
                let name = "\(reheatingNameArray[i])"
                let temp = foodArray3[i]["temp"].string
                let comment = foodArray3[i]["comment"].string
                reHeatingArray.add(["name":name,"type":"reHeating","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
            }

            
//            let arr1 = self.completeData?["entryDefaults"][0]["foods"].array?.count ?? 0
//            for i in 0..<arr1 {
//                let commentRequiredCooked = completeData?["entryDefaults"][0]["foods"][i]["cooked"].string ?? ""
//                let commentRequiredReHeat = completeData?["entryDefaults"][0]["foods"][i]["reheating"].string ?? ""
//                let commentRequiredHotHold = completeData?["entryDefaults"][0]["foods"][i]["hotHolding"].string ?? ""
//                let name = completeData?["entryDefaults"][0]["foods"][i]["name"].string ?? ""
//                let temp = foodArray[i]["temp"].string
////                let comment = foodArray[i]["comment"].string
//                cookedArray.add(["name":name,"type":"cooked","temperature":temp,"commentRequired":commentRequiredCooked])
//                reHeatingArray.add(["name":name,"type":"reHeating","temperature":temp,"commentRequired":commentRequiredReHeat])
//                hotHoldingArray.add(["name":name,"type":"hotHolding","soldOut":commentRequiredHotHold])
//            }

            let templateName = self.completeData?["entryDefaults"][0]["name"].string ?? ""

            let param  = [
                "template":templateName,"entryTime":selectedDateMid,"assetEntries":[],"foodEntries":[],"entryHrs":(hrs0mins1?[0]) ?? "","entryMins":(hrs0mins1?[1]) ?? "","completed":true,"entryhrs":"null","entrymins":"null",
                "cooked":cookedArray,
                "reHeating":reHeatingArray,
                "hotHolding":hotHoldingArray,
                "locationId":locIDOpening,"businessId":bussIdOpening,
                "createdBy":["authenticated":true,"name":userData["name"],"businessId":bussIdOpening,"userType":userData["userType"]]] as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/entries", keyDatabase: "food_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })
            
        }else if (screenTitle?.equalsIgnoreCase(string: "Delivery check")  ?? false){
            
            
            var isDataMissing = false
                if(tempSelected == "" && invoiceSelected == "" && packagingSelected == "" && commentSelected == "")
                {
                    isDataMissing = true
                }
            if(isDataMissing) {
                let alert = UIAlertController(title: "Missing fields", message: "Please complete the form", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
                return
            }
            
            if(deliVeryTempOnOff == 0)
            {
                degreeSelected = "C"
                tempSelected = ""
            }
            var supplierId = ""
            if let arraySupp =  completeData?["suppliers"].array
            {
                for sup in arraySupp {
                    if(sup["name"].string ==  supplierSelected)
                    {
                        supplierId = sup["_id"].string ?? ""
                    }
                }
            }
            
            let paramInner = ["unit":degreeSelected,"value":tempSelected]
            let param  = ["useByMins":useByMins,"entryTime":selectedDateMid ,"useByDate":selectedDateUseByMid ?? "","locationId":locIDOpening,"supplier":supplierId,"invoiceNumber":invoiceSelected,"entryHrs":entryHrs,"useByDt":selectedDateUseByMid ?? "","packagingState":packagingSelected,"temperature":paramInner,"entryMins":entryMins,"comment":commentSelected,"useByHrs":useByHrs] as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/delivery", keyDatabase: "delivery_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })
            
        }else if(screenTitle?.equalsIgnoreCase(string: "Injury log")  ?? false)
        {
            let cell1 : TextFieldTypeCell? = myTableView?.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as? TextFieldTypeCell
            let cell2 : CommentTableViewCell? = self.myTableView?.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as? CommentTableViewCell
            
            var isDataMissing = false
            if((cell2?.myTextField?.text ?? "") == "" && (cell1?.myLabel?.text ?? "") == "")
            {
                isDataMissing = true
            }
            if(isDataMissing) {
                let alert = UIAlertController(title: "Missing fields", message: "Please complete the form", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
                return
            }
            
            
            
            let param  = [
                "locationId": locIDOpening,
                "businessId": bussIdOpening,
                "date":selectedDateMid,
                "hrs":(hrs0mins1?[0]) ?? "",
                "mins":(hrs0mins1?[1]) ?? "",
                "summary":cell2?.myTextField?.text ?? "",
                "injuryType":cell1?.myLabel?.text ?? ""
            ] as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/miscchecks/injury", keyDatabase: "injury_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })
            
        }else if(screenTitle?.equalsIgnoreCase(string: "Probe check")  ?? false)
        {
            
            let cell2 : AfterUseTableViewCell? = self.myTableView?.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as? AfterUseTableViewCell
            let cell3 : AfterUseTableViewCell? = self.myTableView?.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath) as? AfterUseTableViewCell
            
            let isCell2 = cell2?.radioButton?.isSelected ?? false
            let isCell3 = cell3?.radioButton?.isSelected ?? false
            
            
//            var isDataMissing = false
//            if(isCell2 == false && isCell3 == false)
//            {
//                isDataMissing = true
//            }
//            if(isDataMissing) {
//                let alert = UIAlertController(title: "Missing fields", message: "Please complete the form", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                super.present(alert, animated: true, completion: nil)
//                LoadingOverlay.shared.hideOverlayView()
//                return
//            }

            
            let param  = [
                "locationId": locIDOpening,
                "businessId": bussIdOpening,
                "date":selectedDateMid,
                "hrs":(hrs0mins1?[0]) ?? "",
                "mins":(hrs0mins1?[1]) ?? "",
                "isIceTestWorking":"\(isCell2)",
                "isBoilingWaterTestWorking":"\(isCell3)"
            ] as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/miscchecks/probe", keyDatabase: "probe_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })

            
        }else if(screenTitle?.equalsIgnoreCase(string: "Pest Control")  ?? false)
        {
            
            
            let cell1 : TextFieldTypeCell? = myTableView?.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as? TextFieldTypeCell
            let cell2 : CommentTableViewCell? = self.myTableView?.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as? CommentTableViewCell
            
            var isDataMissing = false
            if((cell2?.myTextField?.text ?? "") == "" && (cell1?.myLabel?.text ?? "") == "")
            {
                isDataMissing = true
            }
            if(isDataMissing) {
                let alert = UIAlertController(title: "Missing fields", message: "Please complete the form", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
                return
            }
            
            
            let param  = [
                "locationId": locIDOpening,
                "businessId": bussIdOpening,
                "date":selectedDateMid,
                "hrs":(hrs0mins1?[0]) ?? "",
                "mins":(hrs0mins1?[1]) ?? "",
                "summary":cell2?.myTextField?.text ?? "",
                "signofPest":cell1?.myLabel?.text ?? ""
                ] as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/miscchecks/pest", keyDatabase: "pest_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })

            
        }else if (screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false){
            
            
            var isDataMissing = false
            for i in 0..<frigdeArray.count{
                if(frigdeArray[i]["temp"].string == "" && frigdeArray[i]["comment"].string == "")
                {
                    isDataMissing = true
                    break
                }
            }
            for i in 0..<freezerArray.count{
                if(freezerArray[i]["temp"].string == "" && freezerArray[i]["comment"].string == "")
                {
                    isDataMissing = true
                    break
                }
            }

            
            if(isDataMissing) {
                let alert = UIAlertController(title: "Missing fields", message: "Please complete the form", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
                return
            }
            
            let assetsArray = NSMutableArray()

            
            
            let arr1 = completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0
            for i in 0..<arr1 {
                let temp = frigdeArray[i]["temp"].string ?? ""
                let comment = frigdeArray[i]["comment"].string ?? ""
                let commentrequired = (frigdeArray[i]["comment"].string?.characters.count ?? 0) > 0 ? true : false
                assetsArray.add(["type":"fridge","comment":comment,"unit":"C","temperature":temp,"commentRequired":commentrequired])
            }
            
            
            let arr2 = completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0
            for i in 0..<arr2 {
                let temp = freezerArray[i]["temp"].string ?? ""
                let comment = freezerArray[i]["comment"].string ?? ""
                let commentrequired = (freezerArray[i]["comment"].string?.characters.count ?? 0) > 0 ? true : false
                assetsArray.add(["type":"freezer","comment":comment,"unit":"C","temperature":temp,"commentRequired":commentrequired])
            }
            let templateName = self.completeData?["entryDefaults"][0]["name"].string ?? ""

            let param  = ["template":templateName,"entryTime":selectedDateMid,
                          "assetEntries":assetsArray,
                "foodEntries":"null","entryHrs":(hrs0mins1?[0]) ?? "","entryMins":(hrs0mins1?[1]) ?? "","completed":true,"entryhrs":"null","entrymins":"null","cooked": "null","reHeating":"null","hotHolding": "null","locationId":locIDOpening,"businessId":bussIdOpening,
                "createdBy":["authenticated":true,"name":entryDefaultsId,"businessId":bussIdOpening,"userType":"site-admin"]]  as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/entries", keyDatabase: "appliances_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })

        }else if (screenTitle?.equalsIgnoreCase(string: "Cleaning Check") ?? false)
        {
            let array1 = NSMutableArray()
            let arr1 = self.completeData?["cleaning"][0]["categories"][0]["items"].array?.count ?? 0
            for i in 0..<arr1 {
                let dictionary =  NSMutableDictionary()
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][0]["items"][i]["description"].string) ?? "", forKey: "description")
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][0]["items"][i]["task"].string) ?? "", forKey: "task")
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][0]["items"][i]["_id"].string) ?? "", forKey: "_id")
                dictionary.setValue((tab1Array[i] as AnyObject) , forKey: "state")
                
                array1.add(dictionary)
            }
            
            let array2 = NSMutableArray()
            let arr2 = self.completeData?["cleaning"][0]["categories"][1]["items"].array?.count ?? 0
            for i in 0..<arr2 {
                let dictionary =  NSMutableDictionary()
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][1]["items"][i]["description"].string) ?? "", forKey: "description")
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][1]["items"][i]["task"].string) ?? "", forKey: "task")
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][1]["items"][i]["_id"].string) ?? "", forKey: "_id")
                dictionary.setValue((tab2Array[i] as AnyObject) , forKey: "state")
                
                array2.add(dictionary)
            }
            
            let array3 = NSMutableArray()
            let arr3 = self.completeData?["cleaning"][0]["categories"][2]["items"].array?.count ?? 0
            for i in 0..<arr3 {
                let dictionary =  NSMutableDictionary()
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][2]["items"][i]["description"].string) ?? "", forKey: "description")
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][2]["items"][i]["task"].string) ?? "", forKey: "task")
                dictionary.setValue((self.completeData?["cleaning"][0]["categories"][2]["items"][i]["_id"].string) ?? "", forKey: "_id")
                dictionary.setValue((tab3Array[i] as AnyObject) , forKey: "state")
                
                array3.add(dictionary)
            }
            
            
            let afteruseID = (self.completeData?["cleaning"][0]["categories"][0]["_id"].string ?? "")
            let endDay = (self.completeData?["cleaning"][0]["categories"][1]["_id"].string ?? "")
            let deepClean = (self.completeData?["cleaning"][0]["categories"][2]["_id"].string ?? "")
            
            let templateName = self.completeData?["cleaning"][0]["name"].string ?? ""

            let param =
                ["template":["name":templateName,"_id":cleaningId],
                 "categories":
                    [
                        ["_id":afteruseID,"name":"After Use",
                         "items":array1,
                         "checkAllEnabled":isMarAllTab1,
                         "camelCaseName":"AfterUse"],
                        ["_id":endDay,"name":"End of Day",
                         "items":array2,
                         "checkAllEnabled":isMarAllTab2,"camelCaseName":"EndofDay"],
                        ["_id":deepClean,"name":"Deep Clean",
                         "items":array3,
                         "checkAllEnabled":isMarAllTab3,"camelCaseName":"DeepClean"]
                    ],
                 "entryTime":selectedDateMid ,
                 "entryHrs":(hrs0mins1?[0]) ?? "",
                 "entryMins":(hrs0mins1?[1]) ?? "",
                 "locationId":locIDCleaning,
                 "entryhrs":"null",
                 "entrymins":"null"] as JSON
            
            SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/cleaning", keyDatabase: "cleaning_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                self.showToast(message: text)
                LoadingOverlay.shared.hideOverlayView()

            })
        
    }else if (screenTitle?.equalsIgnoreCase(string: "Opening Check")  ?? false) {
            
            var f1 = 0;
            var f2 = 0;
            var f3 = 0;
            
            var a1 = 0;
            var a2 = 0;

            var isDataMissing = false
            for i in 0..<foodArray.count{
                if(foodArray[i]["temp"].string == "" && foodArray[i]["comment"].string == "")
                {
                    f1 = f1 + 1;
                    isDataMissing = true
                    break
                }
            }
            
            for i in 0..<foodArray2.count{
                if(foodArray2[i]["temp"].string == "" && foodArray2[i]["comment"].string == "")
                {
                    f2 = f2 + 1;
                    isDataMissing = true
                    break
                }
            }
            for i in 0..<foodArray3.count{
                if(foodArray3[i]["temp"].string == "" && foodArray3[i]["comment"].string == "")
                {
                    f3 = f3 + 1;
                    isDataMissing = true
                    break
                }
            }
            
            for i in 0..<frigdeArray.count{
                if(frigdeArray[i]["temp"].string == "" && frigdeArray[i]["comment"].string == "")
                {
                    a1 = a1 + 1;

                    isDataMissing = true
                    break
                }
            }
            for i in 0..<freezerArray.count{
                if(freezerArray[i]["temp"].string == "" && freezerArray[i]["comment"].string == "")
                {
                    a2 = a2 + 1;

                    isDataMissing = true
                    break
                }
            }
            
            func openingSave()
            {
                let fridgeArr = NSMutableArray()
                
                let assetsArrayarr1 = self.completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0
                for i in 0..<assetsArrayarr1 {
                    let temp = self.frigdeArray[i]["temp"].string ?? ""
                    let comment = self.frigdeArray[i]["comment"].string ?? ""
                    let commentrequired = (self.frigdeArray[i]["comment"].string?.characters.count ?? 0) > 0 ? true : false
                    fridgeArr.add(["fridgeNum":i + 1,"temperature":temp,"comment":comment,"commentRequired":commentrequired])
                }
                
                let freezerArr = NSMutableArray()
                
                let assetsArrayarr2 = self.completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0
                for i in 0..<assetsArrayarr2 {
                    let temp = self.freezerArray[i]["temp"].string ?? ""
                    let comment = self.freezerArray[i]["comment"].string ?? ""
                    let commentrequired = (self.freezerArray[i]["comment"].string?.characters.count ?? 0) > 0 ? true : false
                    freezerArr.add(["freezerNum":i + 1,"temperature":temp,"comment":comment,"commentRequired":commentrequired])
                }
                
                let array1 = NSMutableArray()
                let arr1 = self.completeData?["opening"][0]["items"].array?.count ?? 0
                for i in 0..<arr1 {
                    let openingData = self.completeData?["opening"][0]["items"][i]["description"].string ?? ""
                    array1.add(["description":openingData,"state":self.tab1Array[i] ])
                }
                
                
                let cookedArray = NSMutableArray()
                let reHeatingArray = NSMutableArray()
                let hotHoldingArray = NSMutableArray()
                
                
                for i in 0..<self.cookedNameArray.count {
                    let name = "\(self.self.cookedNameArray[i])"
                    let temp = self.self.foodArray[i]["temp"].string
                    let comment = self.self.foodArray[i]["comment"].string
                    cookedArray.add(["name":name,"type":"cooked","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                    
                }
                
                for i in 0..<self.hotHoldingNameArray.count {
                    let name = "\(self.self.hotHoldingNameArray[i])"
                    let temp = self.foodArray2[i]["temp"].string
                    let comment = self.foodArray2[i]["comment"].string
                    hotHoldingArray.add(["name":name,"type":"hotHolding","temperature":temp ?? "","commentRequired":false,"comment":comment ??
                        ""])
                    
                }
                
                for i in 0..<self.reheatingNameArray.count {
                    let name = "\(self.reheatingNameArray[i])"
                    let temp = self.foodArray3[i]["temp"].string
                    let comment = self.foodArray3[i]["comment"].string
                    reHeatingArray.add(["name":name,"type":"reHeating","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                }
                
                let openingID = self.completeData?["opening"][0]["_id"].string ?? ""
                let templateName = self.completeData?["opening"][0]["name"].string ?? ""
                let type = self.completeData?["opening"][0]["type"].string ?? ""
                let param = ["template":["name":templateName],"_id":openingID,"entryTime":self.selectedDateMid,"type":type,
                             "items":array1,
                             "entryHrs":(hrs0mins1?[0]) ?? "",
                             "entryMins":(hrs0mins1?[1]) ?? "",
                             "locationId":self.locIDOpening,
                             "entryhrs":"null","entrymins":"null",
                             "cooking":cookedArray.count > 0 ? cookedArray : [],
                             "hotHolding":hotHoldingArray.count > 0 ? hotHoldingArray : [],
                             "reHeating":reHeatingArray.count > 0 ? reHeatingArray : [],
                             
                             "fridges":fridgeArr.count > 0 ? fridgeArr : [],
                             "freezers":freezerArr.count > 0 ? freezerArr : []] as JSON
                
                SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/opening", keyDatabase: "opening_local", internetAvailabel: self.isInternetAvailable(), successSaved: { (text) in
                    self.showToast(message: text)
                    LoadingOverlay.shared.hideOverlayView()
                    
                })
            }
            
            
            if(f1 == foodArray.count && f2 == foodArray2.count && f3 == foodArray3.count  && a1 == frigdeArray.count  && a2 == freezerArray.count )
            {
                let alert = UIAlertController(title: "", message: "Do you want to do Appliance or Food checks before saving?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                   openingSave()
                }
                alert.addAction(cancelAction)

                super.present(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
                return
                
            }else
            {
                openingSave()
            }
            
            
            


            
    
    }else if (screenTitle?.equalsIgnoreCase(string: "Closing Check") ?? false) {
            
            
            var f1 = 0;
            var f2 = 0;
            var f3 = 0;
            
            var a1 = 0;
            var a2 = 0;
            
            var isDataMissing = false
            for i in 0..<foodArray.count{
                if(foodArray[i]["temp"].string == "" && foodArray[i]["comment"].string == "")
                {
                    f1 = f1 + 1;
                    isDataMissing = true
                    break
                }
            }
            
            for i in 0..<foodArray2.count{
                if(foodArray2[i]["temp"].string == "" && foodArray2[i]["comment"].string == "")
                {
                    f2 = f2 + 1;
                    isDataMissing = true
                    break
                }
            }
            for i in 0..<foodArray3.count{
                if(foodArray3[i]["temp"].string == "" && foodArray3[i]["comment"].string == "")
                {
                    f3 = f3 + 1;
                    isDataMissing = true
                    break
                }
            }
            
            for i in 0..<frigdeArray.count{
                if(frigdeArray[i]["temp"].string == "" && frigdeArray[i]["comment"].string == "")
                {
                    a1 = a1 + 1;
                    
                    isDataMissing = true
                    break
                }
            }
            for i in 0..<freezerArray.count{
                if(freezerArray[i]["temp"].string == "" && freezerArray[i]["comment"].string == "")
                {
                    a2 = a2 + 1;
                    
                    isDataMissing = true
                    break
                }
            }
            
            func closingSave(){
                
                
                let cookedArray = NSMutableArray()
                let reHeatingArray = NSMutableArray()
                let hotHoldingArray = NSMutableArray()
                
                
                for i in 0..<cookedNameArray.count {
                    //                let commentRequiredCooked = completeData?["entryDefaults"][0]["foods"][i]["cooked"].string ?? ""
                    let name = "\(cookedNameArray[i])"
                    let temp = foodArray[i]["temp"].string
                    let comment = foodArray[i]["comment"].string
                    cookedArray.add(["name":name,"type":"cooked","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                    
                }
                
                for i in 0..<hotHoldingNameArray.count {
                    //                let commentRequiredHotHold = completeData?["entryDefaults"][0]["foods"][i]["hotHolding"].string ?? ""
                    let name = "\(hotHoldingNameArray[i])"
                    let temp = foodArray2[i]["temp"].string
                    let comment = foodArray2[i]["comment"].string
                    hotHoldingArray.add(["name":name,"type":"hotHolding","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                    
                }
                
                for i in 0..<reheatingNameArray.count {
                    //                let commentRequiredReHeat = completeData?["entryDefaults"][0]["foods"][i]["reheating"].string ?? ""
                    let name = "\(reheatingNameArray[i])"
                    let temp = foodArray3[i]["temp"].string
                    let comment = foodArray3[i]["comment"].string
                    reHeatingArray.add(["name":name,"type":"reHeating","temperature":temp ?? "","commentRequired":false,"comment":comment ?? ""])
                }
                
                
                
                
                
                let fridgeArr = NSMutableArray()
                
                let assetsArrayarr1 = completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0
                for i in 0..<assetsArrayarr1 {
                    let temp = frigdeArray[i]["temp"].string ?? ""
                    let comment = frigdeArray[i]["comment"].string ?? ""
                    let commentrequired = (frigdeArray[i]["comment"].string?.characters.count ?? 0) > 0 ? true : false
                    fridgeArr.add(["fridgeNum":i + 1,"temperature":temp,"comment":comment,"commentRequired":commentrequired])
                }
                
                let freezerArr = NSMutableArray()
                
                let assetsArrayarr2 = completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0
                for i in 0..<assetsArrayarr2 {
                    let temp = freezerArray[i]["temp"].string ?? ""
                    let comment = freezerArray[i]["comment"].string ?? ""
                    let commentrequired = (freezerArray[i]["comment"].string?.characters.count ?? 0) > 0 ? true : false
                    freezerArr.add(["freezerNum":i + 1,"temperature":temp,"comment":comment,"commentRequired":commentrequired])
                }
                
                let array1 = NSMutableArray()
                let arr1 = self.completeData?["closing"][0]["items"].array?.count ?? 0
                for i in 0..<arr1 {
                    let openingData = self.completeData?["closing"][0]["items"][i]["description"].string ?? ""
                    array1.add(["description":openingData,"state":tab1Array[i] ])
                }
                
                
                
                let closingID = completeData?["closing"][0]["_id"].string ?? ""
                let templateName = completeData?["closing"][0]["name"].string ?? ""
                let type = completeData?["closing"][0]["type"].string ?? ""
                let param = ["template":["name":templateName],"_id":closingID,"entryTime":selectedDateMid,"type":type,
                             "items":array1,
                             "entryHrs":(hrs0mins1?[0]) ?? "",
                             "entryMins":(hrs0mins1?[1]) ?? "",
                             "locationId":locIDClosing,
                             "entryhrs":"null","entrymins":"null",
                             "cooking":cookedArray.count > 0 ? cookedArray : [],
                             "hotHolding":hotHoldingArray.count > 0 ? hotHoldingArray : [],
                             "reHeating":reHeatingArray.count > 0 ? reHeatingArray : [],
                             "fridges":fridgeArr.count > 0 ? fridgeArr : [],
                             "freezers":freezerArr.count > 0 ? freezerArr : []] as JSON
                
                SaveRequest.sharedInstance.saveRequest(param: param, apiName: "api/checks/closing", keyDatabase: "closing_local", internetAvailabel: isInternetAvailable(), successSaved: { (text) in
                    self.showToast(message: text)
                    LoadingOverlay.shared.hideOverlayView()
                    
                })
            }
            
            if(f1 == foodArray.count && f2 == foodArray2.count && f3 == foodArray3.count  && a1 == frigdeArray.count  && a2 == freezerArray.count )
            {
                let alert = UIAlertController(title: "", message: "Do you want to do Appliance or Food checks before saving?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                    closingSave()
                }
                alert.addAction(cancelAction)
                
                super.present(alert, animated: true, completion: nil)
                LoadingOverlay.shared.hideOverlayView()
                return
                
            }else
            {
                closingSave()
            }


    }
}
   
func textFieldDidBeginEditing(_ textField: UITextField) {
    if (textField.placeholder?.equalsIgnoreCase(string: "Invoice number") ?? false) {
        isInvoiceField = false
    }else
    {
        isInvoiceField = true
    }
    
}
func textFieldDidEndEditing(_ textField: UITextField) {
    if (textField.tag == 10) {
        invoiceSelected = textField.text ?? ""
    }
    
    if (textField.tag == 20) {
        commentSelected = textField.text ?? ""
    }
    
    if (textField.tag == 30) {
        tempSelected = textField.text ?? ""
    }
    
    if (screenTitle?.equalsIgnoreCase(string: "food")  ?? false) {
        
        let section = 0;
        
        let row = 0;
        
        let indexpath = NSIndexPath(row: row, section: section)
        let cell1 : AppliancesTableViewCell? = myTableView?.cellForRow(at: indexpath as IndexPath) as? AppliancesTableViewCell
        if(section == 1){
            foodArray[row] = ["temp":cell1?.enterTempTextField?.text ?? "", "comment":cell1?.enterCommentTextField?.text ?? ""]

        }else if(section == 2){
            foodArray2[row] = ["temp":cell1?.enterTempTextField?.text ?? "", "comment":cell1?.enterCommentTextField?.text ?? ""]

        }else if(section == 3)
        {
            foodArray3[row] = ["temp":cell1?.enterTempTextField?.text ?? "", "comment":cell1?.enterCommentTextField?.text ?? ""]

        }
        let temp = cell1?.enterTempTextField?.text ?? ""
        let comment = cell1?.enterCommentTextField?.text ?? ""
        if(section ==  1)
        {
            if(Int(temp) ?? 0 < minCookingTemp && comment == ""){
                let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be Above or equal to " + "\(minCookingTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                
                //self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                
            }
            self.dropDowntapped(index: row, section: section - 1)

            
        }else if(section == 2)
        {
            if(Int(temp) ?? 0 < hotHoldingTemp && comment == ""){
                let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be Above or equal to " + "\(hotHoldingTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                
                //self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                
            }
            self.dropDowntapped(index: row, section: section - 1)

            //            self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag)
        }else if(section == 3)
        {
            if(Int(temp ) ?? 0 < reHeatingTemp && comment == ""){
                let alert = UIAlertController(title: tempMessegaTitle, message: "Entered value should be Above or equal to " + "\(reHeatingTemp)" + "°" + ", else enter the comment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                super.present(alert, animated: true, completion: nil)
                
                //self.dropDowntapped(index: textField.tag, section: cell1?.dropDownButton?.tag ?? 0)
                
            }
            self.dropDowntapped(index: row, section: section - 1)

            
        }
    }
    
    if(screenTitle?.equalsIgnoreCase(string: "Appliances")  ?? false)
    {
        // pankaj
        self.setfridgeArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFridges"].int ?? 0 , isSelected: "NO")
        self.setfreezerArrayData(dataArray: completeData?["entryDefaults"][0]["numberOfFreezers"].int ?? 0 , isSelected: "NO")
    }
    
}

func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
}

}

