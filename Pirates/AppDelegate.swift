//
//  AppDelegate.swift
//  Pirates
//
//  Created by Issam Zeibak on 9/26/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import UIKit
//import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    // 1
    let googleMapsApiKey = "AIzaSyABHuREt6-05yxmEf_o6KNTk4Nw6C4D6lU"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {
            
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "NotoSansCJKjp-Bold", size: 20)!]
            UINavigationBar.appearance().barTintColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
            
            
            UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg, forState: .Normal, barMetrics: .Default)
            UINavigationBar.appearance().backItem?.backBarButtonItem?.title=""
            
            
            // 2
            GMSServices.provideAPIKey(googleMapsApiKey)
            return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


// Global helper methods for app
let backImg: UIImage = (UIImage(named: "Back_Chevron")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal).imageWithAlignmentRectInsets(UIEdgeInsetsMake(-30,-5, -30, -5)))!

func setUpTopRoundedCorners(view: UIView) {
    let path = UIBezierPath(roundedRect:view.bounds, byRoundingCorners:[UIRectCorner.TopRight, .TopLeft], cornerRadii: CGSizeMake(3, 3))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.CGPath
    view.layer.mask = maskLayer
    view.layer.masksToBounds = true
}

func setUpBottomRoundedCorners(view: UIView) {
    let path = UIBezierPath(roundedRect:view.bounds, byRoundingCorners:[UIRectCorner.BottomRight, .BottomLeft], cornerRadii: CGSizeMake(3, 3))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.CGPath
    view.layer.mask = maskLayer
    view.layer.masksToBounds = true
}

func overrideBackButton(viewController: UIViewController){
    viewController.navigationItem.hidesBackButton = true
    let newBackButton = UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.Plain, target: viewController, action: Selector("popToRoot:"))
    viewController.navigationItem.leftBarButtonItem = newBackButton;
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}


var bounds = UIScreen.mainScreen().bounds
var screenWidth = bounds.size.width
var screenHeight = bounds.size.height
