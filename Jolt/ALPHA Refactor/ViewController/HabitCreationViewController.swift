//
//  HabitCreationViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-03-21.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase

class HabitCreationViewController: UIViewController {
    
    // Create Firestore Database and User ID Reference
    var db: Firestore!
    let userID = Auth.auth().currentUser!.uid

    // IBOutlets
    @IBOutlet weak var newHabitNameTextField: UITextField!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var sessionTimeStepper: UIStepper!
    
    
    @IBAction func sessionTimeValueChanged(_ sender: UIStepper) {
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value).description)"
        print("Value is now: \(sessionTimeStepper.value)")
    }
    
    @IBAction func createNewHabitButton(_ sender: UIButton) {
        if newHabitNameTextField.text != "" {
            
            
            //Check if habit name already exist
            
            db.document("users/\(userID)").collection("Habits").getDocuments { (snap, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    
                    var habitNameIsAvailable = true
                    
                    for document in snap!.documents {
                        if self.newHabitNameTextField.text == document.data()["Name"] as? String {
                            print("There is already an habit with this name")
                            habitNameIsAvailable = false
                        }
                    }
                    
                    if habitNameIsAvailable {
                        
                        let newHabit = Habit(name: "\(self.newHabitNameTextField.text!)", sessionLength: Int(self.sessionTimeStepper.value), createdOn: Date(), sessionCount: 0, totalTimeLogged: 0, joltCount: 0, archived: false)
                        
                        var ref:DocumentReference? = nil
                        ref = self.db.document("users/\(self.userID)").collection("Habits").addDocument(data: newHabit.dictionary) {
                            error in
                            
                            if let error = error {
                                print("Erro adding document: \(error.localizedDescription)")
                            } else {
                                print("Document added with ID: \(ref!.documentID)")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        let alertController = UIAlertController(title: "Oops!", message: "An habit with this name already exists!", preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!) in
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Oops!", message: "Your new habit need a name!", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
        
        newHabitNameTextField.setBottomBorder()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
