//
//  ViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/11.
//

import UIKit

class DiaryViewController: UIViewController {

    var filterHashTag: [Diary] = []
    var hashTag: String = ""
    var moveIndex: Int = 0
    let searchHashTag = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryPictureUIImage: UIImageView!
    @IBOutlet weak var diaryHashTagLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if moveIndex > 0 {
            moveIndex -= 1
            print(moveIndex)
            let recentDiary = MyDB.diaryItem[moveIndex]
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
        if moveIndex <= MyDB.diaryItem.count-1 {
            moveIndex += 1
            print(moveIndex)
            let recentDiary = MyDB.diaryItem[moveIndex]
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
        guard let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: CalendarViewController.identifier) as? CalendarViewController else { return }
        self.present(calendarVC, animated: true)
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
