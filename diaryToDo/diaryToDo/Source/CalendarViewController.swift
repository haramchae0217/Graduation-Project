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
//        if events.contains(date) {
            return 1
//        } else {
//            return 0
//        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        if events.contains(date) {
//            print("이벤트 있음")
//            // 화면 전환 코드, 데이터 리로드 코드
//        }
    }
}
