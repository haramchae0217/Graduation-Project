//
//  FontSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSettingViewController: UIViewController {

    @IBOutlet weak var fontTableView: UITableView!
    
    static let identifier = "fontVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontTableView.dataSource = self
        fontTableView.delegate = self
        fontTableView.reloadData()
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
