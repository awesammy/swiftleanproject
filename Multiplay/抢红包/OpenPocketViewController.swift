//
//  PocketViewController.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-25.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit
import Firebase

class OpenPocketViewController: UIViewController {

    
    var currentPocketData = [String:Any]()
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
    
    var userID = ""
    var userName = ""
    let user = UserDefaults.standard
    
    var pocketType = ""
    var pocketID = ""
    
    var ref:DatabaseReference?
    
    
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
            prompUser()
        }
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
        self.present(alert, animated: true, completion: nil)
    }
    
    func databaseSetup(){
        ref = Database.database().reference()
        if ref?.child("redPocket").child(pocketID) != nil {
            ref?.child("redPocket").child(pocketID).observe(.value, with: { (snapshot) in
                let infoSet = snapshot.value as! [String:Any]
                self.currentPocketData = snapshot.value as! [String:Any]
                if (infoSet["status"] as! String) != "new"  {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    
    
    func setupUI(){
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.clear
        
        openButton.layer.cornerRadius = openButton.frame.height/2
        openButton.layer.borderColor = UIColor.white.cgColor
        openButton.layer.borderWidth = 2.5
        openButton.addTarget(self, action: #selector(openButtonTouched(button:)), for: .touchUpInside)
        
        pocketView.layer.cornerRadius = 10.0
        pocketView.layer.borderWidth = 0.75
        pocketView.layer.borderColor = UIColor.white.cgColor
        
        switch pocketType {
        case "luck":
            pocketTypeLabel.text = "拼手气红包"
        case "amount":
            pocketTypeLabel.text = "固定额度红包"
        default:
            print("default")
        }
        pocketOpenIndicator.stopAnimating()
        
    }
    
    @IBOutlet var pocketView: UIView!
    @IBOutlet var openButton: UIButton!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var pocketTypeLabel: UILabel!
    @IBOutlet var pocketOpenIndicator: UIActivityIndicatorView!
    
    @IBAction func cancelControl(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openButtonTouched(button:UIButton){
        pocketOpenIndicator.startAnimating()
        //Get current value
        
        
        
        
        if currentPocketData["log"] != nil {
            let logs = currentPocketData["log"] as! [String:Any]
            for valueS in Array(logs.values){
                let currentV = valueS as![String:Any]
                if (currentV["uid"] as! String) != userID {
                    //User didnt get the money
                    let sysStatus = randomMoneyAndDBSetup(varpockType: pocketType)
                    if sysStatus {
                        gotoDetailPage()
                    }
                    
                }
                else{
                    //User get the money go to detail page
                    gotoDetailPage()
                }
            }
        }
        else{
            let sysStatus = randomMoneyAndDBSetup(varpockType: pocketType)
            if sysStatus {
                gotoDetailPage()
            }
        }
        //Create log
    }
    
    func randomMoneyAndDBSetup(varpockType:String) -> Bool{
       
        var takeSuccess = true
        
        let totalA = currentPocketData["totalamount"] as! String
        let currentA = currentPocketData["amount"] as! String
        let totalN = currentPocketData["totalcount"] as! String
        let currentN = currentPocketData["count"] as! String
        
        var aveNumber = Double(totalA)! / Double(totalN)!
        
        
        var minMoney:Double = 0.01
        var maxMoney = Double(currentA)!/Double(currentN)!*2
        
        
        
        
        
        let plusAmount = Int(arc4random_uniform(2))
        
        if plusAmount == 0 {
            
        }
        else{
            
        }
        
        
        if Double(currentN)! > 0.0 && Double(currentA)! > 0.0 {
            if varpockType == "luck"{
                //
               self.dismiss(animated: true, completion: nil)
                ref?.child("redPocket").child(pocketID).child("log").childByAutoId().setValue(["uid":userID,"name":userName,"amount":"","timestamp":ServerValue.timestamp()])
                ref?.child("redPocket").child(pocketID).child("amount").setValue("\(Double(currentA)!-1)")
                ref?.child("redPocket").child(pocketID).child("count").setValue("\(Int(currentN)!-1)")
            }
            else if varpockType == "amount"{
                ref?.child("redPocket").child(pocketID).child("log").childByAutoId().setValue(["uid":userID,"name":userName,"amount":"\(aveNumber)","timestamp":ServerValue.timestamp()])
                ref?.child("redPocket").child(pocketID).child("amount").setValue("\(Double(currentA)!-aveNumber)")
                ref?.child("redPocket").child(pocketID).child("count").setValue("\(Int(currentN)!-1)")
            }
            else{
                //type not match
                takeSuccess = false
            }
        }
        else{
            //empty
            takeSuccess = false
        }
        
        
        return takeSuccess
    }
    
    func gotoDetailPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pocketDetailVC = storyboard.instantiateViewController(withIdentifier: "PockDetailViewController") as! PockDetailViewController
        pocketDetailVC.pocketID = pocketID
        self.present(pocketDetailVC, animated: true, completion: nil)
    }
    
}
