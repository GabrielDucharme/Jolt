//
//  LoginViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-07-11.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    // CONSTANTS

    // OUTLETS
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    
    // BUTTON OUTLETS
    @IBAction func logoutButton(_ sender: Any) {
        //User will be logged out
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "unwindToLoginView", sender: self)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            // Truncating the first name out of Firebase user.displayName
            var displayName = user.displayName!
            
            if let spaceRange = displayName.range(of: " ") {
                displayName.removeSubrange(spaceRange.lowerBound..<displayName.endIndex)
            }
        }

        // Do any additional setup after loading the view.
        dashboardCollectionView.delegate = self
        dashboardCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DashboardViewController {
    // Setup Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dash-01", for: indexPath) as! Dash01CollectionViewCell
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
}
