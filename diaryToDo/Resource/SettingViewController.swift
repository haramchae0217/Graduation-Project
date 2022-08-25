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
    
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                basicSettingLabel.font = UIFont(name: font, size: fontSize)
                dateFormatButton.setTitle("날짜 형식", for: .normal)
                dateFormatButton.titleLabel?.font = UIFont(name: font, size: fontSize)
                fontSizeButton.setTitle("글씨 크기", for: .normal)
                fontSizeButton.titleLabel?.font = UIFont(name: font, size: fontSize)
                fontSettingButton.setTitle("글꼴 설정", for: .normal)
                fontSettingButton.titleLabel?.font = UIFont(name: font, size: fontSize)
                filmSettingButton.setTitle("필름 설정", for: .normal)
                filmSettingButton.titleLabel?.font = UIFont(name: font, size: fontSize)
                break
            }
        }
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
