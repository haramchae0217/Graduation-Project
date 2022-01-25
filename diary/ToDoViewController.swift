//
//  ToDoViewController.swift
//  diary
//
//  Created by Chae_Haram on 2022/01/19.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //UI
    var todoList: [String] = []
    var todoMemo: [String] = []
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        todoList.append(titleTextField.text ?? "0")
        todoMemo.append(memoTextField.text ?? "0" )
        self.toDoTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count // 몇개의 줄을 보여줄지 반환
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTableCell", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        let title = todoList[indexPath.row]
        let memo = todoMemo[indexPath.row]
        cell.toDoTitle.text = title
        cell.toDoMemo.text = memo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    } // tablr view cell 높이 설정
    
    
}
