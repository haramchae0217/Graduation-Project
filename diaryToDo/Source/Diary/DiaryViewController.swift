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
    var arr: [Int] = []
    var hashTag: String = ""
    var moveIndex: Int = 0
    var recentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchResultsUpdater = self
        
        diaryCalendarSetting()
        diaryCalendarView.isHidden = true
        
        for i in MyDB.diaryItem.startIndex...MyDB.diaryItem.endIndex - 1 {
            arr.append(i)
        }
        print(arr)
        
        let endIndex = MyDB.diaryItem.endIndex - 1
        recentDate = MyDB.diaryItem[endIndex].date
        moveIndex = MyDB.diaryItem.count
        print(moveIndex)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moveIndex = MyDB.diaryItem.count
        hashTag = ""
        print(moveIndex)
        
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
    
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        print(moveIndex)
        hashTag = ""
        
        if moveIndex > 1 {
            moveIndex -= 1
            print(moveIndex)
            
            let recentDiary = MyDB.diaryItem[moveIndex - 1]
            
            for word in recentDiary.hashTag {
                hashTag += word
            }
            
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        } else {
            print("더 이상 전으로 갈 수 없습니다.")
            UIAlertController.showAlert(message: "이전 다이어리가 없습니다.", vc: self)
        }
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        print(moveIndex)
        hashTag = ""
        
        if moveIndex < MyDB.diaryItem.count {
            moveIndex += 1
            print(moveIndex)
            
            let recentDiary = MyDB.diaryItem[moveIndex - 1]
            
            for word in recentDiary.hashTag {
                hashTag += word
            }
            
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        } else {
            print("더 이상 뒤로 갈 수 없습니다.")
            UIAlertController.showAlert(message: "다음 다이어리가 없습니다.", vc: self)
        }
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
