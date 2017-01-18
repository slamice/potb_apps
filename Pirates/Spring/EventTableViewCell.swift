//
//  EventTableViewCell.swift
//  Pirates
//
//  Created by Issam Zeibak on 11/21/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventBanner: UIImageView!
    @IBOutlet weak var dividerLine: UIView!
    @IBOutlet weak var venueName: UILabel!
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var jDate: UILabel!
    @IBOutlet weak var eDate: UILabel!
    @IBOutlet weak var jTime: UILabel!
    @IBOutlet weak var eTime: UILabel!
    @IBOutlet weak var descriptionText: LabelWithMargins!
    @IBOutlet weak var expandButton: UIButton!
    
    var expandPress : (() -> Void)? = nil

    @IBOutlet var descriptionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet var expandButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapButton: MapUIButton!
    @IBOutlet weak var tableView: EventsTableViewController!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func expandPress(sender: AnyObject) {
        if self.tableView.expandedElements[self.expandButton.tag] == true {
            self.tableView.expandedElements[self.expandButton.tag] = false
        } else {
            self.tableView.expandedElements[self.expandButton.tag] = true
        }
        
        self.tableView.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.expandButton.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    @IBOutlet weak var rowLabel: UILabel!
    
}
