//
//  GraphViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/10.
//

import UIKit
import Charts
import FSCalendar

enum Weekday: Int {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

class GraphViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var calendarInfo: UILabel!
    
    var calendarList: [ToDo] = []
    var weekTodoList: [ToDo] = []
    var checkCount: [Double] = []
    var dates: [Date] = []
    var strDates: [String] = []
    var todayDate: Date = Date()
    var monthInfo: Int = 0
    var weekInfo: Int = 0
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    var dateFormatType: DateFormatType = .type1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendDate(date: todayDate)
        setCalendar()
        
        calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureDateFormat()
        configureFontAndFontSize()
        calendarView.reloadData()
    }
    
    func configureDateFormat() {
        for data in MyDB.dateFormatList {
            if data.isSelected {
                dateFormatType = data.dateformatType
                break
            }
        }
    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
            }
        }
    }
    
    func appendDate(date: Date) {
        strDates = []
        dates = []
        monthInfo = Calendar.current.component(.month, from: date)
        weekInfo = Calendar.current.component(.weekOfMonth, from: date)
        calendarInfo.text = "\(monthInfo)월 \(weekInfo)째주"
        calendarInfo.font = UIFont(name: font, size: fontSize)
        
        var current: Weekday = .monday
        
        if let currentValue = Weekday.init(rawValue: Calendar.current.component(.weekday, from: date)) {
            current = currentValue
        }
        
        getDateInfo(today: current, date: date)
        
        let count = appendData(datas: dates)
        drawGraph(data: count)
    }
    
    func getDateInfo(today: Weekday, date: Date) {
        let weekdayCount: Int = 7
        var editDate: Date = date
        
        if today != .monday {
            editDate = Calendar.current.date(byAdding: .day, value: -(today.rawValue - 1), to: date)!
        }
        
        for i in 0..<weekdayCount {
            let addDate = Calendar.current.date(byAdding: .day, value: i, to: editDate)!
            let dateToStr = DateFormatter.customDateFormatter.dayToStr(date: addDate)
            strDates.append(dateToStr)
            dates.append(addDate)
        }
    }
    
    func appendData(datas: [Date]) -> [Double] {
        var count: Double = 0
        checkCount = []
        weekTodoList = []
        
        for weekday in datas {
            for everydate in MyDB.toDoList {
                print(weekday,everydate.startDate)
                if DateFormatter.customDateFormatter.dateToStr(date: weekday, type: dateFormatType) == DateFormatter.customDateFormatter.dateToStr(date: everydate.startDate, type: dateFormatType) {
                    weekTodoList.append(everydate)
                }
            }
        }
        
        for weekday in datas {
            for data in weekTodoList {
                if DateFormatter.customDateFormatter.dateToStr(date: weekday, type: dateFormatType) == DateFormatter.customDateFormatter.dateToStr(date: data.startDate, type: dateFormatType) {
                    if data.isChecked == true {
                        count += 1
                    } else {
                        count += 0
                    }
                }
            }
            
            checkCount.append(count)
            count = 0
        }
        
        return checkCount
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko-KR")
        calendarView.appearance.selectionColor = .systemBlue
    }
    
    func drawGraph(data: [Double]) {
        var chartEntry: [ChartDataEntry] = []
        
        for i in 0..<checkCount.count {
            let value = BarChartDataEntry(x: Double(i), y: data[i])
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
        
        barChart.animate(xAxisDuration: 2, yAxisDuration: 2)
        
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
        calendarList = MyDB.toDoList.filter { toDo in toDo.startDate == date }
        
        if Calendar.current.component(.weekOfMonth, from: date) != weekInfo {
            appendDate(date: date)
        }
    }
}
