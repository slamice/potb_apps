//
//  VoteViewController.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 4/11/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation

import UIKit

class VoteViewController: UIViewController {
    
    @IBOutlet weak var NoInternetView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isConnectedToNetwork(programsURL) {
            NoInternetView.hidden = false
            return
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.clipsToBounds = true
    }
    
}
