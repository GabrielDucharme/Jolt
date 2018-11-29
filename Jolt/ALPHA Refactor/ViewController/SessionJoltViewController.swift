//
//  SessionJoltViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-07.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class SessionJoltViewController: UIViewController {
    
    // Create Firestore Database and User ID Reference
    var db: Firestore!
    let userID = Auth.auth().currentUser!.uid
    
    var habitName = String()
    var joltCount = Int()

    @IBOutlet weak var joltTextView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        print("Habit name: \(habitName)")
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        joltCount += 1
        logNewJolt()
    }
    
    func logNewJolt() {
        
        let joltData = Jolt(note: joltTextView.text ?? "", createdOn: Date()).dictionary
        
        let collectionReference = db.document("users/\(userID)").collection("Habits")
        let query = collectionReference.whereField("Name", isEqualTo: habitName)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                print("There is an error")
            } else {
                for document in snapshot!.documents {
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").collection("Jolts").addDocument(data: joltData)
                    
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData(["Jolt Count" : self.joltCount])
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
