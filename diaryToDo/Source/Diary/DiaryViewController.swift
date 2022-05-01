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
    
    let searchHashTag = UISearchController(searchResultsController: nil)
    
    var filterHashTag: [Diary] = []
    var dayArr: [Int] = []
    var hashTag: String = ""
    var moveIndex: Int = 0
    var recentDate: Date = Date()
    var currentDiary: Diary?
    var moveType: MoveType = .next
    
    enum MoveType{
        case previous
        case next
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchResultsUpdater = self
        
        diaryCalendarSetting()
        diaryCalendarView.isHidden = true
    
        moveIndex = MyDB.diaryItem.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moveIndex = MyDB.diaryItem.count
        hashTag = ""
        
        if !MyDB.diaryItem.isEmpty {
            let recentDiary = MyDB.diaryItem[moveIndex - 1]
            for word in recentDiary.hashTag {
            hashTag += word
            }
            
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        }
    }
    
    func diaryCalendarSetting() {
        diaryCalendarView.delegate = self
        diaryCalendarView.dataSource = self
        
        diaryCalendarView.locale = Locale(identifier: "ko-KR")
        diaryCalendarView.appearance.selectionColor = .systemBlue
    }
    
//    -현재 눌린 날짜를 기준으로 날짜 정보를 1 증가
//    -증가시킨 날짜에 데이터가 있나 체크
//    -데이터가 있거나 그 달의 마지막 날짜까지 증가
//    -데이터가 있다면 증가를 멈추고 화면에 보여주기
//    -그 달의 마지막 날짜인데 데이터가 없다면 얼럿
    
    func moveDiary() {
        
        for item in MyDB.diaryItem {
            let day = item.date
            let diaryList = MyDB.diaryItem.filter { diary in
                diary.date == day
            }
            print(diaryList)
        }
        
        
        let stringDate = DateFormatter.customDateFormatter.dayDate(date: recentDate)
        let intDate = Int(stringDate)!
        if moveType == .previous {
            for dayDate in (1 ... intDate).reversed() {
                for i in dayArr {
                    if dayDate == i {
                        print(dayDate)
                        print(i)
                    }
                }
            }
        }else if moveType == .next {
            for dayDate in (1 ... intDate) {
                for i in dayArr {
                    if dayDate == i {
                        print(dayDate)
                        print(i)
                    }
                }
            }
        }
    }
    
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        moveType = .previous
        moveDiary()
        hashTag = ""
        
//        if moveIndex > 1 {
//            moveIndex -= 1
//            print(moveIndex)
//
//            let recentDiary = MyDB.diaryItem[moveIndex - 1]
//
//            for word in recentDiary.hashTag {
//                hashTag += word
//            }
            
//            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
//            diaryHashTagLabel.text = hashTag
//            diaryPictureUIImage.image = recentDiary.picture
//        } else {
//            print("더 이상 전으로 갈 수 없습니다.")
//            UIAlertController.showAlert(message: "이전 다이어리가 없습니다.", vc: self)
//        }
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        moveType = .next
        moveDiary()
        hashTag = ""
        
        
        
//        if moveIndex < MyDB.diaryItem.count {
//            moveIndex += 1
//            print(moveIndex)
//
//            let recentDiary = MyDB.diaryItem[moveIndex - 1]
//
//            for word in recentDiary.hashTag {
//                hashTag += word
//            }
//
//            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
//            diaryHashTagLabel.text = hashTag
//            diaryPictureUIImage.image = recentDiary.picture
//        } else {
//            print("더 이상 뒤로 갈 수 없습니다.")
//            UIAlertController.showAlert(message: "다음 다이어리가 없습니다.", vc: self)
//        }
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
        setupSearchBar()
        navigationItem.searchController = searchHashTag
    }
    
    func setupSearchBar() {
        searchHashTag.hidesNavigationBarDuringPresentation = false
        searchHashTag.searchBar.placeholder = "검색"
    }
    
    @IBAction func addDiaryButton(_ sender: UIBarButtonItem) {
        guard let addVC = self.storyboard?.instantiateViewController(withIdentifier: AddDiaryViewController.identifier) as? AddDiaryViewController else { return }
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
}

extension DiaryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterHashTag = MyDB.diaryItem.filter{ $0.hashTag.map { String($0) }.contains(searchText) }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
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
            
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date)
            diaryPictureUIImage.image = image
            diaryHashTagLabel.text = text
        } else {
            UIAlertController.showAlert(message: "등록된 다이어리가 없습니다.", vc: self)
        }
    }
}
