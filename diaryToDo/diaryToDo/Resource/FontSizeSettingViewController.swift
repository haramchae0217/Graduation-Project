//
//  FontSizeSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSizeSettingViewController: UIViewController {

    @IBOutlet weak var fontSizeTableView: UITableView!
    
    static let identifier = "fontSizeVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fontSizeTableView.dataSource = self
        fontSizeTableView.delegate = self
        fontSizeTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fontSizeTableView.reloadData()
    }
    
    @objc func isSelectFontSize(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "circle"),for: .normal)
            sender.isSelected = false
            FontSize.fontsizeList[sender.tag].isSelectType = false
        } else {
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            sender.isSelected = true
            FontSize.fontsizeList[sender.tag].isSelectType = true
        }
        
    }
    

}

extension FontSizeSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FontSize.fontsizeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fontSizeTableView.dequeueReusableCell(withIdentifier: "fontSizeCell", for: indexPath) as? FontSizeTableViewCell else { return UITableViewCell() }
        let fontSize = FontSize.fontsizeList[indexPath.row]
        cell.fontSizeLabel.text = fontSize.fontSize
        cell.fontSizeSelectButton.tag = indexPath.row
        cell.fontSizeSelectButton.addTarget(self, action: #selector(isSelectFontSize), for: .touchUpInside)
        
        return cell
    }
}

extension FontSizeSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
