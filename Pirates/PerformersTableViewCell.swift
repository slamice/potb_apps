//
//  PerformersTableViewCell.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 2/27/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation


import UIKit


class PerformersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var performerPic: UIImageView!
    @IBOutlet weak var performerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}