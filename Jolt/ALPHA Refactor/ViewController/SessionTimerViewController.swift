//
//  SessionTimerViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-05.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class SessionTimerViewController: UIViewController {
    
    // MARK: Proprieties
    var HabitName = ""
    
    // MARK: IBOutlet
    @IBOutlet weak var habitButton: UIButton!
    
    // MARK: IBAction
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editHabitButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        habitButton.setTitle(HabitName, for: .normal)

        // Do any additional setup after loading the view.
    }

}
