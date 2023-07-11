//
//  FontSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSettingViewController: UIViewController {
    
    @IBOutlet weak var fontTableView: UITableView!
    @IBOutlet weak var fontLabel: UILabel!
    
    var fontList: [(fontName: FontName, isSelected: Bool)] = [(.소찌체, false), (.아희체, false), (.위리체, false), (.따뜻한혜온체, false), (.밍댕손글씨체, false), (.정원체, false), (.정현모체, false), (.창이체, false)]
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        configureRightBarButton()
        configureFontAndFontSize()
    }
    
    func configureNavigationController() {
        title = "글꼴 설정"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        for i in 0..<fontList.count {
            if fontList[i].fontName.rawValue == font {
                fontList[i].isSelected = true
                break
            }
        }
        fontLabel.font = UIFont(name: font, size: fontSize)
    }
    
    func configureTableView() {
        fontTableView.dataSource = self
        fontTableView.delegate = self
    }
    
    func configureRightBarButton() {
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func toggleAndReload(index: Int) {
        for i in 0..<fontList.count {
            if index == i {
                if !fontList[i].isSelected {
                    fontList[i].isSelected.toggle()
                }
            } else {
                fontList[i].isSelected = false
            }
        }
        fontTableView.reloadData()
    }
    
    func setFontStyleSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setFontStyleNotSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc func setDoneButton() {
        let dbData = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        var selectData = ""
        
        for data in fontList {
            if data.isSelected {
                selectData = data.fontName.rawValue
            }
        }
        
        if dbData == selectData {
            UIAlertController.warningAlert(title: "🚫", message: "변동사항이 없습니다.", viewController: self)
        } else {
            let settingEdit = UIAlertController(title: "⚠️", message: "설정을 변경하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let editButton = UIAlertAction(title: "변경", style: .destructive) { _ in
                
                for font in self.fontList {
                    if font.isSelected {
                        UserDefaults.standard.set(font.fontName.rawValue, forKey: SettingType.font.rawValue)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            settingEdit.addAction(cancelButton)
            settingEdit.addAction(editButton)
            present(settingEdit, animated: true)
        }
    }
    
    @objc func isSelectFont(_ sender: UIButton) {
        toggleAndReload(index: sender.tag)
    }
}

extension FontSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fontTableView.dequeueReusableCell(withIdentifier: "fontCell", for: indexPath) as? FontSettingTableViewCell else { return UITableViewCell() }
        let font = fontList[indexPath.row]
        
        if font.isSelected {
            setFontStyleSelect(cell.isSelectedFontButton)
        } else {
            setFontStyleNotSelect(cell.isSelectedFontButton)
        }
        
        cell.fontSettingLabel.text = "\(font.fontName)"
        cell.fontSettingLabel.font = UIFont(name: font.fontName.rawValue, size: fontSize)
        cell.isSelectedFontButton.tag = indexPath.row
        cell.isSelectedFontButton.addTarget(self, action: #selector(isSelectFont), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleAndReload(index: indexPath.row)
    }
}

extension FontSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
