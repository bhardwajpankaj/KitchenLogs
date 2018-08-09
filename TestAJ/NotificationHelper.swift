//
//  NotificationHelper.swift
//  KitchenLogs
//
//  Created by Utsav Nagar on 29/07/17.
//  Copyright © 2017 iossolutions.xcode. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftyJSON

class NotificationHelper{
    var weekDay=[
        "Monday":2,
        "Tuesday":3,
        "Wednesday":4,
        "Thursday":5,
        "Friday":6,
        "Saturday":7,
        "Sunday":1
    ]
    
    init() {
    }
    
    var notificationArray  = [JSON]()
    
    func getNotificationConfigs(sucess: (@escaping (String) -> ())){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        ItsRequest.sharedInstance.requestGETURL("api/users/schedule", "", success: { (json) in
            if (json["data"].count != 0) {
                ItsRequest.sharedInstance.saveJSON(j: json["data"], key: "notification_config");
            }
            self.scheduleNotifications()
            var str = ""
            for not in self.notificationArray{
                
                str = str + (not["type"].string ?? "") + (not["dateComponents"].string ?? "") + "\n"
                
            }
            sucess(str)
        }) { (error) in
            print(error);
        }

    }
    
    func scheduleNotifications()
    {
        let config = ItsRequest.sharedInstance.loadJSON(key: "notification_config");
        self.scheduleOpeningChecks(config: config)

        self.scheduleClosingChecks(config: config)

        self.scheduleCleaningCheck(config: config)
        
    }
    

    func scheduleOpeningChecks(config:JSON){
        let openingCheckObj=config["checks"][0];
        let min = openingCheckObj["notificationMin"]["value"].intValue
        self.schedule(type: "OpeningCheck",timings: config["timings"],min: min)
    }
    
    func scheduleClosingChecks(config:JSON){
        let closingCheckObj=config["checks"][1];
        let min = closingCheckObj["notificationMin"]["value"].intValue
        self.schedule(type: "ClosingCheck",timings: config["timings"],min: min)
    
    }
    
    func scheduleCleaningCheck(config:JSON){
        let cleaningCheckObj=config["checks"][2];
        let min = cleaningCheckObj["notificationMin"]["value"].intValue
        let hour=cleaningCheckObj["notificationHr"]["value"].intValue
        let notFreqHour=cleaningCheckObj["notificatioFreqHr"].intValue
        let notCount=cleaningCheckObj["notifcationCount"].intValue
        for day in config["timings"].arrayValue{
            let isClosed = day["isClosed"];
            let weekDay = self.weekDay[day["day"].stringValue];
            let count = notCount
        
            if !isClosed.boolValue {
                if(count == 0){
                    var dateComponents = DateComponents()
                    dateComponents.timeZone = NSTimeZone.local
                    dateComponents.weekday = weekDay
                    dateComponents.hour = hour;
                    dateComponents.minute = min;
                    
                    let hhh = "hour :" + "\(hour)" + "  min :" + "\(min)" + "  weekDay :" + "\(weekDay)"
                    self.createNotification(type: "Cleaning Check", dateComponents: dateComponents, weekDay: weekDay!)
                    var dict = [] as JSON
                    dict = ["type": "Cleaning Check - ", "dateComponents": hhh]
                    notificationArray.append(dict)
                }else{
                for i in 0..<count{
                    var dateComponents = DateComponents()
                    dateComponents.timeZone = NSTimeZone.local
                    dateComponents.weekday = weekDay
                    dateComponents.hour = hour + (i * notFreqHour);
                    dateComponents.minute = min;
                    
                    let hhh = "hour :" + "\(hour + (i * notFreqHour))" + "  min :" + "\(min)" + "  weekDay :" + "\(weekDay)"
                    self.createNotification(type: "Cleaning Check", dateComponents: dateComponents, weekDay: weekDay!)
                    var dict = [] as JSON
                    dict = ["type": "Cleaning Check - ", "dateComponents": hhh]
                    notificationArray.append(dict)
                }
                }

            }

            
        }
    }
    
    
    func schedule(type:String,timings:JSON,min:Int){
        for day in timings.arrayValue{
            let isClosed=day["isClosed"];
            let weekDay=self.weekDay[day["day"].stringValue];
            var dateComponents = DateComponents()
            dateComponents.timeZone = NSTimeZone.local
            dateComponents.weekday = weekDay
            if !isClosed.boolValue {
                if("OpeningCheck".equalsIgnoreCase(string:type )){
                    
                    let timeInMin = (((day["openingHrs"].intValue * 60) + day["openingMins"].intValue) - min)
                    
                    let hourTime = timeInMin / 60
                    let minTime = timeInMin % 60
                    let hour = String(hourTime).characters.split{$0 == "."}.map(String.init)
                    let horReal = hour[0]
                    dateComponents.hour = Int(horReal);
                    dateComponents.minute = minTime

                    self.createNotification(type: "Opening Check", dateComponents: dateComponents, weekDay: weekDay!)
                    var dict = [] as JSON
                    let hhh = "hour :" + "\(Int(horReal))" + "  min :" + "\(minTime)" + "  weekDay :" + "\(weekDay)"

                    dict = ["type": "Opening Check - ", "dateComponents": hhh]
                    notificationArray.append(dict)
                }else if("ClosingCheck".equalsIgnoreCase(string: type)){
                    
                    let timeInMin = (((day["closingHrs"].intValue * 60) + day["closingMins"].intValue) + min)

                    let hourTime = timeInMin / 60
                    let minTime = timeInMin % 60
                    let hour = String(hourTime).characters.split{$0 == "."}.map(String.init)
                    let horReal = hour[0]
                    
                    dateComponents.hour = Int(horReal)
                    dateComponents.minute = minTime;

                    self.createNotification(type: "Closing Check", dateComponents: dateComponents, weekDay: weekDay!)
                    
                    let hhh = "hour :" + "\(day["closingHrs"].intValue)" + "  min :" + "\(day["closingMins"].intValue + min)" + "  weekDay :" + "\(weekDay)"

                    var dict = [] as JSON
                    dict = ["type": "Closing Check - ", "dateComponents": hhh]
                    notificationArray.append(dict)
                }
                
            }
        }
    
        
    }
    
    
    public func createNotification(type:String,dateComponents: DateComponents, weekDay: Int) {
        
        let uniqueId = NSUUID().uuidString
        
        var dict = [] as JSON
        dict = ["type": "uniqueId - ", "dateComponents": uniqueId]
        notificationArray.append(dict)
        
        let myAlarmTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        print("Notification Added" + type + "\(dateComponents)" + uniqueId)

        
        let content=UNMutableNotificationContent();
        content.title = type
        content.body = "Log "+type
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: uniqueId, content: content, trigger: myAlarmTrigger)
    
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                //TODO: Handle the error
                dict = ["type": "Error - ", "dateComponents": "\(error)"]
                self.notificationArray.append(dict)

            }
        })
    }
}
