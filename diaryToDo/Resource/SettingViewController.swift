//
//  SettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var basicSettingLabel: UILabel!
    @IBOutlet weak var dateFormatButton: UIButton!
    @IBOutlet weak var fontSizeButton: UIButton!
    @IBOutlet weak var fontSettingButton: UIButton!
    @IBOutlet weak var filmSettingButton: UIButton!
    
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureFontAndFontSize()
    }
    
    func configureNavigationController() {
        title = "설정"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        dateFormatButton.layer.cornerRadius = 16
        fontSizeButton.layer.cornerRadius = 16
        fontSettingButton.layer.cornerRadius = 16
        filmSettingButton.layer.cornerRadius = 16
    }
    
    @IBAction func MoveDateFormatVC(_ sender: UIButton) {
        guard let dateVC = self.storyboard?.instantiateViewController(withIdentifier: "DateVC") as? DateFormatSettingViewController else { return }
        self.navigationController?.pushViewController(dateVC, animated: true)
    }
    
    @IBAction func MoveFontSizeVC(_ sender: UIButton) {
        guard let fontSizeVC = self.storyboard?.instantiateViewController(withIdentifier: "FontSizeVC") as? FontSizeSettingViewController else { return }
        self.navigationController?.pushViewController(fontSizeVC, animated: true)
    }
    
    @IBAction func MoveFontVC(_ sender: UIButton) {
        guard let fontVC = self.storyboard?.instantiateViewController(withIdentifier: "FontVC") as? FontSettingViewController else { return }
        self.navigationController?.pushViewController(fontVC, animated: true)
    }

    @IBAction func MoveFilmVC(_ sender: UIButton) {
        guard let filmVC = self.storyboard?.instantiateViewController(withIdentifier: "FilmVC") as? FilmSettingViewController else { return }
        self.navigationController?.pushViewController(filmVC, animated: true)
    }

}
