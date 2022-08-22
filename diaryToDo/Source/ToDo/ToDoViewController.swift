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
    
    var toDoList = MyDB.toDoList
    var todayToDoList: [ToDo] = []
    var selectedDate: Date = Date()
    var font: String = "Apple SD 산돌고딕 Neo"
    var fontSize: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDate = toDoList[toDoList.endIndex - 1].startDate
        configureTableView()
        configureCalendar()
        
        toDoTableView.reloadData()
        toDoCalendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toDoView()
        configureFontAndFontSize()
        
        toDoTableView.reloadData()
        toDoCalendarView.reloadData()
    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
            }
        }
    }
    
    func configureTableView() {
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
    }
    
    func configureCalendar() {
        toDoCalendarView.delegate = self
        toDoCalendarView.dataSource = self
        
        toDoCalendarView.isHidden = true
        toDoCalendarView.locale = Locale(identifier: "ko-KR")
        toDoCalendarView.appearance.selectionColor = .systemBlue
    }
    
    func toDoView() {
        let sortedList = MyDB.toDoList.sorted(by: { $0.startDate > $1.startDate })
        
        let recentToDoDate: Date = selectedDate
        todayToDoList = []
        
        for data in sortedList {
            if recentToDoDate == data.startDate {
                todayToDoList.append(data)
                todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.startDate)
                todoDateLabel.font = UIFont(name: font, size: fontSize)
            }
        }
    }
    
    func setToDoComplete(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func setToDoNotComplete(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    func toggleAndReload(index: Int) {
        let todo = todayToDoList[index]
        todayToDoList[index].isChecked.toggle()
        var toDoListIndex = 0
        for data in MyDB.toDoList {
            toDoListIndex += 1
            if (data.title == todo.title && data.memo == todo.memo && data.startDate == todo.startDate && data.endDate == todo.endDate ) {
                MyDB.toDoList[toDoListIndex - 1].isChecked.toggle()
            }
        }
        toDoTableView.reloadData()
    }
    
    @IBAction func previousToDoButton(_ sender: UIButton) {
        let sortedList = MyDB.toDoList.sorted(by: { $0.startDate > $1.startDate })
        
        var previousDate: Date = selectedDate
        todayToDoList = []
        
        for data in sortedList { // 바로 이전 날짜 추출
            if selectedDate > data.startDate {
                previousDate = data.startDate
                break
            }
        }
        
        for data in MyDB.toDoList { // 위에서 추출한 날짜와 db에 날짜가 같다면 데이터를 뽑아와서 저장
            if previousDate == data.startDate {
                todayToDoList.append(data)
            }
        }
        
        toDoTableView.reloadData()
        selectedDate = previousDate
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: selectedDate)
    }
    
    @IBAction func nextToDoButton(_ sender: UIButton) {
        var nextDate: Date = selectedDate
        
        todayToDoList = []
        
        for data in MyDB.toDoList {
            if selectedDate < data.startDate {
                nextDate = data.startDate
                break
            }
        }
        
        for data in MyDB.toDoList {
            if nextDate == data.startDate {
                todayToDoList.append(data)
            }
        }
        
        toDoTableView.reloadData()
        selectedDate = nextDate
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: selectedDate)
    }
    
    @IBAction func addToDoButton(_ sender: UIBarButtonItem) {
        guard let addToDo = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as? AddToDoViewController else { return }
        addToDo.viewType = .add
        self.navigationController?.pushViewController(addToDo, animated: true)
    }
    
    @IBAction func graphButon(_ sender: UIBarButtonItem) {
        guard let graphVC = self.storyboard?.instantiateViewController(withIdentifier: "GraphVC") as? GraphViewController else { return }
        self.navigationController?.pushViewController(graphVC, animated: true)
    }
    
    
    @objc func checkToDoButton(_ sender: UIButton) {
        toggleAndReload(index: sender.tag)
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        toDoCalendarView.isHidden.toggle()
    }
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayToDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        let todo = todayToDoList[indexPath.row]
        
        if todo.isChecked {
            setToDoComplete(cell.toDoCheckButton)
        } else {
            setToDoNotComplete(cell.toDoCheckButton)
        }
        
        cell.toDoTitleLabel.text = todo.title
        cell.toDoTitleLabel.font = UIFont(name: font, size: fontSize)
        cell.toDoCheckButton.tag = indexPath.row
        cell.toDoCheckButton.addTarget(self, action: #selector(checkToDoButton), for: .touchUpInside)
        cell.toDoExpireDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: todo.endDate)
        cell.toDoExpireDateLabel.font = UIFont(name: font, size: fontSize)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MyDB.toDoList.removeAll { item in
                item.title == todayToDoList[indexPath.row].title && item.memo == todayToDoList[indexPath.row].memo && item.startDate == todayToDoList[indexPath.row].startDate && item.endDate == todayToDoList[indexPath.row].endDate
            }
            todayToDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editToDoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as? AddToDoViewController else { return }
        editToDoVC.viewType = .edit
        editToDoVC.editToDo = todayToDoList[indexPath.row]
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
        toDoCalendarView.isHidden.toggle()
        
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date)
        
        todayToDoList = MyDB.toDoList.filter { toDo in
            toDo.startDate == date
        }
        
        toDoTableView.reloadData()
        selectedDate = date
        
        if todayToDoList.count == 0 {
            UIAlertController.warningAlert(message: "등록된 투두가 없습니다.", viewController: self)
        }
    }
}
