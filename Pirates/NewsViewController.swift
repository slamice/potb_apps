//
//  NewsViewController.swift
//  Pirates Of Tokyo Bay
//
//  Created by Issam Zeibak on 8/7/16.
//  Copyright © 2016 Issam Zeibak. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gamesTitleView: UIView!
    @IBOutlet weak var newsPageTitleView: UIView!    
    
    @IBOutlet weak var performersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gamesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingScreen: UIView!
    
    @IBOutlet weak var NoInternetView: UIView!
    var programDate = ""
    
    func setupTableView(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        //setUpBottomRoundedCorners(tableView)
    }

    
    /*
     * Since the games and news table veiw heights are dynamic, it's hard tocalculate them on the
     * fly, at least I don't know how to. So here's a hack. After all the data loads, set the tableview
     * height to be very tall to see all the cells. Then get each cells' height and accumualte them
     * together to get the correct height.
     */
    
    func initializeDynamicTableViewHeight(arrayCount: Int, tableView : UITableView, tableHeightConstraint: NSLayoutConstraint) {
        tableHeightConstraint.constant = CGFloat(arrayCount) * tableView.contentSize.height
        tableView.estimatedRowHeight = 100
    }
    
    func updateDynamicTableViewHeight(tableView : UITableView) -> CGFloat {
        var height: CGFloat = CGFloat(0.0)
        for obj in tableView.visibleCells {
            if let cell = obj as? UITableViewCell {
                height = height + CGRectGetHeight( cell.bounds )
            }
        }
        return height
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingScreen.hidden = false
        if !isConnectedToNetwork(programsURL) {
            NoInternetView.hidden = false
            return
        }
        
        // Performers
        self.loadPerformers() { (boolValue) -> () in
            self.performerNumberLabel.text = self.getPerformersNumberText(self.numberOfPerformers)
            self.performersTableViewHeightConstraint.constant = self.performersTableView.contentSize.height
            self.setupTableView(self.performersTableView)
            self.performersTableView.reloadData()
            self.checkTablesLoaded()
        }
        
        // ProgramDate
        self.loadProgramDate() { (boolValue, programDate) -> () in
            self.programDateLabel.text = programDate
        }
        
        // Games
        self.loadGames() { (boolValue) -> () in
            self.initializeDynamicTableViewHeight(self.gamesArray.count,
                tableView: self.gamesTableView,
                tableHeightConstraint: self.gamesTableViewHeightConstraint)
            self.setupTableView(self.gamesTableView)
            self.gamesTableView.layoutIfNeeded()
            self.gamesTableViewHeightConstraint.constant = self.updateDynamicTableViewHeight(self.gamesTableView)
            self.checkTablesLoaded()
        }

        // News
        self.loadNews() { (boolValue) -> () in
            self.initializeDynamicTableViewHeight(self.newsArray.count,
                tableView: self.newsTableView,
                tableHeightConstraint: self.newsTableViewHeightConstraint)
            self.newsTableView.reloadData()
            //self.newsTableViewHeightConstraint.constant = self.newsTableView.contentSize.height
            self.setupTableView(self.newsTableView)
            self.newsTableViewHeightConstraint.constant = self.updateDynamicTableViewHeight(self.newsTableView)
            self.checkTablesLoaded()
        }
    }

    func checkTablesLoaded(){
        if self.performersTableView.visibleCells.count > 0 && self.newsTableView.visibleCells.count > 0 && self.gamesTableView.visibleCells.count > 0 {
            self.loadingScreen.hidden = true
        }
        self.loadingScreen.setNeedsLayout()
        self.loadingScreen.layoutIfNeeded()
    }
    
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsSelection = false
        
        if tableView == self.newsTableView {
            count = self.newsArray.count
        }
        if tableView == self.gamesTableView {
            count =  self.gamesArray.count
        }

        if tableView == self.performersTableView {
            count = self.performersArray.count
        }

        return count!
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?

        if tableView == self.newsTableView {
            let newsCell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
            let news = self.newsArray[indexPath.row]
            newsCell.newsName.text = news.name
            newsCell.newsDescription.sizeToFit()
            newsCell.newsDescription.text = news.description
            cell = newsCell
        }

        if tableView == self.gamesTableView {
            let gameCell = tableView.dequeueReusableCellWithIdentifier("GameTableViewCell", forIndexPath: indexPath) as! GamesTableViewCell
            let game = self.gamesArray[indexPath.row]
            gameCell.gameName.text = game.english_name + " / " + game.japanese_name
            gameCell.gameDescription.text = game.english_description + "\n" + game.japanese_description
            cell = gameCell
        }

        if tableView == self.performersTableView {
            let performerCell = tableView.dequeueReusableCellWithIdentifier("PerformerCell", forIndexPath: indexPath) as! PerformersTableViewCell
            let performer = self.performersArray[indexPath.row]
            performerCell.performerPic.image = getPerformerImage(performer.english_name)
            performerCell.performerName.text = performer.english_name + "   " + performer.japanese_name
            cell = performerCell
        }
        
        return cell!
    }

    ////////////////////////////
    // Performers
    ////////////////////////////
    
    
    @IBOutlet var performersTableView: UITableView!
    var numberOfPerformers = 0
    var performersArray : [Performer] = []
    @IBOutlet weak var performerNumberLabel: UILabel!
    
    let performerPics = [
        "ben anderson":"Ben",
        "Ben Anderson":"Ben",
        
        "christiane brew":"Christiane",
        "Christiane Brew":"Christiane",
        
        "david corbin":"David",
        "David Corbin":"David",
        
        "matt danalewich":"Matt",
        "Matt Danalewich":"Matt",
        
        "trey dobson":"Trey",
        "Trey Dobson":"Trey",
        
        "elliot eaton":"Elliot",
        "Elliot Eaton":"Elliot",
        
        "jessica geil":"Jessica",
        "Jessica Geil":"Jessica",
        
        "masa kawahata":"Masa",
        "Masa Kawahata":"Masa",
        
        "sawako kobayashi":"Sawako",
        "Sawako Kobayashi":"Sawako",
        
        "qyoko kudo":"Qyoko",
        "Qyoko Kudo":"Qyoko",
        
        "aya nakamura":"Aya",
        "Aya Nakamura":"Aya",
        
        "rodger sonomura":"Rodger",
        "Rodger Sonomura":"Rodger",
        
        "mike staffa":"Mike",
        "Mike Staffa":"Mike",
        
        "carlos quiapo":"Carlos",
        "Carlos Quiapo":"Carlos",
        
        "roza akino":"Roza",
        "Roza Akino":"Roza",
        
        "tomoko yoshioka":"Tomoko",
        "Tomoko Yoshioka":"Tomoko",
        
        "lisa sumiyoshi":"news_generic_female",
        "Lisa Sumiyoshi":"news_generic_female",
        
        "bob werley":"Bob",
        "Bob Werley":"Bob",
        
        "annika":"Annika",
        "Annika":"Annika"
    ]

    func getPerformersNumberText(number: Int) -> String {
        return "We have " +
            String(number) + " performer(s) tonight.\n今晩、" +
            String(number) + " パフォマーがいます。"
    }
    
    func getPerformerImage(name : String) -> UIImage {
        var performerPic = ""
        if performerPics[name.lowercaseString] != nil {
            performerPic = performerPics[name.lowercaseString]!
        }
        
        if (performerPic.isEmpty){
            if name.lowercaseString.hasSuffix(" f") {
                performerPic = "news_generic_female"
            } else {
                performerPic = "news_generic_male"
            }
        }
        
        return UIImage(named: performerPic)!
    }
    
    func getDefaultPerformer() -> Performer {
        return Performer(english_name: "No Performers Now...", japanese_name: "今いいえ出演ません...")
    }
    
    func loadPerformers(completion: (result: Bool)->()) {
        ProgramsApi().getPerformers { (performers, error) in
            if (error != nil) {
                print(error)
            } else {
                if performers == nil {
                    self.performersArray = [self.getDefaultPerformer()]
                } else {
                    self.performersArray = performers!
                }
                self.numberOfPerformers = self.performersArray.count
                self.performersTableView.reloadData()
                completion(result: true)
            }
        }
        completion(result: false)
    }

    ////////////////////////////
    // Games
    ////////////////////////////
    
    @IBOutlet var gamesTableView: UITableView!
    var numberOfGames = 0
    var gamesArray : [Game] = []
    
    
    func getDefaultGame() -> Game {
        return Game(english_name: "No games currently...", japanese_name: "今何のゲームはありません",
                    english_description: "", japanese_description: "")
    }
    
    func loadGames(completion: (result: Bool)->()) {
        ProgramsApi().getGames { (games, error) in
            if (error != nil) {
                print(error)
            } else {
                if games == nil {
                    self.gamesArray = [self.getDefaultGame()]
                } else {
                    self.gamesArray = games!
                }
                self.numberOfGames = self.gamesArray.count
                self.gamesTableView.reloadData()
                completion(result: true)
            }
        }
        completion(result: false)
    }
    
    ////////////////////////////
    // News
    ////////////////////////////


    @IBOutlet weak var newsTableView: UITableView!
    var numberOfNewsEvents = 0
    var newsArray : [News] = []
    
    func getDefaultNews() -> News {
        return News(name: "No news now...", description: "...")
    }
    
    
    func loadNews(completion: (result: Bool)->()) {
        ProgramsApi().getNews { (news, error) in
            if (error != nil) {
                print(error)
            } else {
                if news == nil {
                    self.newsArray = [self.getDefaultNews()]
                } else {
                    self.newsArray = news!
                }
                
                self.numberOfNewsEvents = self.newsArray.count
                self.newsTableView.reloadData()
                completion(result: true)
            }
        }
        completion(result: false)
    }
    
    ////////////////////////////
    // ProgramDate
    ////////////////////////////
    @IBOutlet weak var programDateLabel: LabelWithMargins!
    
    func loadProgramDate(completion: (result: Bool, programDate: String)->()) {
        ProgramsApi().getProgramDate { (programDate, error) in
            if (error != nil) {
                print(error)
            } else {
                self.programDate = programDate
                completion(result: true, programDate: programDate)
            }
        }
        completion(result: false, programDate: "N/A")
    }
}
