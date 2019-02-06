//
//  SessionEditViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-09.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class SessionEditViewController: UIViewController {

    // Proprieties
    var sessionTime = Int()
    var habitName = String()
    var habitDescription = String()
    var onSave: ((_ time: Int, _ name: String, _ description: String) -> ())?
    
    // MARK: IBOUTLET
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var sessionTimeStepper: UIStepper!
    @IBOutlet weak var habitNameField: UITextField!
    @IBOutlet weak var habitDescriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionTimeStepper.value = Double(sessionTime)
        sessionTimeLabel.text = "\(sessionTime)"
        habitNameField.placeholder = habitName
        habitDescriptionField.placeholder = habitDescription
        
        hideKeyboardWhenTappedAround()
        
        habitNameField.setBottomBorder()
        habitDescriptionField.setBottomBorder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sessionStepValueChanged(_ sender: Any) {
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        /*
        if let habitName = habitNameField.text {
            onSave?(Int(sessionTimeStepper.value), habitName, habitDescription)
        }
        */
        var newHabitName = habitName
        var newHabitDescription = habitDescription
        
        if let habitName = habitNameField.text {
            if habitName != "" {
                newHabitName = habitName
            } else {
                print("Habit name is empty")
            }
        }
        
        if let habitDescription = habitDescriptionField.text {
            if habitDescription != "" {
                newHabitDescription = habitDescription
            } else {
                print("Habit description is empty")
            }
        }
        
        print(newHabitName)
        print(newHabitDescription)
        
        onSave?(Int(sessionTimeStepper.value), newHabitName, newHabitDescription)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
