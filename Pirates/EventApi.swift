//
//  FacebookApi.swift
//  Pirates
//
//  Created by Issam Zeibak on 12/12/15.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//
// 

/* Notes on Venue name
 * I found an easier way to parse the data, but there are a few rules:
 *
 * The end of the description should look like this:
 * venueName:What the Dickens
 * coordinates:35.647663,139.707963 B
 *
 * 1. venueName: should be before coordinates if it's there. there should be a new line (like the above) after the venue name.
 * 2. coordinates: should be on the last line of the description
 *3. The banner character, if it's there, should always be the last character of the description.
 */


import Foundation
import Alamofire

let eventURL:String = "https://hidden-sierra-5223.herokuapp.com/"

class EventApi {
    
    var improvEvents = [ImprovEvent]()

    let eWeekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let eMonths = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    func getEvents(completionHandler: ([ImprovEvent]?, NSError?) -> ()) -> () {
        
        Alamofire.request(.GET, eventURL).responseJSON() { response in

            switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    self.getEventsFromJSON(json)
                    completionHandler(self.improvEvents, response.result.error)
                
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(self.improvEvents, error)
            }
        }
    }

    func isEventEarlierThanToday(eventDate:String) -> Bool {
        let start_datetime = DateAndTimeFormatter().getNSDate(eventDate)
        let current_date = NSDate()
        if  start_datetime.earlierDate(current_date) == start_datetime {
            return true
        }
        return false
    }
    
    func getEventsFromJSON(json:JSON) {
        for (_, result) in json["data"] {

            // Don't add to events to display if the event already happened
            let event_start_date_str = result["start_time"].string!
            if isEventEarlierThanToday(event_start_date_str) {
                continue
            }
            
            // The description of the venue
            let description = result["description"].string!
            let titleChar = description.characters.last!
            let title = getTitle(description)
            
            let city = result["venue"]["city"] != nil ? result["venue"]["city"].stringValue : ""
            let country = result["venue"]["country"] != nil ? result["venue"]["country"].stringValue : ""
            let state = result["venue"]["state"] != nil ? result["venue"]["state"].stringValue : ""
            let street = result["venue"]["street"] != nil ? result["venue"]["street"].stringValue : ""
            let zip = result["venue"]["zip"] != nil ? result["venue"]["zip"].stringValue : ""
            
            
            // TODO fix lattitude and longitude to location to be grabbed from API
            let (lat, lng) = getLatitudeAndLongitudeFromDescription(description,
                                                                    apiLat: result["venue"]["latitude"].doubleValue,
                                                                    apiLng: result["venue"]["longitude"].doubleValue)
            let venueNameKey = result["location"] ? result["location"].string! : ""
            let venueLocation = getVenueLocation(description, venueName: venueNameKey)
            
            let modifiedDescription = getModifiedDescription(description)
            
            self.improvEvents.append(
                ImprovEvent(name: venueLocation,
                    start_time: event_start_date_str,
                    location: venueLocation,
                    description: modifiedDescription!,
                    venue : ImprovEvent.Venue(
                        city: city,
                        country: country,
                        state: state,
                        street: street,
                        zip: zip,
                        latitude: lat,
                        longitude: lng
                    ),
                    eventStyle: self.getEventStyle(titleChar, title: title!)))
        }
    }

    /*
     * So find the string between:
     * 1. The newline
     * 2. The "venue:" string
     *
     */
    func getVenueLocation(desc:String, venueName:String) -> (String!){
        let regexString = "(?<=venueName:)(.*)(?=\\n)"
            let result = getResultFromRegex(desc, regex: regexString)
            if result != nil {
                return result
            }

        return venueName
    }
    
    func getModifiedDescription(desc:String) -> (String?){
        let delimiter = "\n- - -"
        return desc.componentsSeparatedByString(delimiter)[0]
    }
    
    
    func getTitle(desc:String) -> (String?){
        let regexString = "(?<=title:)(.*)(?=\\n)"
        let result = getResultFromRegex(desc, regex: regexString)
        if result != nil {
            return result.stringByReplacingOccurrencesOfString("\\", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        return ""
    }
    
    /*
     * Fetch the longitude and latitude from the description, since the API ones are invalid
     * The description ends e.g. "ishi, Shibuya, Tokyo 150-0021 - - - coordinates:35.647663,139.707963 B"
     * 
     * So find the string between:
     * 1. The space
     * 2. The "coordinates:" string
     *
     */
    func getLatitudeAndLongitudeFromDescription(desc:String, apiLat:Double, apiLng:Double) -> (lat:Double, lng: Double){
        let regexString = "(?<=coordinates:)(.*)(?= )"
        let result = getResultFromRegex(desc, regex: regexString)
        if result != nil {
            let coords = result.componentsSeparatedByString(",")
            let resultLat = coords[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let resultLng = coords[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            return (Double(resultLat)!, Double(resultLng)!)
        }
        return (apiLat, apiLng)
    }
    
    
    func getResultFromRegex(desc:String, regex:String) -> (String!){
        if let range = desc.rangeOfString(regex, options:.RegularExpressionSearch) {
            return desc.substringWithRange(range)
        }
        return nil
    }
    
    
    
    
    func getEventStyle(showType: Character, title: String) -> ImprovEvent.EventStyle {
        var modifiedTitle = title

        switch showType {
        case Character("B"):
            if modifiedTitle == "" {
                modifiedTitle = "Bilingual Improv Show\n英語と日本即興コメディー"
            }
            return ImprovEvent.EventStyle(title: modifiedTitle,
                banner: "BilingualFlag",
                textColor: "#E44C42",
                lineStyle: "#E44C42")
        case Character("E"):
            if modifiedTitle == "" {
                modifiedTitle = "English comedy show\n英語即興コメディー"
            }
            return ImprovEvent.EventStyle(title: modifiedTitle,
                banner: "EnglishFlag",
                textColor: "#5BC9ED",
                lineStyle: "#57C9ED")
            
        case Character("J"):
            if modifiedTitle == "" {
                modifiedTitle = "Japanese comedy show\n日本の即興コメディ"
            }
            return ImprovEvent.EventStyle(title: modifiedTitle,
                banner: "JapaneseFlag",
                textColor: "#FFFFFF",
                lineStyle: "#FFFFFF")
            
        case Character("O"):
            return ImprovEvent.EventStyle(title: modifiedTitle,
                banner: "SpecialFlag",
                textColor: "#67C3A2",
                lineStyle: "#67C3A2")
            
        default:
            return ImprovEvent.EventStyle(title: modifiedTitle,
                banner: "SpecialFlag",
                textColor: "#FFFFFF",
                lineStyle: "#FFFFFF")
        }
    }
}


class ImprovEvent {

    init(name: String, start_time: String, location: String, description: String, venue: ImprovEvent.Venue, eventStyle: ImprovEvent.EventStyle){
        self.name = name
        self.start_time = start_time
        self.location = location
        self.description = description
        self.venue = venue
        self.eventStyle = eventStyle
        
    }
    
    var name: String
    var start_time: String//NSDate()
    var location: String
    var description: String
    var venue: Venue
    var eventStyle: EventStyle
    
    struct EventStyle {
        var title: String // = English Improv Show
        var banner: String // E icon background banner
        var textColor: String // Blue Hex #3598D4
        var lineStyle: String //#57C9ED (50% opacity)
    }
    
    struct Venue {
        var city: String
        var country: String
        var state: String
        var street: String
        var zip: String
        var latitude: Double
        var longitude: Double
    }
    
    struct pageCursor {
        var before = ""
        var after = ""
    }
    
    struct paging {
        var cursors = {} // PageCursor
        var next = ""
    }
}
