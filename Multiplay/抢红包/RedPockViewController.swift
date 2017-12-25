//
//  RedPockViewController.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-25.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit
import Firebase

class RedPockViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var ref:DatabaseReference?
    var valuesRed = [String:Any]()
    var userID = ""
    var userName = ""
    var userTotal = ""
    let user = UserDefaults.standard
    
    
    func detectUserID(){
        if user.value(forKey: "userID") != nil {
            userID = user.value(forKey: "userID") as! String
        }
        else{
            userID = "userid_\(100000000 + arc4random_uniform(99999999))"
            user.set(userID, forKey: "userID")
        }
        
        if user.value(forKey: "userTotal") != nil {
            userTotal = user.value(forKey: "userTotal") as! String
        }
        else{
            userTotal = "2000"
            user.set(userTotal, forKey: "userTotal")
        }
        
        if user.value(forKey: "userName") != nil {
            userName = user.value(forKey: "userName") as! String
        }
        else{
            prompUser()
        }
        
        print("UserID: \(userID)")
        print("UserName: \(userName)")
        print("UserMoney: \(userTotal)")
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBAction func reloadingTableView(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    @IBAction func addNewAction(_ sender: UIBarButtonItem) {
        addPocket()
    }
    
    @IBAction func showMe(_ sender: UIBarButtonItem) {
        showMyInfo()
    }
    func setupUI(){
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.clear
        
    }
    
    func prompUser(){
        let alert = UIAlertController(title: "取个霸气的名字", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield:UITextField) in
            textfield.placeholder = ""
        }
        let confirmAction = UIAlertAction(title: "确认", style: .default) { (action) in
            let textI = alert.textFields![0].text!
            if textI != "" {
                self.userName = textI
                self.user.set(self.userName, forKey: "userName")
            }
        }
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addPocket(){
        let alert = UIAlertController(title: "发红包", message: "选择发红包类型\n\n您现在有\(userTotal)", preferredStyle: .actionSheet)
        let alertLuckAction = UIAlertAction(title: "拼手气红包", style: .default) { (action) in
            self.alertForPock(type: "拼手气红包", amountTotal: self.userTotal)
        }
        let alertAmountAction = UIAlertAction(title: "固定额度红包", style: .default) { (action) in
            self.alertForPock(type: "固定额度红包", amountTotal: self.userTotal)
        }
        let alertCancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(alertLuckAction)
        alert.addAction(alertAmountAction)
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertForPock(type:String,amountTotal:String){
        let alert = UIAlertController(title: type, message: "您可以在此选择红包个数和金额，你选择的金额不能超出您有的金额", preferredStyle: .alert)
        if type == "拼手气红包"{
            alert.addTextField(configurationHandler: { (textfield:UITextField) in
                textfield.placeholder = "请您选择金额 (最多\(amountTotal))"
                textfield.keyboardType = .decimalPad
            })
            alert.addTextField(configurationHandler: { (textfield:UITextField) in
                textfield.placeholder = "请您选择个数"
                textfield.keyboardType = .numberPad
            })
            alert.addTextField(configurationHandler: { (textfield:UITextField) in
                textfield.placeholder = "(可选)您想说的话"
            })
            let confirmAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
                let amountSelect = alert.textFields![0].text!
                let numberSelect = alert.textFields![1].text!
                let messageSent = alert.textFields![2].text!
                if amountSelect == "" || numberSelect == "" {
                    self.noticeError(message: "红包发送失败，您没有输入金额或个数")
                }
                else if (Double(amountSelect)! > Double(amountTotal)!){
                    self.noticeError(message: "红包发送失败，您输入的金额超过您的总金额")
                }
                else{
                    let newAmount = Double(amountTotal)! -  Double(amountSelect)!
                    self.userTotal = "\(newAmount)"
                    self.user.set(self.userTotal, forKey: "userTotal")
                    self.ref?.child("redPocket").childByAutoId().setValue(["from":self.userName,"uid":self.userID,"amount":amountSelect,"count":numberSelect,"totalamount":amountSelect,"totalcount":numberSelect,"status":"new","notes":messageSent,"type":"luck","timestamp":ServerValue.timestamp()])
                    
                }
            })
            alert.addAction(confirmAction)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else if type == "固定额度红包"{
            alert.addTextField(configurationHandler: { (textfield:UITextField) in
                textfield.placeholder = "请您选择金额(最多\(amountTotal))"
                textfield.keyboardType = .decimalPad
            })
            alert.addTextField(configurationHandler: { (textfield:UITextField) in
                textfield.placeholder = "请您选择个数"
                textfield.keyboardType = .numberPad
            })
            alert.addTextField(configurationHandler: { (textfield:UITextField) in
                textfield.placeholder = "(可选)您想说的话"
            })
            let confirmAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
                let amountSelect = alert.textFields![0].text!
                let numberSelect = alert.textFields![1].text!
                let messageSent = alert.textFields![2].text!
                if amountSelect == "" || numberSelect == "" {
                    self.noticeError(message: "红包发送失败，您没有输入金额或个数")
                }
                else if (Double(amountSelect)! > Double(amountTotal)!){
                    self.noticeError(message: "红包发送失败，您的金额超过总金额")
                }
                else{
                   let newAmount = Double(amountTotal)! -  Double(amountSelect)!
                    self.userTotal = "\(newAmount)"
                    self.user.set(self.userTotal, forKey: "userTotal")
                    
                    self.ref?.child("redPocket").childByAutoId().setValue(["from":self.userName,"uid":self.userID,"amount":amountSelect,"count":numberSelect,"totalamount":amountSelect,"totalcount":numberSelect,"status":"new","notes":messageSent,"type":"amount","timestamp":ServerValue.timestamp()])
                    
                }
            })
            alert.addAction(confirmAction)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
        }
    }
    
    func noticeError(message:String){
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好的", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func databaseSetup(){
        ref = Database.database().reference()
        if ref?.child("redPocket") != nil {
            ref?.child("redPocket").observe(.value, with: { (snapshot) in
                self.valuesRed = snapshot.value as! [String:Any]
                self.tableView.reloadData()
            })
        }
        
    }
    
    @objc func buttonTouched(button:UIButton){
        
        if (button.superview?.superview?.isKind(of: OthersPocketCell.self))! {
            let cell = button.superview?.superview as! OthersPocketCell
            if userName == "" {
                prompUser()
            }
            else{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let openPockVC = storyboard.instantiateViewController(withIdentifier: "OpenPocketViewController") as! OpenPocketViewController
                openPockVC.pocketID = cell.cellSenderPocketID
                openPockVC.pocketType = cell.cellPocketType
                self.present(openPockVC, animated: true, completion: nil)
            }
        }
        else if (button.superview?.superview?.isKind(of: MePocketCell.self))! {
            let cell = button.superview?.superview as! MePocketCell
            if userName == "" {
                prompUser()
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pdVC = storyboard.instantiateViewController(withIdentifier: "PockDetailViewController") as! PockDetailViewController
                pdVC.pocketID = cell.cellSenderPocketID
                pdVC.pocketType = cell.cellPocketType
                self.present(pdVC, animated: true, completion: nil)
            }
        }
        else{
            
        }
        
        
    }
    
    
    
    func showMyInfo(){
        let alert = UIAlertController(title: "我", message: "我的名字:\(userName)\n我的ID:\(userID)\n我的余额:\(userTotal)", preferredStyle: .alert)
        let modifyAction = UIAlertAction(title: "好", style: .default) { (action) in
            
        }
        let nameAction = UIAlertAction(title: "起名字", style: .default) { (action) in
            self.prompUser()
        }
        let moreAction = UIAlertAction(title: "", style: .default) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(modifyAction)
        if userName == "" {
            alert.addAction(nameAction)
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuesRed.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentRedID = Array(valuesRed.keys)[indexPath.row]
        let currentRed = Array(valuesRed.values)[indexPath.row] as! [String:Any]
        let senderName = currentRed["from"] as! String
        if (currentRed["uid"] as! String) != userID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OthersPocketCell", for: indexPath) as! OthersPocketCell
            cell.cellSenderPocketID = currentRedID
            cell.cellSenderID = currentRed["uid"] as! String
            cell.cellSenderName.text = senderName
            
            cell.cellPocketType = currentRed["type"] as! String
            cell.cellSendTime.text = convertTimestamp(serverTimestamp: currentRed["timestamp"] as! Double)
            cell.cellPocketButton.addTarget(self, action: #selector(buttonTouched(button:)), for: .touchUpInside)
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MePocketCell", for: indexPath) as! MePocketCell
            cell.cellSenderPocketID = currentRedID
            cell.cellSenderID = currentRed["uid"] as! String
            
            cell.cellPocketType = currentRed["type"] as! String
            cell.cellSendTime.text = convertTimestamp(serverTimestamp: currentRed["timestamp"] as! Double)
            cell.cellPocketButton.addTarget(self, action: #selector(buttonTouched(button:)), for: .touchUpInside)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    
    
    
    
    //Support
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
    
    
    func generatePocket(total:Double,number:Double)->String{
        var finalMessage = ""
        var minVa:Double = 0.01
        var maxVa:Double = 0.0
        
        if number < 1{
            finalMessage = "Error number wrong"
        }
        if number > total {
            finalMessage = "Error too many people"
        }
        if number == 1{
            finalMessage = "Okay|\(total)"
        }
        
        
        return finalMessage
        
    }

    
    
    
}


extension Double
{
    static func random(range: Range<Int> ) -> Double
    {
        var offset = 0.0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = Double(abs(range.lowerBound))
        }
        
        let mini = UInt32(Double(range.lowerBound) + offset)
        let maxi = UInt32(Double(range.upperBound)   + offset)
        
        return Double(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
