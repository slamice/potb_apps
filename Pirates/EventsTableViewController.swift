//
//  EventsTableViewController.swift
//  Pirates
//
//  Created by Issam Zeibak on 11/21/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import Foundation
import MapKit

class MapUIButton: UIButton {
    var longitude: Double = 0.0
    var latitude: Double = 0.0
}

class EventsTableViewController: UITableViewController {

    @IBOutlet var loadingTableView: LoadingTableView!
    var numberOfEvents = 0
    var isLoadingEvents = false
    var improvEventArray : [ImprovEvent] = []
    var expandedElements: [Bool] = []
    
    var lat = 0.0, lng = 0.0
    
    override func viewWillAppear(animated: Bool) {
        self.tableView = self.loadingTableView
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.loadImprovEvents()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsSelection = false
        return improvEventArray.count
    }
    
    override func tableView(tableview: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        isLoadingEvents = true
        let eventCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell") as! EventTableViewCell
        let event = self.improvEventArray[indexPath.row]
        
        eventCell.venueName.text = "Venue/会場: " + event.name
        
        eventCell.expandButton.tag = indexPath.row
        
        eventCell.mapButton.longitude = Double(event.venue.longitude.description)!
        eventCell.mapButton.latitude = Double(event.venue.latitude.description)!
        eventCell.mapButton.addTarget(self, action: #selector(EventsTableViewController.openMap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        eventCell.descriptionText.text = event.description
        
        eventCell.eventBanner.image = UIImage(named: event.eventStyle.banner)
        
        eventCell.eventName.text = event.eventStyle.title
        eventCell.eventName.textColor = hexStringToUIColor(event.eventStyle.textColor)
                
        eventCell.dividerLine.backgroundColor = hexStringToUIColor(event.eventStyle.lineStyle)
        
        let timeAndDateFormatter = DateAndTimeFormatter()
        
        eventCell.jDate.text = timeAndDateFormatter.getJapaneseDate(event.start_time)
        eventCell.jTime.text = timeAndDateFormatter.getJapaneseTime(event.start_time)

        eventCell.eDate.text = timeAndDateFormatter.getEnglishDate(event.start_time)
        eventCell.eTime.text = timeAndDateFormatter.getEnglishTime(event.start_time)
        
        if expandedElements[indexPath.row] == true {
            if eventCell.expandButtonBottomConstraint.active {
                eventCell.expandButtonBottomConstraint.active = false
                eventCell.expandButton.imageView?.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
                eventCell.descriptionTextHeightConstraint.active = false
                eventCell.descriptionText.adjustsFontSizeToFitWidth = true
            }
        } else {
            eventCell.expandButtonBottomConstraint.active = true
            eventCell.descriptionTextHeightConstraint.active = true
            eventCell.descriptionText.adjustsFontSizeToFitWidth = false
            eventCell.expandButton.imageView?.transform = CGAffineTransformMakeRotation(0)
        }
        
        self.tableView.layoutIfNeeded()
        
        return eventCell
    }

    func loadImprovEvents() {
        self.loadingTableView.showLoadingIndicator()
        EventApi().getEvents { (improvEvents, error) in
            if (error != nil) {
                print(error)
            } else {
                self.improvEventArray = improvEvents!.sort({ $0.start_time < $1.start_time })
                for _ in 0...self.improvEventArray.count-1 {
                    self.expandedElements.append(false)
                }
                self.numberOfEvents = self.improvEventArray.count
                self.loadingTableView.hideLoadingIndicator()
                self.tableView.reloadData()
            }
        }
    }

    
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    @objc @IBAction func openMap(sender:MapUIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        mapViewController.lng = sender.longitude
        mapViewController.lat = sender.latitude
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }

}
