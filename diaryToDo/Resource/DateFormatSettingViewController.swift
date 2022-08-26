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
    
    var dateList = MyDB.dateFormatList
    var selectedDateFormat: DateFormatType = .type1
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    var dateFormatType: DateFormatType = .type1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
        
        configureTableView()
        configureRightBarButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFontAndFontSize()
        configureDateFormat()
    }
    
    func configureDateFormat() {
        for data in MyDB.dateFormatList {
            if data.isSelected {
                dateFormatType = data.dateformatType
                break
            }
        }
    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
                dateFormatLabel.font = UIFont(name: font, size: fontSize)
            }
        }
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
        
        cell.typeDateFormat.text = DateFormatter.customDateFormatter.dateToStr(date: Date(), type: dateFormat.dateformatType)
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
