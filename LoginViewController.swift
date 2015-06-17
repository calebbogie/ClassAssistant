//
//  LoginViewController.swift
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/17/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let scrollViewWallSegue = "LoginSuccessful"
    
    @IBAction func logInPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) { user, error in
            if user != nil {
                println("Logged in!")
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            } else if let error = error {
                //self.showErrorView(error)
            }
        }
    }
}
