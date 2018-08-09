//
//  WebPageViewController.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 28/07/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import ObjectMapper
import UserNotifications
//import RealmSwift


class WebPageViewController: UIViewController,UITextFieldDelegate,UIWebViewDelegate {
    
    @IBOutlet weak var loginViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var backButton: UIButton?
    
    var boxView: UIView?

    var webURL : String?
    @IBOutlet weak var webView: UIWebView?
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Box config:
        
        boxView = UIView(frame: CGRect(x: screenSize.width/2 - 40, y: screenSize.height/2 - 40, width: 80, height: 80))
        
        boxView?.backgroundColor = UIColor.black
        boxView?.alpha = 0.9
        boxView?.layer.cornerRadius = 10
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
        activityView.startAnimating()
        
        // Text config:
        let textLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 30))
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 13)
        textLabel.text = "Loading..."
        
        // Activate:
        boxView?.addSubview(activityView)
        boxView?.addSubview(textLabel)
        self.view?.addSubview(boxView!)

        titleLabel?.text = self.title
        webView?.delegate = self
        if let url = URL(string: webURL ?? "https://www.kitchenlo.gs/") {
            let request = URLRequest(url: url)
            webView?.loadRequest(request)
        }
    }
   
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        boxView?.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        boxView?.isHidden = true
 
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func gotViewController()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController: ViewController? = storyBoard.instantiateViewController(withIdentifier: "addNewLog") as? ViewController
        self.present(nextViewController ?? UIViewController(), animated:true, completion:nil)
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
