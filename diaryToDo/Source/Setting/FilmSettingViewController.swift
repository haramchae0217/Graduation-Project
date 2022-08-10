//
//  FilmSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

/*
 TODO:
 - 바뀐 필름 적용하기 -> 
 */

class FilmSettingViewController: UIViewController {
    
    @IBOutlet weak var filmTableView: UITableView!
    
    var filmList = MyDB.filmList
    var selectedFilm: FilmType = .film1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filmTableView.dataSource = self
        filmTableView.delegate = self
        
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
        MyDB.filmList = filmList
        self.navigationController?.popViewController(animated: true)
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
        
        cell.isSelectFilmButton.tag = indexPath.row
        cell.isSelectFilmButton.addTarget(self, action: #selector(isSelectFilm), for: .touchUpInside)
        cell.filmName.text = selectFilm.filmName.rawValue
        cell.filmImageView.image = toImage(filmType: selectFilm.filmName)
        cell.filmImageView.contentMode = .scaleAspectFit
        
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
