//
//  BaseViewController.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 05/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import ObjectMapper
import UserNotifications

import Foundation
import SystemConfiguration

//import RealmSwift

//protocol BaseViewControllerDelegate{
//    func tokenReceived()
//}
class BaseViewController: UIViewController,LeftViewControllerDelegate {
    
    
    
    
    var leftVC :LeftViewController?
    let screenSize: CGRect = UIScreen.main.bounds
    let sideView = UIView()
    var menuBGView:UIButton?
    //    var delegate : BaseViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftViewController") as? LeftViewController
//        self.LocalNotification()
        let JWTtoken : String = UserDefaults.standard.value(forKey: "jwt_auth_token") as? String ?? ""
        print(JWTtoken)
        
        if (JWTtoken != "") {
//            self.getSideMenu(str: JWTtoken)
            
        }
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(doSomethingAfterNotified),
//                                               name: NSNotification.Name(rawValue: myDeviceTokenKey),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(rotated),
//                                               name: NSNotification.Name(rawValue: orientationNotificationKey),
//                                               object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        menuBGView = UIButton()
        menuBGView?.frame = CGRect(x: 100, y: 0, width: screenSize.width, height: screenSize.height)
        menuBGView?.backgroundColor = UIColor.black
        menuBGView?.addTarget(self, action: #selector(hideSideMenu), for: UIControlEvents.touchUpInside)
        menuBGView?.alpha = 0
        leftVC?.leftViewControllerDelegate = self
        sideView.frame = CGRect(x: 0, y: 0, width: 0, height: screenSize.height)
        sideView.clipsToBounds = true
        self.view.addSubview(sideView)
        sideView.addSubview(leftVC?.view ?? UIView())
        
        
        
    }
    
    func loadViewLogData(dict:Dictionary<String, Any>, sucess: (@escaping (Bool) -> ()))
    {
        ItsRequest.sharedInstance.requestPOSTURL("api/entries/all", "", params: dict as [String : AnyObject]?, head: nil, success: { (json) in

            if (json["data"].count > 0) {
                //Now you got your value
                ItsRequest.sharedInstance.saveJSON(j: json["data"], key: "view_log")
                sucess(true)
                return
            }
            sucess(false)
        }, failure: { (error) in
            //error code
            sucess(false)
            print(error)
        })
    }
    
    func doSomethingAfterNotified() {
        
        print("I've been notified")
        
        let JWTToken = "\(UserDefaults.standard.value(forKey: myDeviceTokenKey)!)"
        let myDictOfDict:Dictionary<String, Any> = ["email": "ipvaid@gmail.com","password":"Kitchen@2017", "token": JWTToken]
//        let myDictOfDict:Dictionary<String, Any> = ["email": "abhivendra@kitchenlogs.com","password":"Abhi123456", "token": JWTToken]
        
        
        createJWTToken(dict: myDictOfDict)
        
    }
    func createJWTToken(dict:Dictionary<String, Any>){
        ItsRequest.sharedInstance.requestPOSTURL("auth/login", "", params: dict as [String : AnyObject]?, head: nil, success: { (json) in
            // success code
            print(json)
            if let jWTToken = json["data"][0]["token"].string {
                //Now you got your value
                print(jWTToken)
                UserDefaults.standard.setValue(jWTToken, forKey: "jwt_auth_token")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: myToken), object: self)
                
                //                self.getSideMenu(str:jWTToken)
                //                self.delegate?.tokenReceived()
                
            }
        }, failure: { (error) in
            //error code
            print(error)
        })
    }
    
    func getSideMenu(str:String){
        //        var newsItems:[SideMenuData] = []
        
        ItsRequest.sharedInstance.requestGETURL("api/settings/sidemenu", str, success: { (json) in
            if let sideMenuDataArray = json["data"].array {
                //Now you got your value
                print(sideMenuDataArray)
                //                for sideMenuData in sideMenuDataArray {
                //                    let newsJson = SideMenuData()
                //                    newsJson.icon = sideMenuData["icon"].string ?? ""
                //                    newsJson.label = sideMenuData["label"].string ?? ""
                //                    newsJson.objectId = sideMenuData["_id"].string ?? ""
                //                    newsJson.menuId = sideMenuData["menuId"].string ?? ""
                //                    newsJson.isDefault = sideMenuData["isDefault"].bool  ?? false
                //                    newsItems.append(newsJson)
                //                }
                //                print(newsItems)
                
                ItsRequest.sharedInstance.saveJSON(j: json["data"], key: "sideMenuData")
                
                //                do {
                //                    let realm = try Realm()
                //                    let abc = realm.objects(SideMenuData.self)
                //
                //                    print(abc)
                //                    self.insertOrUpdate(menuData: newsItems)
                //                    // ...
                //
                //                } catch _ {
                //                    // ...
                //                }
                
            }
            
        }) { (error) in
            
        }
        //        print(newsItems)
        
    }
    //
    //    func insertOrUpdate(menuData: [SideMenuData]) {
    //        let realm = try! Realm()
    //        try! realm.write({
    //            realm.add(menuData)
    //        })
    //    }
    
    func hideSideMenu() -> Void {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () -> Void in
                        self.sideView.frame.size.width = 0
                        self.menuBGView?.alpha = 0
                        
        }, completion: { (finished) -> Void in
        })
    }
    @IBAction func openSideMenu(_ sender: Any) {
        //        do {
        //            let realm = try Realm()
        //            let abc = realm.objects(SideMenuData.self)
        //
        //            let objs = realm.objects(SideMenuData)
        //            // ...
        //
        //        } catch _ {
        //            // ...
        //        }
        self.view.insertSubview(self.menuBGView ?? UIView(), belowSubview: self.sideView)
        menuBGView?.alpha = 0;
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: UIViewAnimationOptions.allowAnimatedContent,
                       animations: { () -> Void in
                        self.sideView.frame.size.width = self.screenSize.width - 77
                        self.menuBGView?.alpha = 0.5
                        
        }, completion: { (finished) -> Void in
        })
    }
    
    private func LocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Opening Check", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Log today's Opening Check!", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber;
        content.categoryIdentifier = "com.elonchan.localNotification"
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60.0, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    func addLoader()
    {
        var overlay : UIView? // This should be a class variable
        
        overlay = UIView(frame: self.view.frame)
        overlay!.backgroundColor = UIColor.black
        overlay!.alpha = 0.8
        
        view.addSubview(overlay!)
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func cellDidSelectWithIndexAndtitle(index: NSInteger, title: String) {
        
    }
    
    func timeAndDateDidTap() {
        
    }
    @IBAction func displayHomeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
//    func rotated() {
//        
//        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: screenSize.width - 40, height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Regular", size: 10.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 30;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

}
