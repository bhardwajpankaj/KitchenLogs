//
//  LoginVC.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 27/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SwiftyJSON
import ObjectMapper
import UserNotifications
//import RealmSwift


class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var passwordField: UITextField?
    @IBOutlet weak var loginButton: UIButton?

    @IBOutlet weak var bottomview: UIView?

    override func viewDidAppear(_ animated: Bool) {
        let JWTtoken : String = UserDefaults.standard.value(forKey: "jwt_auth_token") as? String ?? ""
        if(JWTtoken.characters.count > 1)
        {
            gotViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let JWTToken : String? = (UserDefaults.standard.value(forKey: myDeviceTokenKey) as? String ?? "") ?? "simulator"

        let myDictOfDict:Dictionary<String, Any> = ["email": emailField?.text,"password":passwordField?.text, "token": JWTToken]
        //        let myDictOfDict:Dictionary<String, Any> = ["email": "abhivendra@kitchenlogs.com","password":"Abhi123456", "token": JWTToken]
        createJWTToken(dict: myDictOfDict)
        emailField?.attributedPlaceholder = NSAttributedString(string: "Email/Username",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordField?.attributedPlaceholder = NSAttributedString(string: "Your Password",
                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailField?.delegate = self
        passwordField?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let email = UserDefaults.standard.value(forKey: "email"){
            emailField?.text = email as? String

        }
        if let password = UserDefaults.standard.value(forKey: "password"){
            passwordField?.text = password as? String

        }
        
       

        
//        var frame = bottomview?.frame
//        frame?.size.height = 0;
//        bottomview?.frame = frame ?? CGRect()
//        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.view.layoutIfNeeded()
            self.loginViewTopConstraint.constant = screenSize.height

            UIView.animate(withDuration: 0.5, animations: {
//                self.bottomview?.frame = CGRect(x: (self.bottomview?.frame.origin.x)!, y: (self.bottomview?.frame.origin.y)!, width: (self.bottomview?.frame.size.width)!, height: 270)
                self.view.layoutIfNeeded()
            })

        }
        
        
        
    }
    
    @IBAction func showLoginView(_ sender: UIButton) {
        view.layoutIfNeeded()
        loginViewTopConstraint.constant = screenSize.height
        sender.isHidden = true

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        gotViewController()
        return
        let password : String = (passwordField?.text?.trimmingCharacters(in: .whitespaces)) ?? ""

//        if ((password.characters.count) <= 3) {
//            let alert = UIAlertController(title: "Wrong Credentials", message: "Password must be 4 characters long", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }else
//        {
//            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//            
//            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//            if(emailTest.evaluate(with: emailField?.text))
//            {
                let JWTToken = UserDefaults.standard.value(forKey: myDeviceTokenKey)
                let myDictOfDict:Dictionary<String, Any> = ["email": emailField?.text ?? "","password":passwordField?.text ?? "", "token": JWTToken ?? "simulator"]
                UserDefaults.standard.setValue(emailField?.text ?? "", forKey: "email")
                UserDefaults.standard.setValue(password, forKey: "password")
                print("Password",password)
                createJWTToken(dict: myDictOfDict)
//            }else
//            {
//                let alert = UIAlertController(title: "Wrong Credentials", message: "Entered email Id is invalid", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                
//            }
//        }
    }
    
    func createJWTToken(dict:Dictionary<String, Any>){
        LoadingOverlay.shared.showOverlay(view:self.view, msg: "")
        ItsRequest.sharedInstance.requestPOSTURL("auth/login", "", params: dict as [String : AnyObject]?, head: nil, success: { (json) in
            // success code
            
            if let jWTToken = json["data"][0]["token"].string {
                //Now you got your value
                print(jWTToken)
                UserDefaults.standard.setValue(jWTToken, forKey: "jwt_auth_token")
                LoadingOverlay.shared.hideOverlayView()
                ItsRequest.sharedInstance.saveJSON(j: json["data"][0]["user"], key: "userData")
                
                self.gotViewController()
                
            }
            
            print(json)
            if let code = json["code"].int{
                if(code == 400){
                    let alert = UIAlertController(title: "Incorrect password", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                alert.addAction(UIAlertAction(title: "Forgot Password", style: UIAlertActionStyle.default, handler: self.doSomething))
                    
                                self.present(alert, animated: true, completion: nil)
                    LoadingOverlay.shared.hideOverlayView()

                }
            }else{
            
            
            }
        }, failure: { (error) in
            //error code
            LoadingOverlay.shared.hideOverlayView()
//            super.showToast(message: "Internal Server Error")
            print(error)
        })
    }
    
    func doSomething(action: UIAlertAction) {
        //Use action.title
        let dict:Dictionary<String, Any> = ["email": emailField?.text ?? ""]
        ItsRequest.sharedInstance.requestPOSTURL("api/forgot-password", "", params: dict as [String : AnyObject], head: nil, success: { (json) in
            let alert = UIAlertController(title: "Mail Sent", message: "If this email exists in our system, we will send you new password via email.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }) { (error) in
            
        }
    }
    


//    func sendMail(action: UIAlertAction) {
//    {
//        let dict:Dictionary<String, Any> = ["email": emailField?.text ?? ""]
//        ItsRequest.sharedInstance.requestPOSTURL("/api/forgot-password", "", params: dict, head: nil, success: { (json) in
//            let alert = UIAlertController(title: "Mail Sent", message: "If this email exists in our system, we will send you new password via email.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }) { (eroor) in
//            
//        }
//        }
//    }
    func gotViewController()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController: ViewController? = storyBoard.instantiateViewController(withIdentifier: "addNewLog") as? ViewController
        self.present(nextViewController ?? UIViewController(), animated:true, completion:nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           // if self.view.frame.origin.y != 0{
             //   self.view.frame.origin.y += keyboardSize.height
            //}
            self.view.frame.origin.y = 0

            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
