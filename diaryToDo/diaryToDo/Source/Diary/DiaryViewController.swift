//
//  ViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/11.
//

import UIKit

class DiaryViewController: UIViewController {

    var filterHashTag: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        let searchHashTag = UISearchController(searchResultsController: nil)
        searchHashTag.searchResultsUpdater = self
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchBar.placeholder = "검색"
        navigationItem.searchController = searchHashTag
    }
    
    @IBAction func addDiaryBarButton(_ sender: UIBarButtonItem) {
        guard let addVC = self.storyboard?.instantiateViewController(withIdentifier: AddDiaryViewController.identifier) as? AddDiaryViewController else { return }
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
}

extension DiaryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterHashTag = Diary.diaryItem.filter{ $0.hashTag.lowercased().map { String($0) }.contains(searchText) }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
}
