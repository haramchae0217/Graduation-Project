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
    
    var fontList = MyDB.fontList
    var selectedFont: FontName = .name1
    var font: String = "Apple SD 산돌고딕 Neo"
    var fontSize: CGFloat = 12
//    var fontName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fontNameCheck()
        configureTableView()
        configureRightBarButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFontAndFontSize()
    }
    
//    func fontNameCheck() {
//        UIFont.familyNames.sorted().forEach { familyName in
//            print("***\(familyName)***")
//            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
//                print("\(fontName)")
//            }
//        }
//    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
                fontLabel.font = UIFont(name: font, size: fontSize)
            }
        }
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
        MyDB.fontList = fontList
        self.navigationController?.popViewController(animated: true)
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
        
        cell.fontSettingLabel.text = font.fontName.rawValue
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
