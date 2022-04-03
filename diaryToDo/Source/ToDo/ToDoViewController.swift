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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoTableView.reloadData()
    }
    
    @IBAction func addToDoButton(_ sender: UIBarButtonItem) {
        guard let addToDo = self.storyboard?.instantiateViewController(withIdentifier: AddToDoViewController.identifier) as? AddToDoViewController else { return }
        self.navigationController?.pushViewController(addToDo, animated: true)
    }
    
    @objc func checkToDoButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "checkmark.square"),for: .normal)
            sender.isSelected = false
            ToDo.ToDoList[sender.tag].isChecked = true
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.isSelected = true
            ToDo.ToDoList[sender.tag].isChecked = true
        }
        
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
        cell.toDoCheckButton.tag = indexPath.row
        cell.toDoCheckButton.addTarget(self, action: #selector(checkToDoButton), for: .touchUpInside)
        cell.toDoExpireDateLabel.text = DateFormatter.customDateFormatter.toStringFromDate(target: todo.expireDate)
        cell.toDoExpireTimeLabel.text = DateFormatter.customDateFormatter.toStringFromTime(target: todo.expireTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDo.ToDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editToDoVC = self.storyboard?.instantiateViewController(withIdentifier: AddToDoViewController.identifier) as? AddToDoViewController else { return }
        editToDoVC.editToDo = ToDo.ToDoList[indexPath.row]
        editToDoVC.editRow = indexPath.row
        self.navigationController?.pushViewController(editToDoVC, animated: true)
    }
}
