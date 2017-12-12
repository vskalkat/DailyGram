//
//  StartView.swift
//  InstagramClone
//
//  Created by Vikramjit Kalkat on 2017-10-16.
//  Copyright © 2017 Vikramjit Kalkat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import AlamofireImage

class StartView: UIViewController{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessage: UITextView!
    @IBOutlet weak var myimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true;
        
        let downloadURL = URL(string: "https://i.pinimg.com/736x/5b/b6/41/5bb6411a1d20e2d3407831adf065f639--best-lock-screen-lock-screen-wallpaper.jpg")
        myimage.af_setImage(withURL: downloadURL!)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        var email = emailField.text
        var password = passwordField.text
        
        if(email != "" && password != "") {
            Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if(error != nil) {
                    if(error!.localizedDescription.contains("no user record")){
                        self.errorMessage.text = "Email not registered. Please sign up."
                        self.errorMessage.isHidden = false;
                    }
                    else {
                        self.errorMessage.text = "Invalid password. Please try again"
                        self.errorMessage.isHidden = false;
                    }
                    print ("ERROR:: " + error.debugDescription)
                } else if(user == nil) {
                    self.errorMessage.text = "Email not found. Please create an account."
                    self.errorMessage.isHidden = false;
                } else if (user?.isEmailVerified == false){
                    self.errorMessage.text = "Email verification is pending."
                    self.errorMessage.isHidden = false;
                } else {
                    self.performSegue(withIdentifier: "signIn", sender: nil)
                }
            })
        }
        else {
            errorMessage.text = "Username and password entry not found."
            errorMessage.isHidden = false
        }
    }
    
    func goToNextScreen()
    {
         performSegue(withIdentifier: "signIn", sender: self)
    }
    
}
