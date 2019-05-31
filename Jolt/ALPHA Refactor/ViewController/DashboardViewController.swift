//
//  LoginViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-07-11.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import Charts

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // CONSTANTS
    let itemPerRow: CGFloat = 1
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

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

        // Do any additional setup after loading the view.
        dashboardCollectionView.delegate = self
        dashboardCollectionView.dataSource = self
        
        // Update Dashboard
        
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dash-01", for: indexPath) as! Dash01CollectionViewCell
                
                return cell
            }
        }
        

        if indexPath.section == 1 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dash-02", for: indexPath) as! Dash02CollectionViewCell
                
                cell.backgroundColor = UIColor.white
                return cell
            }
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dash-01", for: indexPath) as! Dash01CollectionViewCell
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dash-header", for: indexPath) as! DashboardHeader
            view.dashHeaderLabel.text = "Your daily sessions time"
            return view
        }
        
        if indexPath.section == 1 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dash-header", for: indexPath) as! DashboardHeader
            view.dashHeaderLabel.text = "Your weekly session time"
            return view
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dash-header", for: indexPath) as! DashboardHeader
        view.dashHeaderLabel.text = "Dashboard header here"
        return view
    }
}

extension DashboardViewController {
    // Setup Flow layout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
