//
//  ProfileViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-07.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func logoutButton(_ sender: Any) {
        //User will be logged out
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = "\((Auth.auth().currentUser?.displayName)!)"
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
    }
}
