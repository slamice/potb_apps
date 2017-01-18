//
//  VotingApi.swift
//  Pirates
//
//  Created by Issam Zeibak on 11/14/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import Foundation

class VotingApi {

    let pirates_url:String = "http://www.piratesoftokyobay.tech/"
    
    struct team {
        var name = ""
        var score = -1
    }
    
    func makeVote(color:String){
        // Send http request to add score to white team
        let request = NSMutableURLRequest(URL: NSURL(string: pirates_url + "addscore")!)
        let jsonString = "{\"name\":\""+color+"\"}"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
        }
        task.resume()
    }
    
    func getVotes() -> (team, team){
        // Get Scores for teams
        let urlPath:String = pirates_url + "getteams"
        let url = NSURL(string: urlPath)
        //let session = NSURLSession.sharedSession()
        
        if let data = try? NSData(contentsOfURL: url!, options: []) {
            let json = JSON(data: data)
            let team1 = team(name: json["0"]["Name"].string!, score: json["0"]["Score"].int!)
            let team2 = team(name: json["1"]["Name"].string!, score: json["1"]["Score"].int!)
            return (team1, team2)
        }

        return (team(), team())
        
    }
}
