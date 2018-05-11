//
//  AuthVC.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-05.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class AuthVC: FUIAuthPickerViewController {
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Unlock Your Flow"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup AuthView Here
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // I could put an image here (logo?) using UIImageView instead of UIView
        let imageViewBackground = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        imageViewBackground.backgroundColor = UIColor.blue
        
        view.insertSubview(imageViewBackground, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
