//
//  ArchivedHabitTableViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-05-02.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase

class ArchivedHabitTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var db:Firestore!
    let userID = Auth.auth().currentUser!.uid
    
    var habitListArray = [Habit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadData()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return habitListArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Habit Cell", for: indexPath) as? HabitTableViewCell
        
        let habit = habitListArray[indexPath.row]
        cell?.habitNameLabel.text = "\(habit.name)"
        cell?.habitStartedAtLabel.text = "Started: \(stringFromDate(habit.createdOn))"
        
        return cell!
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let name = habitListArray[indexPath.row].name
            let collectionReference = db.document("users/\(userID)").collection("Habits")
            let query = collectionReference.whereField("Name", isEqualTo: name)
            query.getDocuments(completion: { (snapshot, error) in
                if let error =  error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        print(document.documentID)
                        self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").delete()
                        print("Should be deleted")
                    }
                }
            })
            
            
            habitListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArchivedHabitTableViewController {
    
    func loadData() {
        db.document("users/\(userID)").collection("Habits").whereField("Archived", isEqualTo: true).order(by: "Created On").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                
                self.habitListArray = querySnapshot!.documents.compactMap({Habit(dictionary: $0.data())})
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
