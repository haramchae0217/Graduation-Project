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
    
    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addMemoTextField: UITextField!
    @IBOutlet weak var addAllDay: UISwitch!
    @IBOutlet weak var addStartDatePicker: UIDatePicker!
    @IBOutlet weak var addEndDatePicker: UIDatePicker!
    
    var editToDo: ToDo?
    var editRow: Int?
    var viewType: ToDoViewType = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRightBarButton()
        
        if let editToDo = editToDo {
            title = "edit ToDo"
            addTitleTextField.text = editToDo.title
            addMemoTextField.text = editToDo.memo
            addStartDatePicker.date = editToDo.startDate
            addEndDatePicker.date = editToDo.endDate
        }
        
        title = "add ToDo"
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
            UIAlertController.showAlert(message: "내용을 입력해주세요.", vc: self)
            return
        }
        
        if editToDo?.title == title && editToDo?.memo == memo {
            UIAlertController.showAlert(message: "변경 후 다시 시도해주세요.", vc: self)
            return
        }
        
        if viewType == .add {
            MyDB.toDoList.append(toDo)
        } else {
            for var data in MyDB.toDoList {
                if (data.title == editToDo?.title && data.memo == editToDo?.memo) {
                    print(data)
                    data.title = title
                    data.memo = memo
                    data.startDate = startDate
                    data.endDate = endDate
                    data = toDo
                    print(data)
                }
            }
        
        self.navigationController?.popViewController(animated: true)
        }
    }
}
