//
//  LoginVC.swift
//  
//
//  Created by Gabriel Ducharme on 2018-02-04.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class UserLoginViewController: UIViewController, FUIAuthDelegate {
    
    // Setup Google Firestore Database Ref
    var docRef : DocumentReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user is already logged in
        isUserLogged()

        // Do any additional setup after loading the view.
    }
    
    func isUserLogged() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // Create a user profile in Firebase Firestore
                if let user = user {
                    let name = user.displayName
                    let uid = user.uid
                    let email = user.email
                    let photoUrl = user.photoURL
                    
                    self.docRef = Firestore.firestore().document("users/\(uid)")
                    
                    let dataToSave : [String: Any] = ["name": "\(name!)", "Email": "\(email!)", "PhotoUrl": "\(photoUrl!)"]
                    self.docRef.setData(dataToSave) { (error) in
                        if let error = error {
                            print("Oh no! Some error \(error.localizedDescription)")
                        } else {
                            print("User data was saved \(name!)")
                        }
                    }
                }
                // User is signed in so segue to his habits
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }

    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            print("User is not in now")
            print(error.debugDescription)
        } else {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    func login() {
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let googleProvider = FUIGoogleAuth()
        let facebookProvider = FUIFacebookAuth()
        authUI?.providers = [googleProvider, facebookProvider]
        let authViewController = AuthVC(authUI: authUI!)
        let navc = UINavigationController(rootViewController: authViewController)
        self.present(navc, animated: true, completion: nil)
    }
    
}
