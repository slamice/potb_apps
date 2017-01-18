//
//  VoteWhiteViewController.swift
//  Pirates
//
//  Created by Issam Zeibak on 10/24/15.
//  Copyright © 2015 Issam Zeibak. All rights reserved.
//

import UIKit

class VoteWhiteViewController: UIViewController {

    @IBOutlet weak var fadeLabel: UITextField!
    @IBOutlet weak var fadeCheckMark: UIImageView!


    @IBOutlet weak var whiteScore: UILabel!
    @IBOutlet weak var redScore: UILabel!
    
/*    let backRootButton: UIButton = {
        let button = UIBUtton()
        button.frame = CG
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fadeLabel.alpha = 1
        self.fadeCheckMark.alpha = 1
        self.whiteScore.alpha = 0
        self.redScore.alpha = 0
        
        overrideBackButton(self)
        VotingApi().makeVote("white")
    }
    
    override func viewDidAppear(animated: Bool){
        let (t1, t2) = VotingApi().getVotes()
        
        var wScore = "?"
        var rScore = "?"
        
        if(t1.score != -1 || t2.score != -1){
            wScore = t1.name == "white" ? String(t1.score) : String(t2.score)
            rScore = t1.name == "red" ? String(t1.score) : String(t2.score)
        }
        self.whiteScore.text = "White: " + wScore
        self.redScore.text = "Red: " + rScore
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.fadeLabel.alpha = 0.0
                self.fadeCheckMark.alpha = 0.0
            })
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.whiteScore.alpha = 1
            self.redScore.alpha = 1
        })
    
    }
    
    @objc func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

}
