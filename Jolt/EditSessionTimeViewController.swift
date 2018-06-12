//
//  EditSessionTimeViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-05-25.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class EditSessionTimeViewController: UIViewController {

    
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var sessionTimeStepper: UIStepper!
    @IBOutlet weak var habitNameTextField: UITextField!
    
    var sessionTime = Int()
    var habitName = String()
    var onSave: ((_ time: Int, _ name: String) -> ())?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionTimeStepper.value = Double(sessionTime)
        sessionTimeLabel.text = "\(sessionTime)"
        habitNameTextField.placeholder = habitName
        
        hideKeyboardWhenTappedAround()
        
        habitNameTextField.setBottomBorder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sessionStepChange(_ sender: Any) {
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if let habitName = habitNameTextField.text {
            onSave?(Int(sessionTimeStepper.value), habitName)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
