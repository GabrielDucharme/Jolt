//
//  DailySessions.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-02-13.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import Foundation
import Charts
import Firebase

enum DailySession {
    typealias dailyEntry = (hour: Double, count: Double)
    
    private static let newSessionValues = [0.0]
    
    static var last12HourSession: [BarChartDataEntry] {
        
        var dailyEntryArray = [BarChartDataEntry]()
        
        let entry1 = BarChartDataEntry(x: Double(9), y: Double(60))
        let entry2 = BarChartDataEntry(x: Double(12), y: Double(25))
        
        dailyEntryArray = [entry1,entry2]
    
        return dailyEntryArray
    
    }
    
    
}
