//
//  SessionJoltViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-07.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

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
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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

        // Open picture selector
        let vc = UIImagePickerController()
        vc.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
            vc.sourceType = .photoLibrary
        } else {
            vc.sourceType = .photoLibrary
        }
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    @IBAction func videoPressed(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
            vc.mediaTypes = [kUTTypeMovie as String]
        } else {
            print("did not detect video camera")
            vc.sourceType = .savedPhotosAlbum
        }
        vc.allowsEditing = true
        vc.videoQuality = .typeHigh
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let joltImage = info[.editedImage] as? UIImage {
            let optimizedImage = joltImage.jpegData(compressionQuality: 30)
            imageUploadData = optimizedImage!
            imageView.image = joltImage
        }
        
        if let joltVideo = info[UIImagePickerController.InfoKey.mediaType] as? String,
            joltVideo == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
            
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
                print("Here is the file URL: ", videoURL)
                
                // Need to update the Upload function to take into account both video and images
                let videoData = NSData(contentsOf: videoURL as URL)
                
                let storageReference = storage.reference()
                let uuid = UUID().uuidString
                let videoRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)\(uuid).mov")
                self.imageReferenceURL = "\(videoRef)"
                
                let uploadMetaData = StorageMetadata()
                uploadMetaData.contentType = "video/mov"
                
                videoRef.putData(videoData as! Data, metadata: uploadMetaData) { (uploadedImageMeta, error) in
                    
                    if error != nil
                    {
                        print("Error took place \(String(describing: error?.localizedDescription))")
                        return
                    } else {
                        
                        self.imageView.image = UIImage(data: videoData as! Data)
                        
                        print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                    }
                }
            }
            
            
            imageView.backgroundColor = .red
        }
        
        /*
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        */
        
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
        
        let date = Date()
        let timeStamp = Timestamp(date: date)
        
        let joltData = Jolt(note: joltTextView.text ?? "", createdOn: timeStamp, joltImage: "\(imageReferenceURL)" ).dictionary
        
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
