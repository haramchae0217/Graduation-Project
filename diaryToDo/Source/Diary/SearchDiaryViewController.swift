//
//  SearchDiaryViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/28.
//

import UIKit

class SearchDiaryViewController: UIViewController {

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

        configuretableView()
        configuresearchBar()
        configureRightBarButton()
    }
    
    func configureRightBarButton() {
        let cancelButton = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(cancelButton))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc func cancelButton() {
        self.dismiss(animated: true)
    }
    
    func configuretableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func configuresearchBar() {
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
        for i in 0..<searchData.hashTag.count {
            if i == searchData.hashTag.count - 1 {
                hashtags.append("#\(searchData.hashTag[i])")
                break
            }
            
            hashtags.append("#\(searchData.hashTag[i]), ")
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
        self.dismiss(animated: true) // pop으로 전환 -> 그전 present를 push로 변경
//        self.present(selectDiary, animated: true)
        // TODO: -1 ) 검색결과 중 내가 누른 셀에 대한 데이터를 어딘가 저장하기
        // TODO: -2 ) searchVC를 pop해준 뒤, 아래에 있는 diaryVC에 viewWillAppear에서 데이터 업데이트 해주기
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
