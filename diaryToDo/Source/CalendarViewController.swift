//
//  CalendarViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var diaryCalendarView: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var toDoLabel: UILabel!
    
    static let identifier = "calendarVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarSetting()

        let rightBarButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneClickedButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func doneClickedButton() {
        self.dismiss(animated: true)
    }
    
    func calendarSetting() {
        diaryCalendarView.delegate = self
        diaryCalendarView.dataSource = self
        
        diaryCalendarView.locale = Locale(identifier: "ko-KR")
        
        diaryCalendarView.appearance.selectionColor = .systemPink
        
    }

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for todo in MyDB.ToDoList {
            let toDoEvent = todo.startDate
            if toDoEvent == date {
                let count = MyDB.ToDoList.filter { todo in
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
        dateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date)
        
        let toDoList = MyDB.ToDoList.filter { toDo in
            toDo.startDate == date
        }
        if toDoList.count > 0 {
            
            var text: String = ""
            
            for str in toDoList {
                text.append("\(str.title)\n")
            }
            toDoLabel.text = text
        } else {
            toDoLabel.text = "등록된 ToDo가 없습니다."
        }
    }
}
