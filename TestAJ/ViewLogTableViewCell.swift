//
//  ViewLogTableViewCell.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 29/07/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var namelabel: UILabel?
    @IBOutlet weak var templateLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var datelabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configutreCellData(viewLogData:JSON , index:Int)
    {
        namelabel?.text = "logged by " + (viewLogData[index]["createdByName"].string ?? "")
        templateLabel?.text = viewLogData[index]["type"].string
        let hour = viewLogData[index]["entryHrs"].int ?? 0
        let min = viewLogData[index]["entryMins"].int ?? 0
        var day = "AM"
        if(hour > 12 )
        {
            day = "PM"
        }
        let dateString = viewLogData[index]["entryTime"].string ?? ""
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from: dateString)
        inputFormatter.dateFormat = "dd MMMM"
        //        let resultString = inputFormatter.string(from: showDate ?? Date())
        
        timeLabel?.text = "\(hour)" + " : " + "\(min) " + day
        datelabel?.text = convertDateFormate(date: showDate ?? Date())
        
    }
    
    func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        //        dateFormate.dateFormat = "MMM, yyyy"
        dateFormate.dateFormat = "MMM"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
}
