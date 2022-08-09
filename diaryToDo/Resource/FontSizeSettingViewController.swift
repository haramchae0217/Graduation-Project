//
//  FontSizeSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class FontSizeSettingViewController: UIViewController {

    static let identifier = "fontSizeVC"
    
    @IBOutlet weak var fontSizeTableView: UITableView!
    
    var selectedFontSize: FontSize = .작게
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fontSizeTableView.dataSource = self
        fontSizeTableView.delegate = self
        
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func setFontSizeSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setFontSizeNotSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc func setDoneButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectFontSize(_ sender: UIButton) {
        for i in 0..<MyDB.fontSizeList.count {
            if sender.tag == i {
                if !MyDB.fontSizeList[i].isSelected {
                    MyDB.fontSizeList[i].isSelected.toggle()
                }
            } else {
                MyDB.fontSizeList[i].isSelected = false
            }
        }
        fontSizeTableView.reloadData()
    }
}

extension FontSizeSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDB.fontSizeList.count
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
        
    }
}

extension FontSizeSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
