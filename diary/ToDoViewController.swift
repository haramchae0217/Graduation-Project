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
    
    var toDoTitle: [String] = ["알바"]
    var toDoMemo: [String] = ["페이펄"]
    var toDoStartTime: [String] = ["15:30"]
    var toDoEndTime: [String] = ["21:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
    }
    
}
extension ToDoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    } // tablr view cell 높이 설정
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let addToDoVC = self.storyboard?.instantiateViewController(withIdentifier: "addToDoVC") as? AddToDoViewController else { return }
        // cell을 눌렀을 때 detailVC로 회면전환
        // detailVC에 있는 contentlabel에 적힌 text를 detailVC의 contentTextField에 넘겨줄것
        addToDoVC.addToDoTitle = toDoTitle[indexPath.row]
        addToDoVC.addToDoMemo = toDoMemo[indexPath.row]
        addToDoVC.addToDoStartTime = toDoStartTime[indexPath.row]
        addToDoVC.addToDoEndTime = toDoEndTime[indexPath.row]
        addToDoVC.row = indexPath.row
        self.navigationController?.pushViewController(addToDoVC, animated: true)
    }
}

extension ToDoViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoTitle.count // 몇개의 줄을 보여줄지 반환
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTableCell", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        cell.toDoTitleLabel.text = toDoTitle[indexPath.row]
        cell.toDoMemoLabel.text = toDoMemo[indexPath.row]
        cell.toDoStartTimeLabel.text = toDoStartTime[indexPath.row]
        cell.toDoEndTimeLabel.text = toDoEndTime[indexPath.row]
        
        return cell
    }
}

