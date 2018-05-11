//
//  HabitTableViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-03-14.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase

class HabitListTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var db:Firestore!
    let userID = Auth.auth().currentUser!.uid
    
    var habitListArray = [Habit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadData()
        checkForUpdates()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        

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
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Archive"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let name = habitListArray[indexPath.row].name
            let collectionReference = db.document("users/\(userID)").collection("Habits")
            let query = collectionReference.whereField("Name", isEqualTo: name)
            query.getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        print(document.documentID)
                        self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData(["Archived" : true])
                        print("Should be archived")
                    }
                }
            })
            
            
            // Remove from table view
            habitListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let name = habitListArray[indexPath.row].name
        let collectionReference = db.document("users/\(userID)").collection("Habits")
        let query = collectionReference.whereField("Name", isEqualTo: name)
        
        let closeAction = UIContextualAction(style: .normal, title:  "Archive", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as archived")
        
            query.getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        print(document.documentID)
                        self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData(["Archived" : true])
                        print("Should be archived")
                    }
                }
            })
            
            self.habitListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    */
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowTimerSegue",
        let destination = segue.destination as? TimerViewController,
        let habitIndex = tableView.indexPathForSelectedRow?.row {
            destination.habitName = habitListArray[habitIndex].name
            //destination.sessionLength = habitArray[habitIndex].sessionLength
            destination.totalLoggedTime = habitListArray[habitIndex].totalTimeLogged
            destination.joltsCount = habitListArray[habitIndex].joltCount
            destination.sessionCount = habitListArray[habitIndex].sessionCount
        }
        
        if let destination = segue.destination as? HabitIJoltsViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                destination.habitName = habitListArray[indexPath.row].name
                //destination.documentID = habitListArray[indexPath.row].
            }
        }
    }


}

extension HabitListTableViewController {
     
    func loadData() {
        db.document("users/\(userID)").collection("Habits").whereField("Archived", isEqualTo: false).order(by: "Created On").getDocuments { (querySnapshot, error) in
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
    
    func checkForUpdates() {
        db.document("users/\(userID)").collection("Habits").whereField("Created On", isGreaterThan: Date()).addSnapshotListener {
            querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
                if diff.type == .added {
                    self.habitListArray.append(Habit(dictionary: diff.document.data())!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the + button to add your first habit."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    /*
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Add Grokkleglob"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "taylor-swift")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Hurray", style: .default))
        present(ac, animated: true)
    }
    */
}
