//
//  FontSizeSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSizeSettingViewController: UIViewController {
    
    @IBOutlet weak var fontSizeTableView: UITableView!

    var fontSizeList = MyDB.fontSizeList
    var selectedFontSize: FontSize = .작게
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureRightBarButton()
        
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
        for i in 0..<MyDB.fontSizeList.count {
            if index == i {
                if !MyDB.fontSizeList[i].isSelected {
                    MyDB.fontSizeList[i].isSelected.toggle()
                }
            } else {
                MyDB.fontSizeList[i].isSelected = false
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
        MyDB.fontSizeList = fontSizeList
        self.navigationController?.popViewController(animated: true)
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
        let fontSize = MyDB.fontSizeList[indexPath.row]
        
        if fontSize.isSelected {
            setFontSizeSelect(cell.fontSizeSelectButton)
        } else {
            setFontSizeNotSelect(cell.fontSizeSelectButton)
        }
        
        cell.fontSizeLabel.text = fontSize.fontSize.rawValue
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
