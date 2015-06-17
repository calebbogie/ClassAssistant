//
//  SignUpViewController.swift
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/17/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let scrollViewWallSegue = "SignUpSuccessful"
    let tableViewWallSegue = "SignupSuccesfulTable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func signUpPressed(sender: AnyObject) {
        println("SignUp Pressed")
        
        //TODO
        //If signup sucessful:
        
        let user = PFUser()
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackgroundWithBlock { succeeded, error in
            if (succeeded) {
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            } else if let error = error {
                //self.showErrorView(error)
            }
        }
        
        //performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
    }
    
}