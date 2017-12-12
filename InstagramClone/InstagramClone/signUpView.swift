//
//  signUpView.swift
//  InstagramClone
//
//  Created by Vikramjit Kalkat on 2017-10-16.
//  Copyright © 2017 Vikramjit Kalkat. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class signUpView: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessage: UITextView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 72.0;
        profileImage.clipsToBounds = true;
        
        errorMessage.isHidden = true;
        
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(signUpView.profileImageSelector) )
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @objc func profileImageSelector() {
        print("PROFILE IMAGE TAP RECOGNIZED!")
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
        pickerController.delegate = self
    }
    
    @IBAction func cancelSignup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signUp(_ sender: Any) {
        var username = usernameField.text;
        var email = emailField.text;
        var password = passwordField.text;
        if(username == "" || email == "" || password == "")
        {
            errorMessage.isHidden = false;
        }
        else {
            Auth.auth().createUser(withEmail: email!, password: password!)
            var currentUser = Auth.auth().currentUser
            if let currentUser = currentUser {
                currentUser.sendEmailVerification(completion: { (Error) in
                    print("Verification email sent!")
                })
                
                 let storageRef = Storage.storage().reference().child("profile_image").child(currentUser.uid)
                if let profileImg = self.selectedImage {
                    let imageData = UIImageJPEGRepresentation(profileImg, 0.1)
                    storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
                        if (error != nil) {
                            return
                        }
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        let userReference = Database.database().reference().child("users")
                        let newUserReference = userReference.child(currentUser.uid)
                        newUserReference.setValue(["username": self.usernameField.text!, "email": self.emailField.text!, "profileImageUrl": profileImageUrl])
                    })
                }
                
            }
            self.performSegue(withIdentifier: "signUp", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recieverVC = segue.destination as! emailVerificationViewController;
        if let emailAddress = emailField.text{
            recieverVC.emailAddress = emailAddress;
        }
    }
    
    
}

extension signUpView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did finish picking image.")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}
