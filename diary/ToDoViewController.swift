//
//  ToDoViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/01/19.
//

import UIKit

class ToDoViewController: UIViewController {
    
    //UI
    @IBOutlet weak var toDoListTableView: UITableView!
    var toDoList: [ToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toDoListTableView.reloadData()
    }
    
    @objc func checkToDoButton(_ sender: UIButton) {
        // if selcted -> 빈 체크박스 그림
        // if not selected -> 색칠된 체크박스 그림
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            sender.isSelected = false
            ToDo.toDoList[sender.tag].isChecked = false
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.isSelected = true
            ToDo.toDoList[sender.tag].isChecked = true
            
        }
        print(ToDo.toDoList[sender.tag].isChecked)
    }
}

extension ToDoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDo.toDoList.count // 몇개의 줄을 보여줄지 반환
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let toDoCell = tableView.dequeueReusableCell(withIdentifier: "toDoTableCell", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        let todo = ToDo.toDoList[indexPath.row]
        toDoCell.toDoCheckButton.addTarget(self, action: #selector(checkToDoButton), for: .touchUpInside)
        toDoCell.toDoTitleLabel.text = todo.title
        toDoCell.toDoMemoLabel.text = todo.memo
        toDoCell.toDoCheckButton.tag = indexPath.row
        
        toDoCell.selectionStyle = .none
        
        return toDoCell
    }
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    } // tablr view cell 높이 설정
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editToDoVC = self.storyboard?.instantiateViewController(withIdentifier: "editToDoVC") as? EditToDoViewCoantroller else { return }
        editToDoVC.editToDo = ToDo.toDoList[indexPath.row]
        editToDoVC.row = indexPath.row
        self.navigationController?.pushViewController(editToDoVC, animated: true)
    }
}
