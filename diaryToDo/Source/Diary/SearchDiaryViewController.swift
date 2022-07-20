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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "다이어리 검색"

        tableViewSet()
        searchBarSet()
        rightBarButton()
    }
    
    func rightBarButton() {
        let cancelButton = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(cancelButton))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc func cancelButton() {
        self.dismiss(animated: true)
    }
    
    func tableViewSet() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func searchBarSet() {
        let searchHashTag = UISearchController(searchResultsController: nil)
        searchHashTag.searchBar.delegate = self
//        searchHashTag.searchResultsUpdater = self
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
        
        var hashtags: String = ""
        for i in 0..<searchDiary.count {
            if i == searchDiary.count - 1 {
                hashtags.append("#\(searchDiary[i].hashTag)")
                break
            }
            hashtags.append("#\(searchDiary[i].hashTag), ")
        }
        
        cell.diaryImage.image = searchData.picture
        cell.diaryDate.text = DateFormatter.customDateFormatter.dateToStr(date: searchData.date)
        cell.diaryHashTag.text = "\(hashtags)"
        
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
        selectDiary.selectDiary = diary
        selectDiary.diaryType = .search
        print(diary)
        print(selectDiary.selectDiary!)
        print(selectDiary.diaryType)
        self.dismiss(animated: true)
    }
}

extension SearchDiaryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print(text)
            searchDiary = MyDB.diaryItem.filter{ $0.hashTag.contains(text)}
            print(searchDiary)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDiary = []
    }
}

//extension SearchDiaryViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            var matches: [String] = []
//
//        }
//    }
//}
