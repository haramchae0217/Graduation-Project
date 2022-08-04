//
//  FilmSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

/*
 TODO:
 - cell 눌렀을 때 토글되게 하기
 - '완료'버튼 눌렀을 때 저장되어있게 하기
 - 만약 저장하지 않고 뒤로가면, 저장하기 전에 선택했던 필름으로 설정
 */

class FilmSettingViewController: UIViewController {
    
    @IBOutlet weak var filmTableView: UITableView!
    
    var selectedFilm: FilmType = .film1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filmTableView.dataSource = self
        filmTableView.delegate = self
        
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectFilm(_ sender: UIButton) {
        for i in 0..<MyDB.filmList.count {
            if sender.tag == i {
                if !MyDB.filmList[i].isSelectd {
                    MyDB.filmList[i].isSelectd.toggle()
                }
            } else {
                MyDB.filmList[i].isSelectd = false
            }
        }
    
        filmTableView.reloadData()
    }
}

extension FilmSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDB.filmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filmTableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
        let selectFilm = MyDB.filmList[indexPath.row]
        
        if selectFilm.isSelectd {
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
        //TODO: Cell을 누를때 선택되도록 수정해보기!
        let selectCell = MyDB.filmList[indexPath.row]
        
        

        print(selectCell.filmName)
    }
}

extension FilmSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
