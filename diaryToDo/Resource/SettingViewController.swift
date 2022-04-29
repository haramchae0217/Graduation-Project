//
//  SettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func MoveDateFormatVC(_ sender: UIButton) {
        guard let dateVC = self.storyboard?.instantiateViewController(withIdentifier: DateFormatSettingViewController.identifier) as? DateFormatSettingViewController else { return }
        self.navigationController?.pushViewController(dateVC, animated: true)
    }
    
    @IBAction func MoveFontSizeVC(_ sender: UIButton) {
        guard let fontSizeVC = self.storyboard?.instantiateViewController(withIdentifier: FontSizeSettingViewController.identifier) as? FontSizeSettingViewController else { return }
        self.navigationController?.pushViewController(fontSizeVC, animated: true)
    }
    
    @IBAction func MoveFontVC(_ sender: UIButton) {
        guard let fontVC = self.storyboard?.instantiateViewController(withIdentifier: FontSettingViewController.identifier) as? FontSettingViewController else { return }
        self.navigationController?.pushViewController(fontVC, animated: true)
    }

    @IBAction func MoveFilmVC(_ sender: UIButton) {
        guard let filmVC = self.storyboard?.instantiateViewController(withIdentifier: FilmSettingViewController.identifier) as? FilmSettingViewController else { return }
        self.navigationController?.pushViewController(filmVC, animated: true)
    }

}
