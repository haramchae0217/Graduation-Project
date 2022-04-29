//
//  FontSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSettingViewController: UIViewController {

    static let identifier = "fontVC"
    
    @IBOutlet weak var fontTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontTableView.dataSource = self
        fontTableView.delegate = self
        fontTableView.reloadData()
        
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    @objc func setDoneButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectFont(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "circle"),for: .normal)
            sender.isSelected = false
            Font.fontList[sender.tag].isSelectType = false
        } else {
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            sender.isSelected = true
            Font.fontList[sender.tag].isSelectType = true
        }
    }
}

extension FontSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Font.fontList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fontTableView.dequeueReusableCell(withIdentifier: "fontCell", for: indexPath) as? FontSettingTableViewCell else { return UITableViewCell() }
        let font = Font.fontList[indexPath.row]
        
        cell.fontSettingLabel.text = font.fontName
        cell.isSelectedFontButton.tag = indexPath.row
        cell.isSelectedFontButton.addTarget(self, action: #selector(isSelectFont), for: .touchUpInside)
        
        return cell
    }
}

extension FontSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
