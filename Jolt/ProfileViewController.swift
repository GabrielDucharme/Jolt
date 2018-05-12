//
//  ProfileViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-07.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let uid = Auth.auth().currentUser?.uid
    var db: Firestore!

    
    // Outlets:
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        setupProfileImage()
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        //userNameLabel.text = "\((Auth.auth().currentUser?.displayName)!)"
        //profileImageView.clipsToBounds = true
        
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] {
           selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        self.dismiss(animated: true) {
            let storageRef = Storage.storage().reference().child("profileImage.png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    self.updateUserProfilePictureWith(url: (metadata?.downloadURLs)!)
                })
            }
            
        }
    }
    
    private func updateUserProfilePictureWith(url: [URL]) {
        
        print("do something here")
        let documentReference = db.document("users/\(uid!)")
        documentReference.setData(["userProvidedPicture" : "\(url[0])"], options: SetOptions.merge())
        
        
    }
    
    func setupProfileImage() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }

    
    @IBAction func logoutButton(_ sender: Any) {
        //User will be logged out
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
