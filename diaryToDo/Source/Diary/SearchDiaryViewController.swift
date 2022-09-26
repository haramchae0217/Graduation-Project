//
//  SearchDiaryViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/05/28.
//

import UIKit
import RealmSwift

class SearchDiaryViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    var searchDiary: [DiaryDB] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
    let localRealm = try! Realm()
    
    var diaryDBList: [DiaryDB] = []
    var searchImage: [UIImage] = []
    var imageCount: Int = 0
    var dateFormatType: String = ""
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureDateFormat()
        configureFontAndFontSize()
        
        diaryDBList = getDiary()
    }
    
    func configureNavigationController() {
        title = "다이어리 검색"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureDateFormat() {
        let dateType = UserDefaults.standard.string(forKey: SettingType.dateFormat.rawValue) ?? "type3"
        dateFormatType = dateType
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    }
    
    func configureTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func configureSearchBar() {
        let searchHashTag = UISearchController(searchResultsController: nil)
        searchHashTag.searchBar.delegate = self
        searchHashTag.searchResultsUpdater = self
        searchHashTag.searchBar.placeholder = "다이어리 검색"
        searchHashTag.obscuresBackgroundDuringPresentation = false // 같은 뷰컨에 검색 결과를 표시하는것이므로 화면이 흐려지는걸 원치 않음.
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchHashTag
        definesPresentationContext = true // 다른 뷰컨으로 이동시 search bar가 화면에 남아있지 않게 함.
    }
    
    func configureUD() {
        if let imageNumber = UserDefaults.standard.string(forKey: "imageNumber"), let count = Int(imageNumber) {
            imageCount = count
        } else {
            UserDefaults.standard.set("0", forKey: "")
        }
    }
    
    func getDiary() -> [DiaryDB] {
        diaryDBList = []
        return localRealm.objects(DiaryDB.self).map { $0 }.sorted(by: { $0.date < $1.date })
    }
    
    func getSearchImage(diary: DiaryDB) {
        if let image = ImageManager.shared.getImage(name: "\(diary._id).jpg") {
            searchImage.append(image)
        } else {
            UserDefaults.standard.set("0", forKey: "imageNumber")
        }
    }
}

extension SearchDiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDiary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let searchData = searchDiary[indexPath.row]
        var imageList: [UIImage] = []
        var hashtags: String = ""
        
        for data in searchImage {
            imageList.append(data)
        }
    
        let image = imageList[indexPath.row]
        
        for i in 0..<searchData.hashTag.count {
            if i == searchData.hashTag.count - 1 {
                hashtags.append("#\(searchData.hashTag[i])")
                break
            }
            
            hashtags.append("#\(searchData.hashTag[i]), ")
        }
        
        cell.diaryImage.image = image
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
        SelectItem.selectDiary = diary
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchDiaryViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDiary = []
        searchImage = []
    }
}

extension SearchDiaryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            if text != "" {
                searchDiary = []
                searchImage = []
                searchDiary = diaryDBList.filter{ $0.hashTag.map { String($0).lowercased() }.contains(text) }
                for data in self.searchDiary {
                    self.getSearchImage(diary: data)
                }
            }
        }
    }
}
