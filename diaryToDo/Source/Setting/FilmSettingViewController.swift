//
//  FilmSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit
import UniformTypeIdentifiers

class FilmSettingViewController: UIViewController {
    
    @IBOutlet weak var filmTableView: UITableView!
    @IBOutlet weak var filmLabel: UILabel!
    
    var filmList: [(filmName: FilmType, isSelected: Bool)] = [(.film1, false), (.film2, false), (.film3, false), (.film4, false)]
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        configureRightBarButton()
        configureFilmType()
        configureFontAndFontSize()
    }
    
    func configureNavigationController() {
        title = "필름 설정"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureFilmType() {
        // UserDefault에 'film'이라는 키 값에 저장된 값을 꺼내와 filmType에 저장
        let filmType = UserDefaults.standard.string(forKey: SettingType.film.rawValue) ?? "film1"
        
        // 위에 선언한 filmList에 filmType과 일치하는 것만 true로 변경
        for i in 0..<filmList.count {
            if filmList[i].filmName.rawValue == filmType {
                filmList[i].isSelected = true
                break
            }
        }
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        filmLabel.font = UIFont(name: font, size: fontSize)
    }
    
    func configureTableView() {
        filmTableView.dataSource = self
        filmTableView.delegate = self
    }
    
    func configureRightBarButton() {
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func toggleAndReload(index: Int) {
        for i in 0..<filmList.count {
            if index == i {
                if !filmList[i].isSelected {
                    filmList[i].isSelected.toggle()
                }
            } else {
                filmList[i].isSelected = false
            }
        }
        filmTableView.reloadData()
    }
    
    func toImage(filmType: FilmType) -> UIImage {
        let name: String = filmType.rawValue
        return UIImage(named: name) ?? UIImage(systemName: "book.fill")!
    }
    
    func setImageSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setImageNotSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"),for: .normal)
    }
    
    @objc func setDoneButton() {
        let dbData = UserDefaults.standard.string(forKey: SettingType.film.rawValue) ?? "film1"
        var selectData = ""
        
        for data in filmList {
            if data.isSelected {
                selectData = data.filmName.rawValue
            }
        }
        
        if dbData == selectData {
            UIAlertController.warningAlert(message: "변동사항이 없습니다.", viewController: self)
        } else {
            let settingEdit = UIAlertController(title: "⚠️", message: "설정을 변경하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let editButton = UIAlertAction(title: "변경", style: .destructive) { _ in
                
                for film in self.filmList {
                    if film.isSelected {
                        UserDefaults.standard.set(film.filmName.rawValue, forKey: SettingType.film.rawValue)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            settingEdit.addAction(cancelButton)
            settingEdit.addAction(editButton)
            present(settingEdit, animated: true)
        }
    }
    
    @objc func isSelectFilm(_ sender: UIButton) {
        toggleAndReload(index: sender.tag)
    }
}

extension FilmSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filmTableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
        let selectFilm = filmList[indexPath.row]
        
        if selectFilm.isSelected {
            setImageSelect(cell.isSelectFilmButton)
        } else {
            setImageNotSelect(cell.isSelectFilmButton)
        }
        
        cell.filmName.text = selectFilm.filmName.rawValue
        cell.filmName.font = UIFont(name: font, size: fontSize)
        cell.filmImageView.image = toImage(filmType: selectFilm.filmName)
        cell.filmImageView.contentMode = .scaleAspectFit
        cell.isSelectFilmButton.tag = indexPath.row
        cell.isSelectFilmButton.addTarget(self, action: #selector(isSelectFilm), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleAndReload(index: indexPath.row)
    }
}

extension FilmSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
