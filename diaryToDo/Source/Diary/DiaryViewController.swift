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
    let searchHashTag = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryPictureUIImage: UIImageView!
    @IBOutlet weak var diaryHashTagLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !MyDB.diaryItem.isEmpty {
            let recentDiary = MyDB.diaryItem[MyDB.diaryItem.count-1]
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
        hashTag = ""
        
        if !MyDB.diaryItem.isEmpty {
            let recentDiary = MyDB.diaryItem[MyDB.diaryItem.count-1]
            
            for word in recentDiary.hashTag {
            hashTag += word
            }
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
            diaryHashTagLabel.text = hashTag
            diaryPictureUIImage.image = recentDiary.picture
        }
    }
    
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
    
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
