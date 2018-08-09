//
//  ItsRequest.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 22/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class ItsRequest: NSObject {
    
     let baseURL = "https://api.kitchenlogs.com/"
//    let baseURL = "https://dev.kitchenlogs.com/"
//    let baseURL = "https://apidev.kitchenlogs.com/"
    
    
    
    static let sharedInstance = ItsRequest()
    
    
    
    func requestGETURL(_ strURL: String,_ strToken : String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
    {
        let JWTToken:String? = UserDefaults.standard.value(forKey: "jwt_auth_token") as? String ?? ""

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (JWTToken ?? ""),
            "Accept": "application/json"
        ]
        Alamofire.request(baseURL + strURL , headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value ?? "")
                //let title = resJson["title"].string
                print("resJson",resJson)
                success(resJson)
            }
            
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    func requestPOSTURL(_ strURL : String,_ strToken : String, params : [String : AnyObject]?, head : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let JWTToken :String? = UserDefaults.standard.value(forKey: "jwt_auth_token") as? String ?? ""
        var headersus: HTTPHeaders = [:]
        if (strToken == "") {
            headersus = [
                "Authorization": "Bearer " + (JWTToken ?? ""),
                "Accept": "application/json"
            ]
        }
       
        Alamofire.request(baseURL + strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headersus).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value ?? "")
                print("success : ",resJson)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print("error : ",error)
                failure(error)
            }
        }
    }
    
    public func saveJSON(j: JSON, key :String) {
        let defaults = UserDefaults.standard
        defaults.setValue(j.rawString() ?? "", forKey: key)
        // here I save my JSON as a string
    }
    
    public func deleteJSON(key :String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        // here I delete my JSON
    }
    
    public func loadJSON(key :String) -> JSON {
        let defaults = UserDefaults.standard
        return JSON.parse(defaults.value(forKey:key) as? String ?? "")
        // JSON from string must be initialized using .parse()
    }

}

