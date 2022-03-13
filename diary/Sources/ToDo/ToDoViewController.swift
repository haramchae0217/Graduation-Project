//
//  ToDoViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/01/19.
//

import UIKit

class ToDoViewController: UIViewController {
    
    // UI
    @IBOutlet weak var toDoListTableView: UITableView!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateStyle = .medium
        df.timeStyle = .medium
        return df
    }()

    // Property
    var toDoList: [ToDo] = [] // 이름 변경
    
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
        toDoCell.toDoCheckButton.tag = indexPath.row
        toDoCell.toDoExpireDateLabel.text = dateFormatter.toStringFromDate(target: todo.expireDate)
        toDoCell.toDoExpireTimeLabel.text = dateFormatter.toStringFromTime(target: todo.expireTime)
        
        toDoCell.selectionStyle = .none
        
        return toDoCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDo.toDoList.remove(at: indexPath.row)
            // 실제 배열 안의 값을 지움
            tableView.deleteRows(at: [indexPath], with: .fade)
            // 사라지는 방향
        } else {
            print("insert")
        }
        // 어디에 있는 줄을 지울것인가
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
