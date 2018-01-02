//
//  WelcomeViewController.swift
//  Multiplay
//
//  Created by Sam Chen on 2018-01-01.
//  Copyright © 2018 samapplab. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var applicationsHere = ["抢红包","交谈系统"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return applicationsHere.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "welcomeCell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        cell.textLabel?.text = applicationsHere[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return applicationsHere[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rpVC = storyboard.instantiateViewController(withIdentifier: "RedPockViewController") as! RedPockViewController
            self.present(rpVC, animated: true, completion: nil)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
        }
    }

}
