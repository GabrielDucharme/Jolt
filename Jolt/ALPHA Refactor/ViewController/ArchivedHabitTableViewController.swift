//
//  ArchivedHabitTableViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-02-11.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase

class ArchivedHabitTableViewController: UITableViewController {
    
    var db: Firestore!
    var habitArray = [Habit]()
    
    var listener: ListenerRegistration?
    
    lazy var userID: String = {
        Auth.auth().currentUser!.uid
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        listener?.remove()
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

        // Configure the cell...
        let habit = habitArray[indexPath.row]
        cell.habitNameLabel.text = "\(habit.name.uppercased())"
        cell.habitStartedAtLabel.text = "Archived since: 10 days"
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArchivedHabitTableViewController {
    
    // Firebase Request to fetch archived habits
    
    func loadData() {
        
        listener = db.document("users/\(userID)").collection("Habits").whereField("Archived", isEqualTo: true).order(by: "Created On").addSnapshotListener { (querySnapshot, err) in
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

extension ArchivedHabitTableViewController {
    
    // Enable swipe right to archive
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
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
                        self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").delete()
                    }
                }
            })
            
            // Remove from table view
            habitArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
}
