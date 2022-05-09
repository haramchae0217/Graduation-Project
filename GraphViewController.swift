//
//  GraphViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/10.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    static var identifier = "GraphVC"

    @IBOutlet weak var barChart: BarChartView!
    
    var checkCount: [Double] = [3.3, 2.4, 11.4, 7.6, 4.4, 8.4, 5.5]
    var dates: [String] = ["1월","2월","3월","4월","5월","6월","7월"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawGraph()
    }
    
    func drawGraph() {
        var chartEntry: [ChartDataEntry] = []
        
        for i in 0..<checkCount.count {
            let value = BarChartDataEntry(x: Double(i), y: checkCount[i])
            chartEntry.append(value)
        }
        
        let barGraph = BarChartDataSet(entries: chartEntry, label: "성공 갯수")
        barGraph.colors = [.systemPink]
        
        let data = BarChartData()
        data.addDataSet(barGraph)
        barChart.data = data
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        barChart.xAxis.labelPosition = .bottom
        
        barChart.rightAxis.enabled = false
        
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        
    }
   

}
