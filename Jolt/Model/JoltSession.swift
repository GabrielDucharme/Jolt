//
//  Timer.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-11.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI

struct joltSession {
    
    var habitname: String = ""
    
    var started: Bool = false {
        didSet {
            print("Session started: \(started)")
        }
    }
    var length: Int = 0 {
        willSet(newTime) {
            newTime / 60
        }
        didSet {
            //print("Session started: \(length) minutes")
        }
    }
    
    var finished: Bool = false {
        didSet {
            print("\(habitname) was \(length) minutes")
        }
    }
}

// I don't think this object should handle this function but I don't know!

extension joltSession {
    
    func logData() {
        
        print("....Logging data bip bip bip")
        
        /*
        let uid = Auth.auth().currentUser?.uid
        var docRef : DocumentReference!
        
        docRef = Firestore.firestore().document("users/\(uid!)/habits/\(habitname)")
        
        let dataToSave : [String: Any] = ["Time Logged": "\(length)"]
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("Oh no! Some error \(error.localizedDescription)")
            } else {
                print("User data was saved")
            }
        }
         */
        
        
        
    }
}

/*
 
 sessionLength
 sessionStarted
 sessionFinished
 
 func sendData
 
 */
