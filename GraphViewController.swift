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
    @IBOutlet weak var calendarInfo: UILabel!
    
    var calendarList: [ToDo] = []
    var checkCount: [Double] = []
    var dates: [Date] = []
    var strDates: [String] = []
    var todayDate: Date = Date()
    var monthInfo: Int = 0
    var weekInfo: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendDate(date: todayDate)
        setCalendar()
        
        calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.reloadData()
    }
    
    func appendDate(date: Date) {
        strDates = []
        dates = []
        checkCount = []
        monthInfo = Calendar.current.component(.month, from: date)
        weekInfo = Calendar.current.component(.weekOfMonth, from: date)
        calendarInfo.text = "\(monthInfo)월 \(weekInfo)째주"
        if Calendar.current.component(.weekday, from: date) == 1 {
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: date)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        } else if Calendar.current.component(.weekday, from: date) == 2 {
            let editDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        } else if Calendar.current.component(.weekday, from: date) == 3 {
            let editDate = Calendar.current.date(byAdding: .day, value: -2, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        } else if Calendar.current.component(.weekday, from: date) == 4 {
            let editDate = Calendar.current.date(byAdding: .day, value: -3, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        } else if Calendar.current.component(.weekday, from: date) == 5 {
            let editDate = Calendar.current.date(byAdding: .day, value: -4, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        } else if Calendar.current.component(.weekday, from: date) == 6 {
            let editDate = Calendar.current.date(byAdding: .day, value: -5, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        } else if Calendar.current.component(.weekday, from: date) == 7 {
            let editDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
                dates.append(addDate)
            }
        }
        appendData(datas: dates)
        drawGraph()
    }
    
    func appendData(datas: [Date]) {
        var count: Double = 0
        for data in datas {
            for date in MyDB.toDoList {
                if data == date.startDate {
                    if date.isChecked == true {
                        count += 1
                    } else {
                        count += 0
                    }
                    checkCount.append(count)
                    count = 0
                }
            }
        }
        print(checkCount)
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko-KR")
        calendarView.appearance.selectionColor = .systemBlue
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
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: strDates)
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
        if Calendar.current.component(.weekOfMonth, from: date) != weekInfo {
            appendDate(date: date)
        }
    }
}
