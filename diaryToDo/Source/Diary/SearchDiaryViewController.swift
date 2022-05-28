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
    
    var searchDiary: [Diary] = []
    var hashTag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "다이어리 검색"
        
        searchDiary = MyDB.diaryItem

        tableViewSet()
        searchBarSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTableView.reloadData()
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
        hashTag = ""
        if !searchDiary.isEmpty {
            let searchResult = searchDiary[indexPath.row]
            for data in searchResult.hashTag {
                hashTag += data
            }
            cell.diaryImage.image = searchResult.picture
            cell.diaryHashTag.text = hashTag
            cell.diaryDate.text = DateFormatter.customDateFormatter.dateToStr(date: searchResult.date)
        }
        
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
            searchDiary = MyDB.diaryItem.filter{ $0.hashTag.map { String($0) }.contains(searchText) }
            print("필터링 : ",searchDiary)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDiary = MyDB.diaryItem
        searchTableView.reloadData()
    }
}
