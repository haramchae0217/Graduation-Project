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
    
    enum DiaryType {
        case basic
        case search
    }
    
    var filterHashTag: [Diary] = []
    var selectDiary: Diary?
    var hashTagList: String = ""
    var diaryCount: Int = 0
    var indexNumber: Int = 0
    var selectedDate: Date = Date()
    var diaryType: DiaryType = .basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCalendarView()
        diaryCalendarView.isHidden = true
    
        indexNumber = MyDB.diaryItem.endIndex - 1
        selectedDate = MyDB.diaryItem[indexNumber].date
        diaryCount = MyDB.diaryItem.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will화면전환")
        print(diaryType)
        print(selectDiary)
        
        diaryCount = MyDB.diaryItem.count
        diaryViewType()
        
    }
    
    func diaryViewType() {
        hashTagList = ""
        
        if diaryType == .search {
            guard let selectDiary = selectDiary else { return }

            for word in selectDiary.hashTag {
                hashTagList += word
            }
            
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: selectDiary.date)
            diaryHashTagLabel.text = hashTagList
            diaryPictureUIImage.image = selectDiary.picture
        } else {
            if !MyDB.diaryItem.isEmpty {
                let recentDiary = MyDB.diaryItem[diaryCount - 1]
                
                for word in recentDiary.hashTag {
                    hashTagList += word
                }
                
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
                diaryHashTagLabel.text = hashTagList
                diaryPictureUIImage.image = recentDiary.picture
            }
        }
    }
    
    func configureCalendarView() {
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
                for i in 0..<data.hashTag.count {
                    if i == data.hashTag.count - 1 {
                        hashTagList.append("#\(data.hashTag[i])")
                        break
                    }
                    hashTagList.append("#\(data.hashTag[i]), ")
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.date)
                diaryHashTagLabel.text = "\(hashTagList)"
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
                for i in 0..<data.hashTag.count {
                    if i == data.hashTag.count - 1 {
                        hashTagList.append("#\(data.hashTag[i])")
                        break
                    }
                    hashTagList.append("#\(data.hashTag[i]), ")
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.date)
                diaryHashTagLabel.text = "\(hashTagList)"
                diaryPictureUIImage.image = data.picture
                break
            } else {
//                UIAlertController.showAlert(message: "다음 다이어리가 없습니다.", vc: self)
            }
        }
        
        selectedDate = nextDate
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        diaryCalendarView.isHidden.toggle()
        configureCalendarView()
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        guard let searchNC = self.storyboard?.instantiateViewController(withIdentifier: "SearchNC") as? UINavigationController else { return }
        searchNC.modalPresentationStyle = .fullScreen
        self.present(searchNC, animated: true)
    }
    
    @IBAction func addDiaryButton(_ sender: UIBarButtonItem) {
        guard let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDiaryVC") as? AddDiaryViewController else { return }
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
