//
//  ScheduleViewController.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 4/9/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation
import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var NoInternetView: UIView!
    
    @IBOutlet weak var scheduleLoader: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isConnectedToNetwork(eventURL) {
            NoInternetView.hidden = false
            return
        }
        
        self.navigationItem.title = "Schedule / スケジュール"
    }
}
