//
//  FilmSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FilmSettingViewController: UIViewController {
    
    @IBOutlet weak var filmTableView: UITableView!
    @IBOutlet weak var filmLabel: UILabel!
    
    var filmList = MyDB.filmList
    var selectedFilm: FilmType = .film1
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
        
        configureTableView()
        configureRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFontAndFontSize()
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
                filmLabel.font = UIFont(name: font, size: fontSize)
                break
            }
        }
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
        var dbData = ""
        var selectData = ""
        for data in MyDB.filmList {
            if data.isSelected {
                dbData = data.filmName.rawValue
            }
        }
        
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
                MyDB.filmList = self.filmList
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
