//
//  DiaryViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/05.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var diaryTableView: UITableView!
    
    var filterHashTag: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterHashTag = Diary.diaryList
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        filterHashTag = Diary.diaryList
        diaryTableView.reloadData()
    }
    @IBAction func addDiaryBarButtonItem(_ sender: UIBarButtonItem) {
        guard let addVC = self.storyboard?.instantiateViewController(withIdentifier: "addDiaryVC") as? AddDiaryViewController else { return }
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        let searchHashTag = UISearchController(searchResultsController: nil)
        searchHashTag.searchResultsUpdater = self
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchBar.placeholder = "검색"
        //navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchHashTag
    }
    
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterHashTag.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diaryCell = tableView.dequeueReusableCell(withIdentifier: "diaryTableCell", for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        if !filterHashTag.isEmpty {
            let diary = filterHashTag[indexPath.row]
            diaryCell.diaryContentLabel.text = diary.content
            diaryCell.diaryHashTagLabel.text = diary.hashTag
            diaryCell.diaryPictureImageView.image = diary.picture
            diaryCell.diaryPictureImageView.contentMode = .scaleAspectFill
            diaryCell.diaryDateLabel.text = DateFormatter.customDateFormatter.toStringFromDate(target: diary.date)
        }
        return diaryCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            filterHashTag.remove(at: indexPath.row)
            // 실제 배열 안의 값을 지움
            tableView.deleteRows(at: [indexPath], with: .fade)
            // 사라지는 방향
        } else {
            print("insert")
        }
        // 어디에 있는 줄을 지울것인가
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editDiaryVC = self.storyboard?.instantiateViewController(withIdentifier: "editDiaryVC") as? EditDiaryViewController else { return }
        editDiaryVC.editDiary = Diary.diaryList[indexPath.row]
        editDiaryVC.row = indexPath.row
        self.navigationController?.pushViewController(editDiaryVC, animated: true)
    }
}

extension DiaryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterHashTag = Diary.diaryList.filter{ $0.hashTag.lowercased().map { String($0) }.contains(searchText) }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        diaryTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterHashTag = Diary.diaryList
        diaryTableView.reloadData()
    }
    
    
}
