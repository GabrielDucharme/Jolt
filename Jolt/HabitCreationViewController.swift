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
    
    
    @IBAction func sessionTimeStepperValueChanged(_ sender: Any) {
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
    }
    
    @IBAction func createNewHabitButton(_ sender: UIButton) {
        if newHabitNameTextField.text != "" {
            let newHabit = Habit(name: "\(newHabitNameTextField.text!)", sessionLength: Int(sessionTimeStepper.value), createdOn: Date(), sessionCount: 0, totalTimeLogged: 0, joltCount: 0, archived: false)
            
            var ref:DocumentReference? = nil
            ref = self.db.document("users/\(userID)").collection("Habits").addDocument(data: newHabit.dictionary) {
                error in
                
                if let error = error {
                    print("Erro adding document: \(error.localizedDescription)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.navigationController?.popViewController(animated: true)
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
        
        sessionTimeStepper.value = 15.0
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
        
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
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
