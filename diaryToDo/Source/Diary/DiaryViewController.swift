//
//  ViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/11.
//

import UIKit
import FSCalendar

class DiaryViewController: UIViewController {

    var filterHashTag: [Diary] = []
    var hashTag: String = ""
    var moveIndex: Int = 0
    let searchHashTag = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryPictureUIImage: UIImageView!
    @IBOutlet weak var diaryHashTagLabel: UILabel!
    @IBOutlet weak var diaryCalendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarSetting()
        diaryCalendarView.isHidden = true
        
        moveIndex = MyDB.diaryItem.count
        print(moveIndex)
        if !MyDB.diaryItem.isEmpty {
            let recentDiary = MyDB.diaryItem[moveIndex-1]
            for word in recentDiary.hashTag {
            hashTag += word
            }
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        }
        
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchResultsUpdater = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveIndex = MyDB.diaryItem.count
        print(moveIndex)
        hashTag = ""
        if !MyDB.diaryItem.isEmpty {
            let recentDiary = MyDB.diaryItem[moveIndex-1]
            for word in recentDiary.hashTag {
            hashTag += word
            }
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        }
    }
    
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        print(moveIndex)
        hashTag = ""
        if moveIndex > 1 {
            moveIndex -= 1
            print(moveIndex)
            let recentDiary = MyDB.diaryItem[moveIndex-1]
            for word in recentDiary.hashTag {
                hashTag += word
            }
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        } else {
            print("더 이상 전으로 갈 수 없습니다.")
        }
           
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        print(moveIndex)
        hashTag = ""
        if moveIndex < MyDB.diaryItem.count {
            moveIndex += 1
            print(moveIndex)
            let recentDiary = MyDB.diaryItem[moveIndex-1]
            for word in recentDiary.hashTag {
                hashTag += word
            }
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        } else {
            print("더 이상 뒤로 갈 수 없습니다.")
        }
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        if diaryCalendarView.isHidden == true {
            diaryCalendarView.isHidden = false
        } else {
            diaryCalendarView.isHidden = true
        }
        calendarSetting()
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
    
    func calendarSetting() {
        diaryCalendarView.delegate = self
        diaryCalendarView.dataSource = self
        
        diaryCalendarView.locale = Locale(identifier: "ko-KR")
        
        diaryCalendarView.appearance.selectionColor = .systemBlue
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
            
            var text: String = ""
            
            for str in diaryList {
                text.append("\(str.hashTag)\n")
            }
            diaryHashTagLabel.text = text
        } else {
            diaryHashTagLabel.text = "등록된 hashtag가 없습니다."
        }
    }
}
