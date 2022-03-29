//
//  ToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import UIKit

class ToDoViewController: UIViewController {

    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toDoTableView.dataSource = self
        toDoTableView.delegate = self
    }
    

    
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ToDo.ToDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        let todo = ToDo.ToDoList[indexPath.row]
        cell.toDoTitleLabel.text = todo.title
        cell.toDoExpireDateLabel.text = DateFormatter.customDateFormatter.toStringFromDate(target: todo.expireDate)
        
        return cell
    }
    
   
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
