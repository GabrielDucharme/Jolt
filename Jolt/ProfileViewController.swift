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
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupProfileImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        userNameLabel.text = Auth.auth().currentUser?.displayName!
        
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
            
            for subview in profileImage.subviews {
                if let item = subview as? UIImageView {
                    if item.image != nil {
                        item.image = selectedImage
                        print("Changing image")
                    }
                }
            }
        }
        
        self.dismiss(animated: true) {
            let storageRef = Storage.storage().reference().child("User Profile Picture").child("\(self.uid!)").child("profileImage.png")
            
            for subview in self.profileImage.subviews {
                if let item = subview as? UIImageView {
                    
                    if item.image != nil {
                        if let uploadData = UIImageJPEGRepresentation(item.image!, 0.1) {
                            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                self.updateUserProfilePictureWith(url: (metadata?.downloadURLs)!)
                            })
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    private func updateUserProfilePictureWith(url: [URL]) {
        
        let documentReference = db.document("users/\(uid!)")
        documentReference.setData(["userProvidedPicture" : "\(url[0])"], options: SetOptions.merge())
    }
    
    func setupProfileImage() {
        
        profileImage.clipsToBounds = false
        profileImage.backgroundColor = UIColor.clear
        profileImage.layer.shadowColor = UIColor.black.cgColor
        profileImage.layer.shadowOpacity = 0.3
        profileImage.layer.shadowOffset = CGSize.zero
        profileImage.layer.shadowRadius = 7
        profileImage.layer.shadowPath = UIBezierPath(roundedRect: profileImage.bounds, cornerRadius: profileImage.frame.height / 2).cgPath
        
        let myImage = UIImageView(frame: profileImage.bounds)
        myImage.clipsToBounds = true
        myImage.backgroundColor = UIColor.blue
        myImage.layer.cornerRadius = myImage.frame.height / 2
        
        profileImage.addSubview(myImage)
        
        let documentReference = db.document("users/\(uid!)")
        documentReference.getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = snapshot?.data() {
                
                if let url = data["userProvidedPicture"] {
                    
                    print("Testing URL")
                    
                    let userProvidedUrl: URL? = URL(string: "\(url)")
                    
                    URLSession.shared.dataTask(with: userProvidedUrl!) { (data, response, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        DispatchQueue.main.async {
                            print("Changing image on the queue")
                            myImage.image = UIImage(data: data!)
                        }
                        
                        }.resume()
                } else {
                    
                    let profileImageUrl = URL(string: "\(snapshot!.data()!["PhotoUrl"]!)")
                    
                    URLSession.shared.dataTask(with: profileImageUrl!) { (data, response, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        DispatchQueue.main.async {
                            print("Changing image on the queue")
                            myImage.image = UIImage(data: data!)
                        }
                        
                        }.resume()
                }
                
            }
            
        }
        
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
