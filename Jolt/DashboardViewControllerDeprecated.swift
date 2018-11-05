//
//  DashboardViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-05-10.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class DashboardViewControllerDeprecated: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var dashboardCollectionViewDeprecated: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dashboardCollectionViewDeprecated.dequeueReusableCell(withReuseIdentifier: "DashboardCell1", for: indexPath) as! DashCollectionViewCell
        
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardCollectionViewDeprecated.delegate = self
        dashboardCollectionViewDeprecated.dataSource = self

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
