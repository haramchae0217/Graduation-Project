//
//  DateFormatSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class DateFormatSettingViewController: UIViewController {
    
    @IBOutlet weak var dateFormatTableView: UITableView!
    
    var dateList = MyDB.dateFormatList
    var selectedDateFormat: DateFormatType = .type1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureRightBarButton()
        
    }
    
    func configureTableView() {
        dateFormatTableView.dataSource = self
        dateFormatTableView.delegate = self
    }
    
    func configureRightBarButton() {
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
    }
    
    func toggleAndReload(index: Int) {
        for i in 0..<dateList.count {
            if index == i {
                if !dateList[i].isSelected {
                    dateList[i].isSelected.toggle()
                }
            } else {
                dateList[i].isSelected = false
            }
        }
        dateFormatTableView.reloadData()
    }
    
    func setDateStyleSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setDateStyleNotSelect(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @objc func setDoneButton() {
        MyDB.dateFormatList = dateList
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectDateFormat(_ sender: UIButton) {
        toggleAndReload(index: sender.tag)
    }
}

extension DateFormatSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dateFormatTableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateFormatTableViewCell else { return UITableViewCell() }
        let dateFormat = dateList[indexPath.row]
        
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
        toggleAndReload(index: indexPath.row)
    }
}

extension DateFormatSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
