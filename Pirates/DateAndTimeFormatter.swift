//
//  DateAndTimeFormatter.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 9/12/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation

class DateAndTimeFormatter {
    
    let formatter = NSDateFormatter()

    func getNSDate(stringDate: String) -> NSDate {
        self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard (self.formatter.dateFromString(stringDate) != nil) else {
            return NSDate()
        }
        
        return self.formatter.dateFromString(stringDate)!
    }

    /*
    * 2016-09-05T19:00:00+0900 -> 9月 05日 (土)
    */
    func getJapaneseDate(jDateString: String) -> String {
        let jDate = getNSDate(jDateString)
        let jWeekDays = ["Sun":"日", "Mon":"月", "Tue":"火", "Wed":"水",
            "Thu":"木", "Fri":"金", "Sat":"土"]
        self.formatter.dateFormat = "EEE"
        
        if let jday = jWeekDays[formatter.stringFromDate(jDate)] {
            self.formatter.dateFormat = String(format: "M月d日 (%@)", jday)
            return self.formatter.stringFromDate(jDate)
        }
        return ""
    }
    
    /*
    * 2016-09-05T19:00:00+0900 -> 午後7:00
    */
    func getJapaneseTime(jDateString: String) -> String {
        let jDate = getNSDate(jDateString)
        let jTimeOfDay = ["AM":"午前", "PM":"午後"]
        self.formatter.dateFormat = "a"
        
        if let timeOfDay = jTimeOfDay[self.formatter.stringFromDate(jDate)] {
            self.formatter.dateFormat = String(format: "%@h:mm", timeOfDay)
            return self.formatter.stringFromDate(jDate)
        }
        return ""
    }
    
    /*
    * 2016-09-05T19:00:00+0900 -> Sep 05 (Mon)
    */
    func getEnglishDate(eDateString: String) -> String {
        let eDate = getNSDate(eDateString)
        self.formatter.dateFormat = "MMM d (EEE)"
        return self.formatter.stringFromDate(eDate)
    }
    
    /*
    * 2016-09-05T19:00:00+0900 -> 7:00pm
    */
    func getEnglishTime(eDateString: String) -> String {
        let eDate = getNSDate(eDateString)
        self.formatter.dateFormat = "h:mma"
        let eTime = self.formatter.stringFromDate(eDate)
        return eTime.lowercaseString
    }

    
}
