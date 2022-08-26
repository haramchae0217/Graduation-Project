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
    var dateFormatType: DateFormatType = .type1
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "다이어리 검색"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")

        configureTableView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureDateFormat()
        configureFontAndFontSize()
    }
    
    func configureDateFormat() {
        for data in MyDB.dateFormatList {
            if data.isSelected {
                dateFormatType = data.dateformatType
                break
            }
        }
    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
                break
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
                break
            }
        }
    }
    
    func configureTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func configureSearchBar() {
        let searchHashTag = UISearchController(searchResultsController: nil)
        searchHashTag.searchBar.delegate = self
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
        cell.diaryDate.text = DateFormatter.customDateFormatter.dateToStr(date: searchData.date, type: dateFormatType)
        cell.diaryDate.font = UIFont(name: font, size: fontSize)
        cell.diaryHashTag.text = "\(hashtags)"
        cell.diaryHashTag.font = UIFont(name: font, size: fontSize)
        
        return cell
    }
}

extension SearchDiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = searchDiary[indexPath.row]
        MyDB.selectDiary = diary
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchDiaryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchDiary = MyDB.diaryItem.filter{ $0.hashTag.contains(text)}
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDiary = []
    }
}
