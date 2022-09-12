//
//  AddToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/29.
//

import UIKit
import RealmSwift

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
    
    let localRealm = try! Realm()
    
    var editToDo: ToDoDB?
    var editRow: Int?
    var viewType: ToDoViewType = .add
    var allDayType: AllDayType = .yes
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureRightBarButton()
        configureAllDayType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFontAndFontSize()
    }
    
    func configureEditTypeView() {
        if let editToDo = editToDo {
            addTitleTextField.text = editToDo.title
            addMemoTextField.text = editToDo.memo
            addStartDatePicker.date = editToDo.startDate
            addEndDatePicker.date = editToDo.endDate
        }
    }
    
    func configureNavigationController() {
        if viewType == .edit {
            title = "투두 수정"
            configureEditTypeView()
        } else {
            title = "투두 추가"
        }
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        startDateLabel.font = UIFont(name: font, size: fontSize)
        endDateLabel.font = UIFont(name: font, size: fontSize)
        toDoTitleLabel.font = UIFont(name: font, size: fontSize)
        toDoMemoLabel.font = UIFont(name: font, size: fontSize)
        allDayLabel.font = UIFont(name: font, size: fontSize)
    }
    
    func configureRightBarButton() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
        let rightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addToDoButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func configureAllDayType() {
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
    }
    
    func addToDoDB(todo: ToDoDB) {
        try! localRealm.write {
            localRealm.add(todo)
        }
    }
    
    func editToDoDB(oldData: ToDoDB, newData: ToDoDB) {
        try! localRealm.write {
            localRealm.create(
                ToDoDB.self,
                value: [
                    "_id": oldData._id,
                    "title": newData.title,
                    "memo": newData.memo,
                    "startDate": newData.startDate,
                    "endDate": newData.endDate,
                    "isChecked": newData.isChecked
                ],
                update: .modified)
        }
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
        
        if viewType == .add {
            let todo = ToDoDB(title: title, memo: memo, startDate: startDate, endDate: endDate)
            addToDoDB(todo: todo)
        } else {
            if let oldToDo = editToDo {
                if oldToDo.title == title && oldToDo.memo == memo && oldToDo.startDate == startDate && oldToDo.endDate == endDate {
                    UIAlertController.warningAlert(message: "변경 후 다시 시도해주세요.", viewController: self)
                    return
                }
                let todo = ToDoDB(title: title, memo: memo, startDate: startDate, endDate: endDate)
                editToDoDB(oldData: oldToDo, newData: todo)
            }
        }
        
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
