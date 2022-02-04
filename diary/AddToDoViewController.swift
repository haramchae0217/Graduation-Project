//
//  AddToDoViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/01/25.
//

import UIKit

class AddToDoViewController: UIViewController {

    @IBOutlet weak var addTitleTextField: UITextField!
    @IBOutlet weak var addMemoTextField: UITextField!
    @IBOutlet weak var addStartTimeTextField: UITextField!
    @IBOutlet weak var addEndTimeTextField: UITextField!
    
    var addToDo: ToDo?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleTextField.text = addToDo?.title
        addMemoTextField.text = addToDo?.memo
        //addStartTimeTextField.text = addToDo?.startTime
        //addEndTimeTextField.text = addToDo?.endTime
        
    }
    @IBAction func addToDoButton(_ sender: Any) {
        
        //guard let todo = addToDo else { return }
        if addTitleTextField.text == "" {
            UIAlertController.showAlert(message: "제목을 입력해주세요", vc: self)
            return
        } else if addMemoTextField.text == "" {
            UIAlertController.showAlert(message: "메모를 입력해주세요", vc: self)
            return
        }
        let newToDo = ToDo(title: addTitleTextField.text!, memo: addMemoTextField.text!)
        ToDo.toDoList.append(newToDo)
        
        self.navigationController?.popViewController(animated: true)
    }
}


