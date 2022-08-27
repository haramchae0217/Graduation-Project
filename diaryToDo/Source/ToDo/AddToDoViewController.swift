//
//  AddToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/29.
//

import UIKit

class AddToDoViewController: UIViewController {
    
    enum ToDoViewType {
        case add
        case edit
    }
    
    enum AllDayType {
        case yes
        case no
    }
    
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var toDoMemoLabel: UILabel!
    @IBOutlet weak var allDayLabel: UILabel!
    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addMemoTextField: UITextField!
    @IBOutlet weak var addStartDatePicker: UIDatePicker!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var addEndDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    var editToDo: ToDo?
    var editRow: Int?
    var viewType: ToDoViewType = .add
    var allDayType: AllDayType = .yes
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
        configureRightBarButton()
        
        if allDayType == .yes {
            mySwitch.setOn(true, animated: true)
            startDateLabel.isHidden = true
            endDateLabel.isHidden = true
            addStartDatePicker.isHidden = true
            addEndDatePicker.isHidden = true
        } else {
            mySwitch.setOn(false, animated: true)
            startDateLabel.isHidden = false
            endDateLabel.isHidden = false
            addStartDatePicker.isHidden = false
            addEndDatePicker.isHidden = false
        }
        
        if viewType == .edit {
            title = "투두 수정"
            if let editToDo = editToDo {
                addTitleTextField.text = editToDo.title
                addMemoTextField.text = editToDo.memo
                addStartDatePicker.date = editToDo.startDate
                addEndDatePicker.date = editToDo.endDate
            }
        } else {
            title = "투두 추가"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFontAndFontSize()
    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
                break
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
                startDateLabel.font = UIFont(name: font, size: fontSize)
                endDateLabel.font = UIFont(name: font, size: fontSize)
                toDoTitleLabel.font = UIFont(name: font, size: fontSize)
                toDoMemoLabel.font = UIFont(name: font, size: fontSize)
                allDayLabel.font = UIFont(name: font, size: fontSize)
                break
            }
        }
    }
    
    func configureRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addToDoButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func addToDoButton() {
        let title = addTitleTextField.text!
        let memo = addMemoTextField.text!
        var startDate = addStartDatePicker.date
        var endDate = addEndDatePicker.date
        
        let startStringDate = DateFormatter.customDateFormatter.dateToString(date: startDate)
        let endStringDate = DateFormatter.customDateFormatter.dateToString(date: endDate)
        
        startDate = DateFormatter.customDateFormatter.strToDate(str: startStringDate)
        endDate = DateFormatter.customDateFormatter.strToDate(str: endStringDate)
        
        if title.isEmpty || memo.isEmpty {
            UIAlertController.warningAlert(message: "내용을 입력해주세요.", viewController: self)
            return
        }
        
        if let editToDo = editToDo {
            if editToDo.title == title && editToDo.memo == memo && editToDo.startDate == startDate && editToDo.endDate == endDate {
                UIAlertController.warningAlert(message: "변경 후 다시 시도해주세요.", viewController: self)
                return
            }
        }
        
        let toDo = ToDo(title: title, memo: memo, startDate: startDate, endDate: endDate)
        print(startDate)
        print(endDate)
        
        if viewType == .add {
            MyDB.toDoList.append(toDo)
        } else {
            if let editToDo = editToDo {
                var index = 0
                for data in MyDB.toDoList {
                    index += 1
                    if (data.title == editToDo.title && data.memo == editToDo.memo && data.startDate == editToDo.startDate && data.endDate == editToDo.endDate) {
                        MyDB.toDoList[index - 1] = toDo
                    }
                }
            }
        }
        MyDB.toDoList = MyDB.toDoList.sorted(by: { $0.startDate < $1.startDate })
        MyDB.selectToDo = toDo
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allDaySwitch(_ sender: UISwitch) {
        if mySwitch.isOn {
            startDateLabel.isHidden = true
            endDateLabel.isHidden = true
            addStartDatePicker.isHidden = true
            addEndDatePicker.isHidden = true
        } else {
            startDateLabel.isHidden = false
            endDateLabel.isHidden = false
            addStartDatePicker.isHidden = false
            addEndDatePicker.isHidden = false
        }
    }
    
}
