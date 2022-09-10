//
//  DateFormatSettingViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit

class DateFormatSettingViewController: UIViewController {
    
    @IBOutlet weak var dateFormatTableView: UITableView!
    @IBOutlet weak var dateFormatLabel: UILabel!
    
    var dateTypeList: [(dateformatType: DateFormatType, isSelected: Bool)] = [(.type1, false), (.type2, false), (.type3, false), (.type4, false), (.type5, false)]
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureFontAndFontSize()
        configureDateFormat()
        configureTableView()
        configureRightBarButton()
    }
    
    func configureNavigationController() {
        title = "날짜 형식 설정"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureDateFormat() {
        let dateFormatType = UserDefaults.standard.string(forKey: SettingType.dateFormat.rawValue) ?? "type3"
        
        for i in 0..<dateTypeList.count {
            if dateTypeList[i].dateformatType.rawValue == dateFormatType {
                dateTypeList[i].isSelected = true
                break
            }
        }
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        dateFormatLabel.font = UIFont(name: font, size: fontSize)
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
        for i in 0..<dateTypeList.count {
            if index == i {
                if !dateTypeList[i].isSelected {
                    dateTypeList[i].isSelected.toggle()
                }
            } else {
                dateTypeList[i].isSelected = false
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
        let dbData = UserDefaults.standard.string(forKey: SettingType.dateFormat.rawValue) ?? "type3"
        var selectData = ""
        
        for data in dateTypeList {
            if data.isSelected {
                selectData = data.dateformatType.rawValue
            }
        }
        
        if dbData == selectData {
            UIAlertController.warningAlert(message: "변동사항이 없습니다.", viewController: self)
        } else {
            let settingEdit = UIAlertController(title: "⚠️", message: "설정을 변경하시겠습니까?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let editButton = UIAlertAction(title: "변경", style: .destructive) { _ in
                
                for dateType in self.dateTypeList {
                    if dateType.isSelected {
                        UserDefaults.standard.set(dateType.dateformatType.rawValue, forKey: SettingType.dateFormat.rawValue)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            settingEdit.addAction(cancelButton)
            settingEdit.addAction(editButton)
            present(settingEdit, animated: true)
        }
    }
    
    @objc func isSelectDateFormat(_ sender: UIButton) {
        toggleAndReload(index: sender.tag)
    }
}

extension DateFormatSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dateFormatTableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateFormatTableViewCell else { return UITableViewCell() }
        let dateFormat = dateTypeList[indexPath.row]
        
        if dateFormat.isSelected {
            setDateStyleSelect(cell.selectedDateFormat)
        } else {
            setDateStyleNotSelect(cell.selectedDateFormat)
        }
        
        cell.typeDateFormat.text = DateFormatter.customDateFormatter.dateToStr(date: Date(), type: dateFormat.dateformatType.rawValue)
        cell.typeDateFormat.font = UIFont(name: font, size: fontSize)
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
