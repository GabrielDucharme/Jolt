//
//  JoltsTableViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-15.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class JoltsTableViewController: UITableViewController {
    
    lazy var model = generateModel()
    lazy var storage = Storage.storage()
    
    var habitName = String()
    var documentId = String()
    var habitDescription = String()
    
    @IBOutlet weak var habitDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitDescriptionLabel.text = habitDescription

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JoltTableViewCell

        // Configure the cell...
        cell.joltContent.text = model[indexPath.row].note
        cell.joltCreatedOnLabel.text = "Created on: \(stringFromDate(model[indexPath.row].createdOn))"
        
        // Load image if any
        let gsReference = storage.reference(forURL: "\(model[indexPath.row].joltImage!)")
        
        gsReference.downloadURL { (url, error) in
            if error != nil {
                print("No url")
            } else {
                
                let imageUrl:URL = url!
                
                DispatchQueue.global(qos: .userInitiated).async {
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData as Data)
                        if let image = image {
                            print(image.size)
                            cell.joltImageView.image = image
                        } else {
                            print("Could not get the image")
                        }
                    }
                }
            }
        }
            

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

extension JoltsTableViewController {
    
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
                                // reload data
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
        
        return dataArray
        
    }
    
}
