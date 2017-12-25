//
//  ViewController.swift
//  Multiplay
//
//  Created by Sam Chen on 2017-12-24.
//  Copyright © 2017 samapplab. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var ref:DatabaseReference?
    
    var dataFolder = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
        ref?.child("gameRequest").observe(DataEventType.value, with: { (snapshot) in
            self.dataFolder = snapshot.value as! [String:Any]
            print(self.dataFolder)
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return dataFolder.count
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as! InviteCell
            return cell
        }
        else{
            let current = Array(dataFolder.values)[indexPath.row] as! [String:String]
            let currentDataID = Array(dataFolder.keys)[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerAvailableCell", for: indexPath) as! PlayerAvailableCell
            cell.cellNameLabel.text = current["player1"]
            cell.cellTimeLabel.text = current["time"]
            cell.cellColorLabel.backgroundColor = UIColor.green
            if current["player2"] != "unknown" {
                cell.cellColorLabel.backgroundColor = UIColor.red
            }
            cell.dataId = currentDataID
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 55
        }
        else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            createNewPlay()
        }
        else{
            
        }
    }
    
    
    func createNewPlay(){
        let alert = UIAlertController(title: "New Game", message: "Create new game with other players", preferredStyle: .alert)
        alert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Your name"
            
        }
        let alertConfirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
           
            let dateF = DateFormatter()
            dateF.dateFormat = "YYYY-MM-dd HH:mm"
            let textName = alert.textFields![0].text!
           
            if textName != "" {
                self.ref?.child("gameRequest").childByAutoId().setValue(["player1":textName,"player2":"unknown","score":"0","time":dateF.string(from: Date())])
            }
        })
        alert.addAction(alertConfirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func joinNewPlay(gameName:String,reference:String){
        let alert = UIAlertController(title: "New Game", message: "You are about to join \(gameName)", preferredStyle: .alert)
        alert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Your name"
            
        }
        let alertConfirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            
            let dateF = DateFormatter()
            dateF.dateFormat = "YYYY-MM-dd HH:mm"
            let textName = alert.textFields![0].text!
            
            if textName != "" {
                self.ref?.child("gameRequest").child(reference).setValue(["player1":gameName,"player2":textName,"score":"0","time":dateF.string(from: Date())])
                self.tableView.reloadData()
            }
        })
        alert.addAction(alertConfirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoGame"{
            let cell: PlayerAvailableCell = sender as! PlayerAvailableCell
            let gameVC: GamePlayViewController = segue.destination as! GamePlayViewController
            gameVC.gameID = cell.dataId
            print(cell.dataId)
            joinNewPlay(gameName: cell.cellNameLabel.text!, reference: cell.dataId)
            
        }
    }
    
}

