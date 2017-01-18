//
//  ProgramsApi.swift
//  Pirates
//
//  Created by Issam Zeibak on 1/2/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation
import Alamofire

let programsURL:String = "http://www.piratesoftokyobay.tech/"

public class ProgramsApi {
    var performers = [Performer]()
    var games = [Game]()
    var news = [News]()
    
    let getPerformers:String = "getperformers"
    let getGames:String = "getgames"
    let getNews:String = "getnews"
    let getProgramDate:String = "getprogramdate"
    let dateAndTimeFormatter = DateAndTimeFormatter()
    
    
    func getPerformers(completionHandler: ([Performer]?, NSError?) -> ()) -> () {
        
        Alamofire.request(.GET, programsURL+getPerformers).responseJSON() { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                self.getPerformersFromJSON(json)
                completionHandler(self.performers, response.result.error)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                completionHandler(self.performers, error)
            }
        }
    }
    
    func getPerformersFromJSON(json:JSON) {
        for (_, result) in json["data"] {
            self.performers.append(
                Performer(
                    english_name: result["english_name"].string!,
                    japanese_name: result["japanese_name"].string!
                )
            )
        }
    }

    func getGames(completionHandler: ([Game]?, NSError?) -> ()) -> () {
        Alamofire.request(.GET, programsURL+getGames).responseJSON() { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                self.getGamesFromJSON(json)
                completionHandler(self.games, response.result.error)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                completionHandler(self.games, error)
            }
        }
    }
    
    func getGamesFromJSON(json:JSON) {
        for (_, result) in json["data"] {
            self.games.append(
                Game(
                    english_name: result["English_name"].string!,
                    japanese_name: result["Japanese_name"].string!,
                    english_description: result["English_description"].string!,
                    japanese_description: result["Japanese_description"].string!
                )
                
            )
        }
    }

    func getNews(completionHandler: ([News]?, NSError?) -> ()) -> () {
        Alamofire.request(.GET, programsURL+getNews).responseJSON() { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                self.getNewsFromJSON(json)
                completionHandler(self.news, response.result.error)

            case .Failure(let error):
                print("Request failed with error: \(error)")
                completionHandler(self.news, error)
            }
        }
    }
    
    func getNewsFromJSON(json:JSON) {
        for (_, result) in json["data"] {
            self.news.append(
                News(name: result["Name"].string!,
                    description: result["Description"].string!))
        }
    }
    
    func getProgramDate(completionHandler: (String, NSError?) -> ()) -> () {
        
        Alamofire.request(.GET, programsURL+getProgramDate).responseJSON() { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let programDate = self.getProgramDateFromJSON(json)
                completionHandler(programDate, response.result.error)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                completionHandler("N/A", error)
            }
        }
    }
    
    func getProgramDateFromJSON(json:JSON) -> String {
        let result = json["data"]
        if let programDateString = result["ProgramDate"].string {
            return dateAndTimeFormatter.getEnglishDate(programDateString)  + " " + dateAndTimeFormatter.getEnglishTime(programDateString) + " • " +
                   dateAndTimeFormatter.getJapaneseDate(programDateString) + " " + dateAndTimeFormatter.getJapaneseTime(programDateString)
        }
        return "Date not available / 利用できない日"
    }

}


class Performer {
    init(english_name: String, japanese_name: String){
        self.english_name = english_name
        self.japanese_name = japanese_name
    }
    
    var english_name: String
    var japanese_name: String
}


class Game {
    init(english_name: String, japanese_name: String, english_description: String, japanese_description: String){
        self.english_name = english_name
        self.japanese_name = japanese_name
        self.english_description = english_description
        self.japanese_description = japanese_description
    }
    
    var english_name: String
    var japanese_name: String
    var english_description: String
    var japanese_description: String
}


class News {
    init(){
        self.name = ""
        self.description = ""
    }
    
    init(name: String, description: String){
        self.name = name
        self.description = description
    }
    
    var name: String
    var description: String
}
