//
//  LoginViewController.swift
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/17/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet var loginView: FBSDKLoginButton!
    
    let scrollViewWallSegue = "LoginSuccessful"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If user has previously logged in with Facebook...
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            println("User is logged in already!")
            self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            return
        }
        //If user has previously logged in through Parse...
        else if let user = PFUser.currentUser() {
            if user.isAuthenticated() {
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            }
        }
        //No tokens have been stored
        else {
            let loginView = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
        
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // Navigate to other view
            self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    //Parse methods
    
    @IBAction func logInPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) { user, error in
            if user != nil {
                println("Logged in!")
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            } else if let error = error {
                //self.showErrorView(error)
            }
        }
        
        //Clear fields
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func backToLoginView(segue:UIStoryboardSegue) {
        
    }
}
