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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        configureRightBarButton()
        
        if viewType == .edit {
            title = "edit ToDo"
            if let editToDo = editToDo {
                addTitleTextField.text = editToDo.title
                addMemoTextField.text = editToDo.memo
                addStartDatePicker.date = editToDo.startDate
                addEndDatePicker.date = editToDo.endDate
            }
        } else {
            title = "add ToDo"
        }
    }
    
    func configureRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addToDoButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func addToDoButton() {
        let title = addTitleTextField.text!
        let memo = addMemoTextField.text!
        let startDate = addStartDatePicker.date
        let endDate = addEndDatePicker.date
        
        let toDo = ToDo(title: title, memo: memo, startDate: startDate, endDate: endDate)
        
        if title.isEmpty, memo.isEmpty {
            UIAlertController.warningAlert(message: "내용을 입력해주세요.", viewController: self)
            return
        }
        
        if editToDo?.title == title && editToDo?.memo == memo {
            UIAlertController.warningAlert(message: "변경 후 다시 시도해주세요.", viewController: self)
            return
        }
        
        if viewType == .add {
            MyDB.toDoList.append(toDo)
        } else {
            var index = 0
            for data in MyDB.toDoList {
                index += 1
                if (data.title == editToDo?.title && data.memo == editToDo?.memo && data.startDate == editToDo?.startDate && data.endDate == editToDo?.endDate) {
                    MyDB.toDoList[index - 1] = toDo
                }
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
