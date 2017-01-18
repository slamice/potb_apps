//
//  LoadingTableView.swift
//  LoadingIndicator
//
//  Created by Sztanyi Szabolcs on 10/07/15.
//  Copyright (c) 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class LoadingTableView: UITableView {
    
    let loadingImage = UIImage(named: "loading_skull")
    var loadingImageView: UIImageView
    var loadingLabel: UILabel
    
    required init?(coder aDecoder: NSCoder) {
        loadingImageView = UIImageView(image: loadingImage)
        
        loadingLabel = UILabel()
        loadingLabel.textColor = UIColor.whiteColor()

        loadingLabel.text = "Loading..."

        loadingLabel.font = UIFont(name: "NotoSansCJKjp-Bold", size: CGFloat(20))
        super.init(coder: aDecoder)
        addSubview(loadingImageView)
        addSubview(loadingLabel)
        adjustSizeOfLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        loadingImageView.hidden = false
        loadingLabel.hidden = false
        self.bringSubviewToFront(loadingImageView)
        self.bringSubviewToFront(loadingLabel)
    }
    
    func hideLoadingIndicator() {
        loadingImageView.hidden = true
        loadingLabel.hidden = true
    }
    
    override func reloadData() {
        super.reloadData()
        self.bringSubviewToFront(loadingImageView)
    }
    
    // MARK: private methods
    // Adjust the size so that the indicator is always in the middle of the screen
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizeOfLoadingIndicator()
    }
    
    private func adjustSizeOfLoadingIndicator() {
        let loadingImageSize = loadingImage?.size
        let imageX = CGRectGetWidth(frame)/2 - loadingImageSize!.width/2
        let imageY = CGRectGetHeight(frame)/3-loadingImageSize!.height/2
        let imageWidth = loadingImageSize!.width
        let imageHeight = loadingImageSize!.height
        let padding = CGFloat(0.0)

        loadingImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight)

        loadingLabel.frame = CGRectMake(imageX - padding - 20, imageY + padding, 200, 200)
    }
}
