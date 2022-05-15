//
//  GraphViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/10.
//

import UIKit
import Charts
import FSCalendar

class GraphViewController: UIViewController {
    
    static var identifier = "GraphVC"

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var barChart: BarChartView!
    
    var calendarList: [ToDo] = []
    var checkCount: [Double] = []
    var dates: [String] = []
    var count: Double = 0
    var todayDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendDate()
//        appendCount()
        drawGraph()
        setCalendar()
        
        calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.reloadData()
    }
    
//    func weekDay() {
//        for i in 1..<8 {
//            Int(todayDate) - i
//            let date = DateFormatter.customDateFormatter.dateToStr(date: todayDate)
//            dates.append(<#T##newElement: String##String#>)
//        }
//    }
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko-KR")
        calendarView.appearance.selectionColor = .systemBlue
    }
    
    func appendDate() {
        for data in MyDB.toDoList {
            let strDate = DateFormatter.customDateFormatter.dateToStr(date: data.startDate)
            dates.append(strDate)
            print(dates)
        }
    }
//
//    func appendCount() {
//        for data in MyDB.toDoList {
//            let checkTrue = data.isChecked
//            if checkTrue == true {
//                count += 1
//            }
//            checkCount.append(count)
//        }
//    }
    
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

extension GraphViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for todo in MyDB.toDoList {
            let toDoEvent = todo.startDate
            
            if toDoEvent == date {
                let count = MyDB.toDoList.filter { todo in
                    todo.startDate == date
                }.count
                checkCount.append(Double(count))
                print(checkCount)
                if count >= 3 {
                    return 3
                } else {
                    return count
                }
            }
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarList = MyDB.toDoList.filter { toDo in
            toDo.startDate == date
        }
        
        if calendarList.count == 0 {
            UIAlertController.showAlert(message: "등록된 투두가 없습니다.", vc: self)
        }
    }
}
