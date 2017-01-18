//
//  SocialViewController.swift
//  Pirates
//
//  Created by Issam Zeibak on 10/24/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController {
    
    @IBOutlet weak var linebutton: UIButton!
    
    @IBOutlet var ScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Social / SNS"
        ScrollView.userInteractionEnabled = true;
        ScrollView.contentSize.height = 800;
    }
    @IBAction func openTwitterUrl(sender: UIButton) {
        openUrl("https://twitter.com/piratestokyo")
    }
    
    @IBAction func openInstagramUrl(sender: UIButton) {
        openUrl("http://instagram.com/piratestokyo")
    }
    
    func openUrl(url: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    @IBAction func openFacebookUrl(sender: UIButton) {
        openUrl("https://www.facebook.com/tokyoimprov")
    }
    
    @IBAction func openYoutubeUrl(sender: UIButton) {
        openUrl("https://www.youtube.com/tokyoimprov")
    }
    
    @IBAction func openPiratesUrl(sender: UIButton) {
        openUrl("http://piratesoftokyobay.com/")
    }

}
