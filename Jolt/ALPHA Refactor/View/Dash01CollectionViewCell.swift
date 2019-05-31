//
//  Dash01CollectionViewCell.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-07-19.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Charts
import Firebase

class Dash01CollectionViewCell: UICollectionViewCell, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "test"
    }
    
    @IBOutlet weak var barChartView: BarChartView! {
        didSet {
            //barChartView.configureDefaults()
            barChartView.xAxis.labelPosition = .bottom
            barChartView.xAxis.granularity = 1
            
            var data = firebaseDailySessionData(arg: true) { (success, barData, timeOfSession) in
                if success {
                    print("Bar Data:\(barData)")
                    
                    //let timeOfDayArray = timeOfSession
                    //self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:timeOfDayArray)
                    
                    
                    //Mockup Data --
                    
                    let mDataEntry = BarChartDataEntry(x: 10, y: 10)
                    let mDataEntry2 = BarChartDataEntry(x: 30, yValues: [20])
                    
                    let mDataset = BarChartDataSet(values: [mDataEntry,mDataEntry2], label: "Test Label")
                    mDataset.colors = [.red]
                    
                    let mDataEntry3 = BarChartDataEntry(x: 20, y: 50)
                    let mDataEntry4 = BarChartDataEntry(x: 50, yValues: [300])
                    
                    let mDataset2 = BarChartDataSet(values: [mDataEntry3,mDataEntry4], label: "Test Label 2")
                    
                    let mBarChartData = BarChartData(dataSets: [mDataset,mDataset2])
                    
                    mBarChartData.barWidth = 2
                    
                    self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["9:00"])
                    self.barChartView.xAxis.valueFormatter = self
                    self.barChartView.leftAxis.enabled = false
                    self.barChartView.rightAxis.enabled = false
                    self.barChartView.xAxis.drawAxisLineEnabled = false
                    self.barChartView.data = mBarChartData
                    
                    // -- End mockup data
                    
                    
                    //self.barChartView.data = barData
                } else {
                    print("false")
                }
            }
        }
    }
    
    func setBarChart(dataPoints: [String], values: [Double]) -> BarChartData {
        
        var dataEntries: [BarChartDataSet] = []
        
        //var colorArray = [UIColor.red,UIColor.blue,UIColor.black,UIColor.yellow]
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataSet(values: [BarChartDataEntry(x: Double(i), y: values[i])], label: dataPoints[i])
            
            dataEntries.append(dataEntry)
            //dataEntries[i].colors = [colorArray[i]]
        }
        
        let barChartData = BarChartData(dataSets: dataEntries)
        
        barChartData.barWidth = 0.1
        
        return barChartData
        
    }
}

private extension BarLineChartViewBase {
    func configureDefaults() {
        chartDescription?.enabled = false
        legend.enabled = true
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        for axis  in [xAxis, leftAxis] {
            axis.drawAxisLineEnabled = false
            axis.drawGridLinesEnabled = false
        }
        leftAxis.labelTextColor = .white
        rightAxis.enabled = false
        leftAxis.enabled = false
    }
}

private extension Dash01CollectionViewCell {
    
    func firebaseDailySessionData(arg: Bool, completion: @escaping (Bool, BarChartData, [String]) -> ())  {
        
        print("First line of code executed")
        
        //let timeOfDayArray = ["9:00", "11:00", "13:00", "21:00"]
        
        var db: Firestore!
        //let currentUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser!.uid
        
        db = Firestore.firestore()
        
        var dataPointName: [String] = []
        var dataPointValue: [Double] = []
        
        var data = setBarChart(dataPoints: dataPointName, values: dataPointValue)
        
        let collectionReference = db.document("users/\(userID)").collection("Habits")
        
        
        collectionReference.getDocuments { (querySnap, err) in
            if let error = err {
                print(error.localizedDescription)
                print("There was an error in Dash01ViewCell")
            } else {
                for document in (querySnap?.documents)! {
                    let documentReference = db.document("users/\(userID)").collection("Habits").document("\(document.documentID)").collection("Session")
                    let startOfDay = Calendar.current.startOfDay(for: Date())
                    let timeStamp = Timestamp.init(date: startOfDay)
                    let habitName = document["Name"]!
                    var timeStringArray = [String]()
                    print("This is date: \(startOfDay)")
                    let query = documentReference.whereField("Created On", isGreaterThan: timeStamp)
                    query.getDocuments(completion: { (querySnap, err) in
                        if let error = err {
                            print(error.localizedDescription)
                            print("There was an error in Dash01ViewCell")
                        } else {
                            
                            for document in querySnap!.documents {
                                
                                //print("Document you are searching for: \(document.data())")
                                
                                let timeStamp = document["Created On"] as! Timestamp
                                let sessionLength = document["Session Length"] as! Int

        
                                let timeString = "9:00"
                                timeStringArray.append(timeString)
                                
                                //print("Session time = \(date)")
                                
                                dataPointValue.append(Double(sessionLength))
                                dataPointName.append("\(habitName)")
                                
                                //print("DataPointValue: \(dataPointValue)")
                                //print("DataPointName: \(dataPointName)")
                                
                                //dataPointName = Array(Set(dataPointName))
                                //print("DataPointValue after converting to set: \(dataPointValue)")
                                //print("DataPointName: \(dataPointName)")
                                
                                data = self.setBarChart(dataPoints: dataPointName, values: dataPointValue)
                                completion(arg, data, timeStringArray)
                            }
                            
                        }
                    })
                }
            }
        }
        print("Probably waiting for data")
    }
}


