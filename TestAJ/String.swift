//
//  String.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 21/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
extension String{
    func equalsIgnoreCase(string:String) -> Bool{
        return self.uppercased() == string.uppercased()
    }
}
