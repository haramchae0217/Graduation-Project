//
//  AddToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/29.
//

import UIKit

class AddToDoViewController: UIViewController {

    static let identifier = "addToDoVC"
    
    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addMemoTextField: UITextField!
    @IBOutlet weak var addExpireDatePicker: UIDatePicker!
    
    var editToDo: ToDo?
    var editRow: Int?
    var viewType: ViewType = .add
    
    enum ViewType {
        case add
        case edit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editToDo = editToDo {
            addTitleTextField.text = editToDo.title
            addMemoTextField.text = editToDo.memo
            addExpireDatePicker.date = editToDo.endDate
        }
        
        if viewType == .add {
            title = "add ToDo"
        } else {
            title = "edit ToDo"
        }
        
        let rightBarButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addToDoButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
    
    }
    
    @objc func addToDoButton() {
        let title = addTitleTextField.text!
        let memo = addMemoTextField.text!
        let expireDate = addExpireDatePicker.date
        let toDo = ToDo(title: title, memo: memo, endDate: expireDate)
        guard let editToDoList = editToDo else { return }
        
        if editToDoList.title == title && editToDoList.memo == memo {
            UIAlertController.showAlert(message: "변경 후 다시 시도해주세요.", vc: self)
            return
        }
        
        if title.isEmpty, memo.isEmpty {
            UIAlertController.showAlert(message: "내용을 입력해주세요.", vc: self)
            return
        }
        
        if viewType == .add {
            MyDB.ToDoList.append(toDo)
        } else {
            if let row = editRow {
                MyDB.ToDoList[row] = toDo
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
