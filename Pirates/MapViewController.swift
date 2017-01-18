//
//  MapViewController.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 2/7/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let MIN_ZOOM_START = 18.0 as Float
    let MAX_ZOOM_IN = 21.0 as Float
    let MIN_ZOOM_OUT = 15.0 as Float
    let markerName = "Pirates Of Tokyo Bay"
    
    var lng = 0.0, lat = 0.0
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var entireView: UIView!
    var gmsMap: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToolbar()
        
        // Map stuff
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        let loc = CLLocationCoordinate2DMake(self.lat, self.lng)
        let marker = GMSMarker(position: loc)
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithTarget(loc, zoom: MIN_ZOOM_START)
      
        gmsMap = GMSMapView(frame: self.getScreenFrame())
        gmsMap.layoutIfNeeded()
        gmsMap.myLocationEnabled = true
        gmsMap.settings.myLocationButton = true
        marker.map = gmsMap
        marker.title = markerName
        gmsMap.camera = camera
        gmsMap.indoorEnabled = false
        // TODO remove hardcoded adition to height
        gmsMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: (self.navigationController?.navigationBar.frame.size.height)! + 40, right: 0)
        self.view.addSubview(gmsMap)
        
    }
    
    @IBAction func zoomIn(sender:UIBarButtonItem) {
        let cameraZoom = gmsMap.camera.zoom
        
        if (cameraZoom < MAX_ZOOM_IN){
            gmsMap.animateToZoom(cameraZoom + 1.0)
        }
    }
    
    @objc @IBAction func zoomOut(sender:UIBarButtonItem) {
        let cameraZoom = gmsMap.camera.zoom
        
        if (cameraZoom > MIN_ZOOM_OUT){
            gmsMap.animateToZoom(cameraZoom - 1.0)
        }
    }
    
    func getScreenFrame() -> CGRect {
        let screenBounds = entireView.bounds;
        let navFrame = self.navigationController?.navigationBar.frame;
        let heightOfNavbar = navFrame?.size.height;
        var frame = screenBounds
        frame.size.height -= heightOfNavbar!;
        return frame;
    }
    
    func addToolbar() {
        // Toolbar stuff
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target:nil, action: nil)
        let zoomInButton = UIBarButtonItem(title:"Zoom In", style: .Plain, target: self, action: #selector(MapViewController.zoomIn(_:)))
        let zoomOutButton = UIBarButtonItem(title:"Zoom out", style: .Plain, target: self, action: #selector(MapViewController.zoomOut(_:)))
        
        self.toolbarItems = [space, zoomInButton, space, zoomOutButton, space]
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.toolbarItems = nil
        //self.navigationController?.setToolbarItems(nil, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}
