//
//  HabitTableViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-07-26.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase

class HabitTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var db:Firestore!
    
    var habitArray = [Habit]()
    
    lazy var userID: String = {
        Auth.auth().currentUser!.uid
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Setup
        db = Firestore.firestore()
        loadData()
        
        // Empty TableView Setup:
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return habitArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habit cell", for: indexPath) as! HabitTableViewCell
        
        let habit = habitArray[indexPath.row]
        cell.habitNameLabel.text = "\(habit.name)"
        cell.habitStartedAtLabel.text = "Started: \(stringFromDate(habit.createdOn))"
        
        return cell
    }

}

extension HabitTableViewController {
    
    // Setup methods for DZNEmptyData
    func title(forEmptyDataSet _: UIScrollView) -> NSAttributedString? {
        let str = "Welcome"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the + button to add your first habit."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}

extension HabitTableViewController {
    
    // Firebase Request
    // ** NOTES ** Should I set a snapshot listener? If I change view to add an habit, will
    // it update automatically?
    func loadData() {
        
        db.document("users/\(userID)").collection("Habits").whereField("Archived", isEqualTo: false).order(by: "Created On").addSnapshotListener { (querySnapshot, err) in
            if let error = err {
                print("\(error.localizedDescription)")
            } else {
                
                self.habitArray = querySnapshot!.documents.compactMap({Habit(dictionary: $0.data())})
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension HabitTableViewController {
    
    // Enable swipe right to archive
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Archive"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let name = habitArray[indexPath.row].name
            let collectionReference = db.document("users/\(userID)").collection("Habits")
            let query = collectionReference.whereField("Name", isEqualTo: name)
            
            query.getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData(["Archived" : true])
                    }
                }
            })
            
            // Remove from table view
            habitArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    }
}