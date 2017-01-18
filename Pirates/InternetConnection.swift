//
//  InternetConnection.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 8/30/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import SystemConfiguration
import ReachabilitySwift

    func isConnectedToNetwork(hostname: String) -> Bool{
        do {
            let internetReachability = try Reachability(hostname:hostname)
            if internetReachability.isReachable() {
                return true
            }
            return false
        } catch {
            return false
        }
    }
