//
//  OnlineFriendsTableViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-01-23.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase

class OnlineFriendsTableViewController: UITableViewController {
    
    var users: [Member] = []
    var membersUID: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        findUsers()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Online Friend Cell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].name

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Chat View",
        let destination = segue.destination as? ChatViewController,
            let index = tableView.indexPathForSelectedRow?.row {
            destination.memberName = users[index].name
            destination.memberUID = membersUID[index]
        }
        
    }


}

extension OnlineFriendsTableViewController {
    
    func findUsers() {
        var db: Firestore!
        //let userID = Auth.auth().currentUser!.uid
        
        db = Firestore.firestore()
        
        let ref = db.collection("users")
        
        ref.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let newMember = Member(name:"\(document["name"]!)",color: UIColor.blue )
                    self.users.append(newMember)
                    self.membersUID.append("\(document["UID"]!)")
                    
                    DispatchQueue.main.async {
                        // reload data
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
