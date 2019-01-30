//
//  SessionJoltViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-07.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class SessionJoltViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Create Firestore Database and User ID Reference
    var db: Firestore!
    let currentUser = Auth.auth().currentUser
    let userID = Auth.auth().currentUser!.uid
    
    var habitName = String()
    var joltCount = Int()
    var imageReferenceURL = String()
    var imageUploadData = Data()
    
    lazy var storage = Storage.storage()

    @IBOutlet weak var joltTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        print("Habit name: \(habitName)")
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // IBA ACTIONS:
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        joltCount += 1
        logNewJolt()
    }
    
    @IBAction func joltMediaPressed(_ sender: Any) {
        
        
        // Camera permission
        
        
        // Open picture selector
        let vc = UIImagePickerController()
        vc.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let joltImage = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let optimizedImage = joltImage.jpegData(compressionQuality: 30)
        imageUploadData = optimizedImage!
        
        /*
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        */
        
        imageView.image = joltImage
        
    }
    
    func uploadJoltImage(imageData: Data) {
        
        let storageReference = storage.reference()
        
        //let imageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid).jpg")
        let uuid = UUID().uuidString
        let imageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)\(uuid).jpg")
        self.imageReferenceURL = "\(imageRef)"
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
                self.imageView.image = UIImage(data: imageData)
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }
    
    func logNewJolt() {
        
        uploadJoltImage(imageData: imageUploadData)
        
        let joltData = Jolt(note: joltTextView.text ?? "", createdOn: Date(), joltImage: "\(imageReferenceURL)" ).dictionary
        
        let collectionReference = db.document("users/\(userID)").collection("Habits")
        let query = collectionReference.whereField("Name", isEqualTo: habitName)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                print("There is an error")
            } else {
                for document in snapshot!.documents {
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").collection("Jolts").addDocument(data: joltData)
                    
                    self.db.document("users/\(self.userID)").collection("Habits").document("\(document.documentID)").updateData(["Jolt Count" : self.joltCount])
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
