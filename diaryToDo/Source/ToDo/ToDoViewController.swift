//
//  ToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import UIKit
import FSCalendar

class ToDoViewController: UIViewController {

    @IBOutlet weak var toDoCalendarView: FSCalendar!
    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var todoDateLabel: UILabel!
    
    var calendarList: [ToDo] = []
    var moveIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toDoCalendarSetting()
        toDoCalendarView.isHidden = true
        
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: Date())
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        moveIndex = MyDB.toDoList.count
        print(moveIndex)
        
        toDoTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveIndex = MyDB.diaryItem.count
        print(moveIndex)
        
        toDoTableView.reloadData()
        
    }
    
    func toDoCalendarSetting() {
        toDoCalendarView.delegate = self
        toDoCalendarView.dataSource = self
        
        toDoCalendarView.locale = Locale(identifier: "ko-KR")
        
        toDoCalendarView.appearance.selectionColor = .systemBlue
        
    }
    
    @IBAction func previousToDoButton(_ sender: UIButton) {
       
    }
    
    @IBAction func nextToDoButton(_ sender: UIButton) {
        
    }
    
    @IBAction func addToDoButton(_ sender: UIBarButtonItem) {
        print("guard이전")
        guard let addToDo = self.storyboard?.instantiateViewController(withIdentifier: AddToDoViewController.identifier) as? AddToDoViewController else { return }
        print("guard이후")
        addToDo.viewType = .add
        self.navigationController?.pushViewController(addToDo, animated: true)
    }
    
    @objc func checkToDoButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "circle"),for: .normal)
            sender.isSelected = false
            MyDB.toDoList[sender.tag].isChecked = true
        } else {
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            sender.isSelected = true
            MyDB.toDoList[sender.tag].isChecked = true
        }
        
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        if toDoCalendarView.isHidden == true {
            toDoCalendarView.isHidden = false
        } else {
            toDoCalendarView.isHidden = true
        }
        toDoCalendarSetting()
    }
    
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        let todo = calendarList[indexPath.row]
        cell.toDoTitleLabel.text = todo.title
        cell.toDoCheckButton.tag = indexPath.row
        cell.toDoCheckButton.addTarget(self, action: #selector(checkToDoButton), for: .touchUpInside)
        cell.toDoExpireDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: todo.startDate)
        cell.toDoExpireTimeLabel.text = DateFormatter.customDateFormatter.timeToStr(date: todo.startDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            calendarList.remove(at: indexPath.row)
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
        editToDoVC.viewType = .edit
        editToDoVC.editToDo = calendarList[indexPath.row]
        editToDoVC.editRow = indexPath.row
        self.navigationController?.pushViewController(editToDoVC, animated: true)
    }
}

extension ToDoViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for todo in MyDB.toDoList {
            let toDoEvent = todo.startDate
            
            if toDoEvent == date {
                let count = MyDB.toDoList.filter { todo in
                    todo.startDate == date
                }.count
                
                if count >= 3 {
                    return 3
                } else {
                    return count
                }
            }
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date)
        
        calendarList = MyDB.toDoList.filter { toDo in
            toDo.startDate == date
        }
        toDoTableView.reloadData()
        
        if calendarList.count == 0 {
            UIAlertController.showAlert(message: "등록된 투두가 없습니다.", vc: self)
        }
    }
}
