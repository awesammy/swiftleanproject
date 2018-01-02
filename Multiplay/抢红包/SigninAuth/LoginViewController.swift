//
//  LoginViewController.swift
//  Multiplay
//
//  Created by Sam Chen on 2018-01-01.
//  Copyright © 2018 samapplab. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var vid = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.isEnabled = false
        phoneText.keyboardType = .phonePad
        codeText.keyboardType = .phonePad
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var loginButton: UIBarButtonItem!
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginAction(_ sender: UIBarButtonItem) {
        if codeText.text != "" {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.vid, verificationCode: codeText.text!)
            Auth.auth().signIn(with: credential) { (userA, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                
            }
        }
        
    }
    
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var codeText: UITextField!
    @IBAction func codeSent(_ sender: UIButton) {
        if phoneText.text != "" {
            let phoneN = "+1"+phoneText.text!
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneN, uiDelegate: nil, completion: { (verificationID, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                self.vid = verificationID!
                self.loginButton.isEnabled = true
            })
        }
        
    }
    
    func getUsersName(){
        let alert = UIAlertController(title: "起个名吧", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield:UITextField) in
            textfield.placeholder = ""
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
