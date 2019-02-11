//
//  LoginVC.swift
//  
//
//  Created by Gabriel Ducharme on 2018-02-04.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth

class UserLoginViewController: UIViewController, FUIAuthDelegate, CAAnimationDelegate {
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    @IBOutlet weak var loginButton: UIButton!
    
    // Setup Google Firestore Database Ref
    var docRef : DocumentReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user is already logged in
        isUserLoggedIn()
        
        // Login Button Setup
        loginButton.layer.cornerRadius = 7.0

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Gradient View Setup
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        self.view.layer.insertSublayer(gradient, at: 0)
        
        animateGradient()
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let googleProvider = FUIGoogleAuth()
        let facebookProvider = FUIFacebookAuth()
        let phoneProvider = FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)
        authUI?.providers = [phoneProvider, googleProvider, facebookProvider]
        let authViewController = AuthVC(authUI: authUI!)
        let navc = UINavigationController(rootViewController: authViewController)
        self.present(navc, animated: true, completion: nil)
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    func isUserLoggedIn() {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // Create a user profile in Firebase Firestore
                if let user = user {
                    let name = user.displayName ?? ""
                    let uid = user.uid
                    let email = user.email ?? ""
                    let photoUrl = user.photoURL ?? nil
                    
                    self.docRef = Firestore.firestore().document("users/\(uid)")
                    
                    let dataToSave : [String: Any] = ["UID": "\(uid)","Name": "\(name)", "Email": "\(email)", "PhotoUrl": "\(photoUrl)"]
                    self.docRef.setData(dataToSave) { (error) in
                        if let error = error {
                            print("Oh no! Some error \(error.localizedDescription)")
                        } else {
                            print("User data was saved \(name)")
                        }
                    }
                }
                // User is signed in so segue to his habits
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("No user is sign-in right now")

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
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
}

extension UserLoginViewController {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
