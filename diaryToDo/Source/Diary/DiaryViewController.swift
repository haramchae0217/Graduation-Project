//
//  ViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/11.
//

import UIKit
import FSCalendar

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryPictureUIImage: UIImageView!
    @IBOutlet weak var diaryHashTagLabel: UILabel!
    @IBOutlet weak var diaryCalendarView: FSCalendar!
    
    var filterHashTag: [Diary] = []
    var hashTagList: String = ""
    var moveIndex: Int = 0
    var index: Int = 0
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryCalendarSetting()
        diaryCalendarView.isHidden = true
    
        index = MyDB.diaryItem.endIndex - 1
        selectedDate = MyDB.diaryItem[index].date
        moveIndex = MyDB.diaryItem.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moveIndex = MyDB.diaryItem.count
        hashTagList = ""
        
        if !MyDB.diaryItem.isEmpty {
            let recentDiary = MyDB.diaryItem[moveIndex - 1]
            for word in recentDiary.hashTag {
                hashTagList += word
            }
            
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTagList
            diaryPictureUIImage.image = recentDiary.picture
        }
    }
    
    func diaryCalendarSetting() {
        diaryCalendarView.delegate = self
        diaryCalendarView.dataSource = self
        
        diaryCalendarView.locale = Locale(identifier: "ko-KR")
        diaryCalendarView.appearance.selectionColor = .systemBlue
    }
        
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        let sortedList = MyDB.diaryItem.sorted(by: { $0.date > $1.date })
        hashTagList = ""
        
        var previousDate: Date = selectedDate
        
        for data in sortedList { // 바로 이전 날짜 추출
            if selectedDate > data.date {
                previousDate = data.date
                break
            }
        }
        
        for data in sortedList { // 위에서 추출한 날짜와 db에 날짜가 같다면 데이터를 뽑아와서 저장
            if previousDate == data.date {
                for word in data.hashTag{
                    hashTagList += word
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.date)
                diaryHashTagLabel.text = hashTagList
                diaryPictureUIImage.image = data.picture
                break
            } else {
//                UIAlertController.showAlert(message: "이전 다이어리가 없습니다.", vc: self)
            }
        }
        
        selectedDate = previousDate
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        hashTagList = ""
        
        var nextDate: Date = selectedDate
        
        for data in MyDB.diaryItem { // 바로 이전 날짜 추출
            if selectedDate < data.date {
                nextDate = data.date
                break
            }
        }
        
        for data in MyDB.diaryItem { // 위에서 추출한 날짜와 db에 날짜가 같다면 데이터를 뽑아와서 저장
            if nextDate == data.date {
                for word in data.hashTag{
                    hashTagList += word
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.date)
                diaryHashTagLabel.text = hashTagList
                diaryPictureUIImage.image = data.picture
                break
            } else {
//                UIAlertController.showAlert(message: "다음 다이어리가 없습니다.", vc: self)
            }
        }
        
        selectedDate = nextDate
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        if diaryCalendarView.isHidden == true {
            diaryCalendarView.isHidden = false
        } else {
            diaryCalendarView.isHidden = true
        }
        
        diaryCalendarSetting()
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: SearchDiaryViewController.identfier) as? SearchDiaryViewController else { return }
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true)
//        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func addDiaryButton(_ sender: UIBarButtonItem) {
        guard let addVC = self.storyboard?.instantiateViewController(withIdentifier: AddDiaryViewController.identifier) as? AddDiaryViewController else { return }
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
}


extension DiaryViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for diary in MyDB.diaryItem {
            let diaryEvent = diary.date
            
            if diaryEvent == date {
                let count = MyDB.diaryItem.filter { diary in
                    diary.date == date
                }.count
                
                return count
            }
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let diaryList = MyDB.diaryItem.filter { diary in
            diary.date == date
        }
        
        if diaryList.count > 0 {
            var text = ""
            var image: UIImage = UIImage(named: "cafe1")!
            
            for item in diaryList {
                for i in 0..<item.hashTag.endIndex {
                    text += item.hashTag[i]
                }
                
                image = item.picture
            }
            
            selectedDate = date
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date)
            diaryPictureUIImage.image = image
            diaryHashTagLabel.text = text
        } else {
            UIAlertController.showAlert(message: "등록된 다이어리가 없습니다.", vc: self)
        }
    }
}
