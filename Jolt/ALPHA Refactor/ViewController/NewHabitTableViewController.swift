//
//  NewHabitTableViewController.swift
//  Bolts
//
//  Created by Gabriel Ducharme on 2019-05-22.
//

import UIKit
import Firebase

class NewHabitTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Create Firestore Database and User ID Reference
    var db: Firestore!
    let userID = Auth.auth().currentUser!.uid
    
    // Data for pickerview
    var pickerData: [String] = [String]()
    
    // IBOutlets
    @IBOutlet weak var habitNameTF: UITextField!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var sessionTimeStepper: UIStepper!
    @IBOutlet weak var habitDescriptionTextView: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBAction func sessionTimeValueChanged(_ sender: UIStepper) {
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value).description)"
        print("Value is now: \(sessionTimeStepper.value)")
    }
    
    @IBAction func createNewHabitButton(_ sender: UIButton) {
        if habitNameTF.text != "" {
            
            
            //Check if habit name already exist
            
            db.document("users/\(userID)").collection("Habits").getDocuments { (snap, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    
                    var habitNameIsAvailable = true
                    
                    for document in snap!.documents {
                        if self.habitNameTF.text == document.data()["Name"] as? String {
                            print("There is already an habit with this name")
                            habitNameIsAvailable = false
                        }
                    }
                    
                    if habitNameIsAvailable {
                        
                        let newHabit = Habit(name: "\(self.habitNameTF.text!)", description: "\(self.habitDescriptionTextView.text!)", sessionLength: Int(self.sessionTimeStepper.value), createdOn: Timestamp(), sessionCount: 0, totalTimeLogged: 0, joltCount: 0, archived: false)
                        
                        var ref:DocumentReference? = nil
                        ref = self.db.document("users/\(self.userID)").collection("Habits").addDocument(data: newHabit.dictionary) {
                            error in
                            
                            if let error = error {
                                print("Erro adding document: \(error.localizedDescription)")
                            } else {
                                print("Document added with ID: \(ref!.documentID)")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        let alertController = UIAlertController(title: "Oops!", message: "An habit with this name already exists!", preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!) in
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Oops!", message: "Your new habit need a name and a description!", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
        sessionTimeLabel.text = "\(Int(sessionTimeStepper.value))"
        
        habitNameTF.setBottomBorder()
        self.hideKeyboardWhenTappedAround()
        
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        
        pickerData = ["Health", "Exercise", "Learning"]
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

extension NewHabitTableViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
