//
//  EditToDoViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/02/04.
//

import UIKit

class EditToDoViewCoantroller: UIViewController {

    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editMemoTextField: UITextField!
    
    var editToDo: ToDo?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarButtonItem()
        editTitleTextField.text = editToDo?.title
        editMemoTextField.text = editToDo?.memo

    }
    
    func createRightBarButtonItem() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "edit",style: .done, target: self, action: #selector(updateButtonClicked))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func updateButtonClicked() {
        let editTitle = editTitleTextField.text!
        let editMemo = editMemoTextField.text!
        // 1. 변경되었는지 체크
        guard let todo = editToDo else { return }
        if todo.memo == editMemo {
            UIAlertController.showAlert(message: "변경 후 다시 시도해주세요.", vc: self)
            return
        }
        // 3. 변경할 메모 추가하기
        // 새로운 메모 정보를 담을 변수 선언
        // let editToDo = ToDo(title: editTitle, memo: editMemo)
        // 2. row번째의 해당하는 메모리스트의 메모를 삭제
        if let row = row {
            ToDo.toDoList[row].title = editTitle
            ToDo.toDoList[row].memo = editMemo
            // ToDo.toDoList.remove(at: row)
            // ToDo.toDoList.append(editToDo)
        }
        
        self.navigationController?.popViewController(animated: true)
            
    }
    
}
