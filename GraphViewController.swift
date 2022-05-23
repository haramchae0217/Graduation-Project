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
    var checkCount: [Double] = [8,5,4,2,1,2,3]
    var strDates: [String] = []
    var todayDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        drawGraph()
        
        calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.reloadData()
    }
    
    func appendDate(date: Date) {
        
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        let monthInfo = Calendar.current.component(.month, from: todayDate)
        let weekInfo = Calendar.current.component(.weekOfMonth, from: todayDate)
        calendarInfo.text = "\(monthInfo)월 \(weekInfo)째주"
        if Calendar.current.component(.weekday, from: todayDate) == 1 {
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: todayDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        } else if Calendar.current.component(.weekday, from: todayDate) == 2 {
            let editDate = Calendar.current.date(byAdding: .day, value: -1, to: todayDate)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        } else if Calendar.current.component(.weekday, from: todayDate) == 3 {
            let editDate = Calendar.current.date(byAdding: .day, value: -2, to: todayDate)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        } else if Calendar.current.component(.weekday, from: todayDate) == 4 {
            let editDate = Calendar.current.date(byAdding: .day, value: -3, to: todayDate)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        } else if Calendar.current.component(.weekday, from: todayDate) == 5 {
            let editDate = Calendar.current.date(byAdding: .day, value: -4, to: todayDate)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        } else if Calendar.current.component(.weekday, from: todayDate) == 6 {
            let editDate = Calendar.current.date(byAdding: .day, value: -5, to: todayDate)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        } else if Calendar.current.component(.weekday, from: todayDate) == 7 {
            let editDate = Calendar.current.date(byAdding: .day, value: -6, to: todayDate)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
        }
        
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
        strDates = []
        let monthInfo = Calendar.current.component(.month, from: date)
        let weekInfo = Calendar.current.component(.weekOfMonth, from: date)
        calendarInfo.text = "\(monthInfo)월 \(weekInfo)째주"
        if Calendar.current.component(.weekday, from: date) == 1 {
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: date)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        } else if Calendar.current.component(.weekday, from: date) == 2 {
            let editDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        } else if Calendar.current.component(.weekday, from: date) == 3 {
            let editDate = Calendar.current.date(byAdding: .day, value: -2, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        } else if Calendar.current.component(.weekday, from: date) == 4 {
            let editDate = Calendar.current.date(byAdding: .day, value: -3, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        } else if Calendar.current.component(.weekday, from: date) == 5 {
            let editDate = Calendar.current.date(byAdding: .day, value: -4, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        } else if Calendar.current.component(.weekday, from: date) == 6 {
            let editDate = Calendar.current.date(byAdding: .day, value: -5, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        } else if Calendar.current.component(.weekday, from: date) == 7 {
            let editDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!
            for i in 0...7 {
                let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
                let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
                strDates.append(dateToStr)
            }
            drawGraph()
        }
        
//        if calendarList.count == 0 {
//            UIAlertController.showAlert(message: "등록된 투두가 없습니다.", vc: self)
//        }
    }
}
