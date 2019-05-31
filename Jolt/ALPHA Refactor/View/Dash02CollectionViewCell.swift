//
//  Dash02CollectionViewCell.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-11-27.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import UIKit
import Charts

class Dash02CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var barChartView: BarChartView! {
        didSet {
            barChartView.configureDefaults()
            barChartView.xAxis.labelPosition = .bottom
            barChartView.xAxis.valueFormatter = DayNameFormatter()
            barChartView.data = {
                let dataSet = BarChartDataSet(
                    values: WeeklySession.last7DaysNewSession
                        .enumerated()
                        .map{
                            dayIndex, newSession in BarChartDataEntry(
                                x: Double(dayIndex),
                                y: newSession.count)
                    }
                    ,
                    label: "Weekly Session Time"
                )
                let chartColor = NSUIColor(hue: 18.0, saturation: 0.64, brightness: 0.59, alpha: 1.0)
                dataSet.colors = [chartColor]
                
                let data = BarChartData(dataSet: dataSet)
                data.setDrawValues(true)
                data.barWidth = 0.7
                return data
            }()
        }
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
