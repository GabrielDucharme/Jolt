//
//  AuthVC.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-05.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import FirebaseUI

class AuthVC: FUIAuthPickerViewController, CAAnimationDelegate {
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Jolt Login"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Setup Logo view
        let image = UIImage(named: "Jolt")
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: (UIScreen.main.bounds.midX - 25), y: 200, width: 50, height: 50)
        
        view.insertSubview(imageView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
