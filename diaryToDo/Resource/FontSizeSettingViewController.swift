//
//  FontSizeSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSizeSettingViewController: UIViewController {
    
    @IBOutlet weak var fontSizeTableView: UITableView!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    var fontSizeList: [(fontSize: FontSize, isSelected: Bool)] = [(.아주작게, false), (.작게, false), (.중간, false), (.크게, false), (.아주크게, false)]
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
        title = "글씨 크기 설정"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        
        for i in 0..<fontSizeList.count {
            if fontSizeList[i].fontSize.rawValue == fontSize {
                fontSizeList[i].isSelected = true
                break
            }
        }
        
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        fontSizeLabel.font = UIFont(name: font, size: fontSize)
    }
    
    func configureTableView() {
        fontSizeTableView.dataSource = self
        fontSizeTableView.delegate = self
    }
    
    func configureRightBarButton() {
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func toggleAndReload(index: Int) {
        for i in 0..<fontSizeList.count {
            if index == i {
                if !fontSizeList[i].isSelected {
                    fontSizeList[i].isSelected.toggle()
                }
            } else {
                fontSizeList[i].isSelected = false
            }
        }
        fontSizeTableView.reloadData()
    }
    
    func setFontSizeSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setFontSizeNotSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc func setDoneButton() {
        let dbData = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        var selectData: CGFloat = 0
        
        for data in fontSizeList {
            if data.isSelected {
                selectData = data.fontSize.rawValue
            }
        }
        
        if dbData == selectData {
            UIAlertController.warningAlert(message: "변동사항이 없습니다.", viewController: self)
        } else {
            let settingEdit = UIAlertController(title: "⚠️", message: "설정을 변경하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let editButton = UIAlertAction(title: "변경", style: .destructive) { _ in
                
                for fontSize in self.fontSizeList {
                    if fontSize.isSelected {
                        UserDefaults.standard.set(fontSize.fontSize.rawValue, forKey: SettingType.fontSize.rawValue)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            settingEdit.addAction(cancelButton)
            settingEdit.addAction(editButton)
            present(settingEdit, animated: true)
        }
    }
    
    @objc func isSelectFontSize(_ sender: UIButton) {
        toggleAndReload(index: sender.tag)
    }
}

extension FontSizeSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontSizeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fontSizeTableView.dequeueReusableCell(withIdentifier: "fontSizeCell", for: indexPath) as? FontSizeTableViewCell else { return UITableViewCell() }
        let fontSize = fontSizeList[indexPath.row]
        
        if fontSize.isSelected {
            setFontSizeSelect(cell.fontSizeSelectButton)
        } else {
            setFontSizeNotSelect(cell.fontSizeSelectButton)
        }
        
        cell.fontSizeLabel.text = "\(fontSize.fontSize)"
        cell.fontSizeLabel.font = UIFont(name: font, size: fontSize.fontSize.rawValue)
        cell.fontSizeSelectButton.tag = indexPath.row
        cell.fontSizeSelectButton.addTarget(self, action: #selector(isSelectFontSize), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleAndReload(index: indexPath.row)
    }
}

extension FontSizeSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
