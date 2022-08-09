//
//  DateFormatSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class DateFormatSettingViewController: UIViewController {

    static let identifier = "DateVC"
    
    @IBOutlet weak var dateFormatTableView: UITableView!
    
    var selectedDateFormat: DateFormatType = .type1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatTableView.dataSource = self
        dateFormatTableView.delegate = self
        
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
        
    }
    
    func setDateStyleSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setDateStyleNotSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc func setDoneButton() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectDateFormat(_ sender: UIButton) {
        for i in 0..<MyDB.dateFormatList.count {
            if sender.tag == i {
                if !MyDB.dateFormatList[i].isSelected {
                    MyDB.dateFormatList[i].isSelected.toggle()
                }
            } else {
                MyDB.dateFormatList[i].isSelected = false
            }
        }
        dateFormatTableView.reloadData()
    }
}

extension DateFormatSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDB.dateFormatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dateFormatTableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateFormatTableViewCell else { return UITableViewCell() }
        let dateFormat = MyDB.dateFormatList[indexPath.row]
        
        if dateFormat.isSelected {
            setDateStyleSelect(cell.selectedDateFormat)
        } else {
            setDateStyleNotSelect(cell.selectedDateFormat)
        }
        
        cell.typeDateFormat.text = dateFormat.dateformatType.rawValue
        cell.selectedDateFormat.tag = indexPath.row
        cell.selectedDateFormat.addTarget(self, action: #selector(isSelectDateFormat), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension DateFormatSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
