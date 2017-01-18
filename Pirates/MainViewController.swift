//
//  MainViewController.swift
//  Pirates
//
//  Created by Issam Zeibak on 10/24/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "mainPage_header_PiratesLogo.png")
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        scrollView.userInteractionEnabled = true;
        scrollView.contentSize.height = 850;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openStoreUrl(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://line.me/S/sticker/1328495")!)
    }
}
