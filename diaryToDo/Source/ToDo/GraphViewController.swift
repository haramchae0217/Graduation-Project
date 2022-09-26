//
//  GraphViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/10.
//

import UIKit
import Charts
import FSCalendar
import RealmSwift

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
    @IBOutlet weak var weekCountInfo: UILabel!
    
    let localRealm = try! Realm()
    var todoDBList: [ToDoDB] = []
    var calendarList: [ToDoDB] = []
    var weekTodoList: [ToDoDB] = []
    var checkCount: [Double] = []
    var dates: [Date] = []
    var strDates: [String] = []
    var todayDate: Date = Date()
    var monthInfo: Int = 0
    var weekInfo: Int = 0
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    var dateFormatType: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureDateFormat()
        configureFontAndFontSize()
        configureCalendar()
        
        todoDBList = getToDo()
        appendDate(date: todayDate)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.reloadData()
    }
    
    func configureNavigationController() {
        title = "투두 그래프"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureDateFormat() {
        let dateType = UserDefaults.standard.string(forKey: SettingType.dateFormat.rawValue) ?? "type3"
        dateFormatType = dateType
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    }
    
    func getToDo() -> [ToDoDB] {
        return localRealm.objects(ToDoDB.self).map { $0 }
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
        var weekToDoCount: Int = 0
        var weekToDoCompleteCount: Int = 0
        var weekToDoPercent: Int = 0
        checkCount = []
        weekTodoList = []
        
        for weekday in datas {
            for everydate in todoDBList {
                if DateFormatter.customDateFormatter.dateToStr(date: weekday, type: dateFormatType) == DateFormatter.customDateFormatter.dateToStr(date: everydate.startDate, type: dateFormatType) {
                    weekTodoList.append(everydate)
                }
            }
        }
        
        for weekday in datas {
            for data in weekTodoList {
                if DateFormatter.customDateFormatter.dateToStr(date: weekday, type: dateFormatType) == DateFormatter.customDateFormatter.dateToStr(date: data.startDate, type: dateFormatType) {
                    weekToDoCount += 1
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
        
        for data in checkCount {
            weekToDoCompleteCount += Int(data)
        }
        
        weekToDoPercent = Int((Double(weekToDoCompleteCount) / Double(weekToDoCount)) * 100)
        
        weekCountInfo.text = "\(weekToDoCompleteCount) / \(weekToDoCount) \(weekToDoPercent)%"
        weekCountInfo.font = UIFont(name: font, size: fontSize)
        
        return checkCount
    }
    
    func configureCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko-KR")
        
        calendarView.appearance.headerTitleFont = UIFont(name: font, size: fontSize)
        calendarView.appearance.weekdayFont = UIFont(name: font, size: fontSize)
        calendarView.appearance.titleFont = UIFont(name: font, size: fontSize)
        calendarView.appearance.headerTitleColor = UIColor(named: "diaryColor")
        calendarView.appearance.weekdayTextColor = UIColor(named: "diaryColor")
        calendarView.appearance.titlePlaceholderColor = UIColor(named: "diaryColor2")
        calendarView.appearance.titleDefaultColor = UIColor(named: "diaryColor3")
        calendarView.layer.cornerRadius = 16
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
    
        data.append(barGraph)
        barChart.data = data
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: strDates)
        barChart.xAxis.labelPosition = .bottom
        
        barChart.rightAxis.enabled = false
        
        barChart.animate(xAxisDuration: 2, yAxisDuration: 2)
        
    }
}

extension GraphViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for todo in todoDBList {
            let toDoEvent = todo.startDate
            
            if toDoEvent == date {
                let count = todoDBList.filter { todo in
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
        calendarList = todoDBList.filter { toDo in toDo.startDate == date }
        
        if Calendar.current.component(.weekOfMonth, from: date) != weekInfo {
            appendDate(date: date)
        }
    }
}
