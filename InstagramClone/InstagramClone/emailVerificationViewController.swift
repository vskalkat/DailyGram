//
//  emailVerificationViewController.swift
//  InstagramClone
//
//  Created by Vikramjit Kalkat on 2017-10-17.
//  Copyright © 2017 Vikramjit Kalkat. All rights reserved.
//

import UIKit

class emailVerificationViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextView!
    var emailAddress:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recievedText = emailAddress {
            emailLabel.text = recievedText;
        }

    }



}
