//
//  FilmSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

/*
 1. 현재 사용중인 필름이 무엇인지 저장
 2. 저장된 필름을 앱이 시작되는 시점에 다이어리 뷰컨에 지정
 3. 세팅에서 필름을 변경할 경우 완료를 누르는 순간 선택한 필름이 저장
 4. diaryVC는 viewWillAppear 시점에 필름이 바뀌었는지 체크
 5. 내가 어딘가 저장한 필름의 번호를 가져와서 tableView의 index들을 순회하면서 해당하는 버튼을 selected로 변경
 */

class FilmSettingViewController: UIViewController {
    
    @IBOutlet weak var filmTableView: UITableView!
    
//    var filmBool: [Bool] = Array.init(repeating: false, count: MyDB.filmList.count)
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
        // TODO: -1 4개의 필름 중에서 1개만 되게하기.
        
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
}

extension FilmSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
