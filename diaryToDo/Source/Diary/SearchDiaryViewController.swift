//
//  SearchDiaryViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/28.
//

import UIKit

class SearchDiaryViewController: UIViewController {
    
    static let identfier = "SearchVC"

    @IBOutlet weak var searchTableView: UITableView!
    
    var searchDiary: [Diary] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    var hashTag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "다이어리 검색"

        tableViewSet()
        searchBarSet()
    }
    
    func tableViewSet() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func searchBarSet() {
        let searchHashTag = UISearchController(searchResultsController: nil)
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchResultsUpdater = self
        searchHashTag.searchBar.placeholder = "다이어리 검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchHashTag
    }
}

extension SearchDiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDiary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let searchData = searchDiary[indexPath.row]
        hashTag = ""
        for data in searchData.hashTag {
            hashTag += data
        }

        cell.diaryImage.image = searchData.picture
        cell.diaryDate.text = DateFormatter.customDateFormatter.dateToStr(date: searchData.date)
        cell.diaryHashTag.text = hashTag
        
        return cell
    }
}

extension SearchDiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectDiary = storyboard?.instantiateViewController(withIdentifier: "diaryVC") as? DiaryViewController else { return }
        let diary = searchDiary[indexPath.row]
        selectDiary.diaryPictureUIImage.image = diary.picture
        selectDiary.diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: diary.date)
        selectDiary.diaryHashTagLabel.text = hashTag
        
        self.navigationController?.pushViewController(selectDiary, animated: true)
    }
}

extension SearchDiaryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print("검색어 : ",searchText)
            searchDiary = MyDB.diaryItem.filter{ $0.content.map { String($0) }.contains(searchText) }
            print("필터링 : ",searchDiary)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchResult = searchBar.text!
//        searchDiary = MyDB.diaryItem.filter{ $0.content.map { String($0) }.contains(searchResult) }
//        print(searchResult)
//        print(searchDiary)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDiary = []
    }
}
