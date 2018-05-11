//
//  HabitIJoltsViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-04-28.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class HabitIJoltsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var HabitNameLabel: UILabel!
    @IBOutlet weak var joltTableView: UITableView!
    
    lazy var model = generateModel()
    
    var habitName = String()
    var documentID = String()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        HabitNameLabel.text = habitName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HabitNAme \(habitName)")
    }

}

extension HabitIJoltsViewController {
    
    // TableView Func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JoltTableViewCell
        
        cell.joltContent.text = model[indexPath.row].note
        cell.joltCreatedOnLabel.text = "Created on: \(stringFromDate(model[indexPath.row].createdOn))"
        
        return cell
    }
    
    //FireStore Data
    
    func generateModel() -> [Jolt] {
        
        var dataArray = [Jolt]()
        
        var db: Firestore!
        let userID = Auth.auth().currentUser!.uid
        
        db = Firestore.firestore()
        
        
        let collectionRef = db.document("users/\(userID)").collection("Habits")
        let query = collectionRef.whereField("Name", isEqualTo: "\(habitName)")
        
        query.getDocuments { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snap!.documents {
                    print(document.documentID)
                    
                    db.document("users/\(userID)").collection("Habits").document("\(document.documentID)").collection("Jolts").getDocuments { (snap, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            dataArray = snap!.documents.compactMap({Jolt(dictionary: $0.data())})
                            self.model = dataArray
                            
                            DispatchQueue.main.async {
                                self.joltTableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
        
        
        return dataArray
    }
    
}

