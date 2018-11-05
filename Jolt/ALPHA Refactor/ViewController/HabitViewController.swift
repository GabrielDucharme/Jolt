//
//  HabitViewController.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-07-24.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit

class HabitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    

    @IBOutlet weak var habitTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // habitTableView Setup:
        habitTableView.delegate = self
        habitTableView.dataSource = self
        
        // Empty TableView Setup:
        habitTableView.emptyDataSetSource = self
        habitTableView.emptyDataSetDelegate = self
        habitTableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
}

extension HabitViewController {
    
    // Setup methods for habitTableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = habitTableView.dequeueReusableCell(withIdentifier: "habit", for: indexPath) as! HabitTableViewCell
        
        cell.habitNameLabel.text = "Habit Name"
        
        return cell
    }
    
}

extension HabitTableViewCell {
    
    // Setup methods for DZNEmptyData
    func title(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "Welcome"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the + button to add your first habit."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}
