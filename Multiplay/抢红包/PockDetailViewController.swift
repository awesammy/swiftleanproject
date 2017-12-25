//
//  PockDetailViewController.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-25.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit
import Firebase

class PockDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var userID = ""
    var userName = ""
    let user = UserDefaults.standard
    
    var ref:DatabaseReference?
    var pocketID = ""
    var pocketType = ""
    var pocketMyAmount = "我的红包"
    var currentPocketData = [String:Any]()
    var currentLogData = [String:Any]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        databaseSetup()
        detectUserID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.clear
    }
    
    func detectUserID(){
        if user.value(forKey: "userID") != nil {
            userID = user.value(forKey: "userID") as! String
        }
        else{
            userID = "userid_\(100000000 + arc4random_uniform(99999999))"
            user.set(userID, forKey: "userID")
        }
        
        if user.value(forKey: "userName") != nil {
            userName = user.value(forKey: "userName") as! String
        }
        else{
            //prompUser()
        }
    }
    
    func databaseSetup(){
        ref = Database.database().reference()
        if ref?.child("redPocket").child(pocketID) != nil {
            
            ref?.child("redPocket").child(pocketID).observe(.value, with: { (snapshot) in
                self.currentPocketData = snapshot.value as! [String:Any]
                if (self.currentPocketData["uid"] as! String) == self.userID {
                    
                }
                else{
                    
                }
                
                if self.currentPocketData["log"] != nil {
                    self.currentLogData = self.currentPocketData["log"] as! [String:Any]
                    for idV in Array(self.currentLogData.values) {
                        if ((idV as! [String:Any])["uid"] as! String) == self.userID {
                            self.pocketMyAmount = (idV as! [String:Any])["amount"] as! String
                        }
                    }
                    
                }
                
                
                if (self.currentPocketData["status"] as! String) != "new"  {
                    //Pocket is finish
                    //Update
                }
                else{
                    
                }
                self.tableView.reloadData()
            })
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return currentLogData.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PocketMainCell", for: indexPath) as! PocketMainCell
            cell.cellMyName.text = userName
            cell.cellMyAmount.text = pocketMyAmount
            cell.cellPocketInfo.text = "红包还未抽完"
            
            return cell
        }
        else{
            let currentLog = Array(currentLogData.values)[indexPath.row] as! [String:Any]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PocketColumnCell", for: indexPath) as! PocketColumnCell
            cell.cellUserName.text = currentLog["name"] as! String
            cell.cellUserTime.text = convertTimestamp(serverTimestamp: currentLog["timestamp"] as! Double)
            cell.cellUserAmount.text = currentLog["amount"] as! String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        else{
            return 60
        }
    }
    
    
    
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        return timeAgoSinceDate(date as Date, currentDate: Date(), numericDates: true)
    }
    
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!)年前"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1年前"
            } else {
                return "去年"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)月前"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1月前"
            } else {
                return "上个月"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)周前"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1周前"
            } else {
                return "上周"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)天前"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1天前"
            } else {
                return "昨天"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)小时前"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1小时前"
            } else {
                return "一小时前"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)分钟前"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1分钟前"
            } else {
                return "1分钟前"
            }
        } else if (components.second! >= 30) {
            return "\(components.second!)秒前"
        } else {
            return "现在"
        }
        
    }
    

   

}
