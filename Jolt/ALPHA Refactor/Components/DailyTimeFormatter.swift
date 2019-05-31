//
//  DailyTimeFormatter.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-02-14.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import Foundation
import Charts

final class DailyTimeFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(
        _ value: Double,
        axis _: AxisBase?
        ) -> String {
        return "9:00"
    }
}
