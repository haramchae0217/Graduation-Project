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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatTableView.dataSource = self
        dateFormatTableView.delegate = self
        dateFormatTableView.reloadData()
        
        let rightDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(setDoneButton))
        self.navigationItem.rightBarButtonItem = rightDoneButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatTableView.reloadData()
    }
    
    @objc func setDoneButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectDateFormat(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "circle"),for: .normal)
            sender.isSelected = false
            DateFormat.dateFormatList[sender.tag].isSelectType = false
        } else {
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            sender.isSelected = true
            DateFormat.dateFormatList[sender.tag].isSelectType = true
        }
    }
}

extension DateFormatSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DateFormat.dateFormatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dateFormatTableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateFormatTableViewCell else { return UITableViewCell() }
        let dateFormat = DateFormat.dateFormatList[indexPath.row]
        
        cell.typeDateFormat.text = dateFormat.typeDateFormat
        cell.selectedDateFormat.tag = indexPath.row
        cell.selectedDateFormat.addTarget(self, action: #selector(isSelectDateFormat), for: .touchUpInside)
        
        return cell
    }
}

extension DateFormatSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
