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
    var onSave: ((_ time: Int, _ name: String) -> ())?
    
    // MARK: IBOUTLET
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var sessionTimeStepper: UIStepper!
    @IBOutlet weak var habitNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionTimeStepper.value = Double(sessionTime)
        sessionTimeLabel.text = "\(sessionTime)"
        habitNameField.placeholder = habitName
        
        hideKeyboardWhenTappedAround()
        
        habitNameField.setBottomBorder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sessionStepValueChanged(_ sender: Any) {
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let habitName = habitNameField.text {
            onSave?(Int(sessionTimeStepper.value), habitName)
        }
        
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
