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
    
    var fontSizeList = MyDB.fontSizeList
    var selectedFontSize: FontSize = .작게
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "글씨 크기 설정"
        
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
                fontSizeLabel.font = UIFont(name: font, size: fontSize)
                break
            }
        }
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
        var dbData = ""
        var selectData = ""
        for data in MyDB.fontSizeList {
            if data.isSelected {
                dbData = "\(data.fontSize)"
            }
        }
        
        for data in fontSizeList {
            if data.isSelected {
                selectData = "\(data.fontSize)"
            }
        }
        if dbData == selectData {
            UIAlertController.warningAlert(message: "변동사항이 없습니다.", viewController: self)
        } else {
            let settingEdit = UIAlertController(title: "⚠️", message: "설정을 변경하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let editButton = UIAlertAction(title: "변경", style: .destructive) { _ in
                MyDB.fontSizeList = self.fontSizeList
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
