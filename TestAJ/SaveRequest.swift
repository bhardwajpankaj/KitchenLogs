//
//  SaveRequest.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 01/08/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class SaveRequest: NSObject {
    
    
    static let sharedInstance = SaveRequest()
    
    
    func saveRequest(param : JSON, apiName : String, keyDatabase : String ,internetAvailabel: Bool, successSaved:@escaping (String) -> Void){
        
            ItsRequest.sharedInstance.requestPOSTURL(apiName, "", params: param.dictionaryObject as [String : AnyObject]?, head: nil, success: { (json) in
                
                if let code = json["code"].int
                {
                    if(code == 200)
                    {
                        successSaved(json["message"].string ?? "")
                    }else
                    {
                        successSaved(json["message"].string ?? "API Error")
                    }
                }else{
                    successSaved("Cheers Log Saved")
                }
            }, failure: { (error) in
                LoadingOverlay.shared.hideOverlayView()
                
            })
    }
    
}
