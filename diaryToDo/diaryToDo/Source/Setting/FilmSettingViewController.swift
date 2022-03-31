//
//  FilmSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FilmSettingViewController: UIViewController {

    @IBOutlet weak var filmTableView: UITableView!
    
    static let identifier = "filmVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filmTableView.dataSource = self
        filmTableView.delegate = self
        filmTableView.reloadData()
    }
    
    @objc func isSelectFilm(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "circle"),for: .normal)
            sender.isSelected = false
            Film.filmList[sender.tag].isSelectType = false
        } else {
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            sender.isSelected = true
            Film.filmList[sender.tag].isSelectType = true
        }
        
    }

}

extension FilmSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Film.filmList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filmTableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
        let film = Film.filmList[indexPath.row]
        cell.isSelectFilmButton.tag = indexPath.row
        cell.isSelectFilmButton.addTarget(self, action: #selector(isSelectFilm), for: .touchUpInside)
        cell.filmImageView.image = film.filmType
        cell.filmImageView.contentMode = .scaleAspectFit
        
        return cell
    }
}

extension FilmSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
