//
//  WeeklySession.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-02-14.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import Foundation

enum WeeklySession {
    typealias weeklyEntry = (day: String, count: Double)
    
    private static let newSessionValues = [60.0, 45.0, 25.0, 25.0, 120.0, 80.0, 100.0]
    private static let baseValue = 100000.0
    private static let totalValues = [887.0, 930.0, 1131.0, 5930.0, 11181.0, 2171.0, 6123.0, 3145.0, 2771.0, 1171.0, 2019.0, 1101.0, 2881.0, 1743.0]
    
    
    static var totalSession: Double {
        return totalValues.reduce(baseValue, +)
    }
    
    static var last7DaysNewSession: [weeklyEntry] {
        return Array(
            zip(
                DateFormatter().shortWeekdaySymbols.map{$0.uppercased()},
                newSessionValues.reversed()
            )
        )
    }
    
    static var aggregateTotalStreamers: [Double] {
        return totalValues.reduce([baseValue]){
            aggregate, value in aggregate + [aggregate.last! + value]
        }
    }
}
