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
    
    
   
    var addToDoTitle: String?
    var addToDoMemo: String?
    var addToDoStartTime: String?
    var addToDoEndTime: String?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleTextField.text = addToDoTitle
        addMemoTextField.text = addToDoMemo
        addStartTimeTextField.text = addToDoStartTime
        addEndTimeTextField.text = addToDoEndTime
        
    }
    @IBAction func addToDoButton(_ sender: Any) {
        // 1. VC에 접근하기
        guard let toDoListVC = self.storyboard?.instantiateViewController(withIdentifier: "toDoListVC") as? ToDoViewController else{ return }
        // 2. 값 대입해주기
        if let row = row{
            toDoListVC.toDoTitle[row] = addTitleTextField.text!
            toDoListVC.toDoMemo[row] = addMemoTextField.text!
            toDoListVC.toDoStartTime[row] = addStartTimeTextField.text!
            toDoListVC.toDoEndTime[row] = addEndTimeTextField.text!
            self.navigationController?.pushViewController(toDoListVC, animated: true)
        } else {
            print("인덱스 값이 비어있음.")
        }
    }
}

