//
//  ToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import UIKit
import FSCalendar

class ToDoViewController: UIViewController {
    
    enum ToDoType {
        case basic
        case select
    }

    @IBOutlet weak var toDoCalendarView: FSCalendar!
    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var todoDateLabel: UILabel!
    
    var toDoList = MyDB.toDoList
    var todayToDoList: [ToDo] = []
    var toDoType: ToDoType = .basic
    var selectToDo: ToDo?
    var selectedDate: Date = Date()
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    var dateFormatType: DateFormatType = .type1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    
        if !MyDB.toDoList.isEmpty {
            selectedDate = toDoList[toDoList.endIndex - 1].startDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MyDB.selectToDo != nil {
            toDoType = .select
        }
        toDoList = MyDB.toDoList
        configureCalendar()
        configureDateFormat()
        configureFontAndFontSize()
        toDoView()
        toDoTableView.reloadData()
        toDoCalendarView.reloadData()
    }
    
    func configureDateFormat() {
        for data in MyDB.dateFormatList {
            if data.isSelected {
                dateFormatType = data.dateformatType
                break
            }
        }
    }
    
    func configureFontAndFontSize() {
        for data in MyDB.fontSizeList {
            if data.isSelected {
                fontSize = data.fontSize.rawValue
                break
            }
        }
        
        for data in MyDB.fontList {
            if data.isSelected {
                font = data.fontName.rawValue
                todoDateLabel.font = UIFont(name: font, size: fontSize)
                break
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
        
        toDoCalendarView.appearance.headerTitleFont = UIFont(name: font, size: fontSize)
        toDoCalendarView.appearance.weekdayFont = UIFont(name: font, size: fontSize)
        toDoCalendarView.appearance.titleFont = UIFont(name: font, size: fontSize)
        toDoCalendarView.appearance.headerTitleColor = UIColor(named: "diaryColor")
        toDoCalendarView.appearance.weekdayTextColor = UIColor(named: "diaryColor")
        toDoCalendarView.appearance.titlePlaceholderColor = UIColor(named: "diaryColor2")
        toDoCalendarView.appearance.titleDefaultColor = UIColor(named: "diaryColor3")
        toDoCalendarView.layer.cornerRadius = 16
        toDoCalendarView.appearance.selectionColor = .systemBlue
    }
    
    func toDoView() {
        let sortedList = MyDB.toDoList.sorted(by: { $0.startDate > $1.startDate } )
        todayToDoList = []
        if toDoType == .select {
            selectToDo = MyDB.selectToDo
            guard let selectToDo = selectToDo else { return }
            let selectToDoDate: Date = selectToDo.startDate
            for data in sortedList {
                if selectToDoDate == data.startDate {
                    todayToDoList.append(data)
                    todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.startDate, type: dateFormatType)
                    selectedDate = selectToDo.startDate
                }
            }
        } else {
            if !MyDB.toDoList.isEmpty {
                let recentToDoDate: Date = MyDB.toDoList[sortedList.endIndex - 1].startDate
                for data in sortedList {
                    if recentToDoDate == data.startDate {
                        todayToDoList.append(data)
                        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.startDate, type: dateFormatType)
                    }
                }
            } else {
                todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: Date(), type: dateFormatType)
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
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: selectedDate, type: dateFormatType)
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
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: selectedDate, type: dateFormatType)
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
        
        if MyDB.toDoList.isEmpty {
            cell.toDoTitleLabel.text = "등록된 투두가 없습니다. 투두를 추가해주세요."
        } else {
            if todo.isChecked {
                setToDoComplete(cell.toDoCheckButton)
            } else {
                setToDoNotComplete(cell.toDoCheckButton)
            }
            
            cell.toDoTitleLabel.text = todo.title
            cell.toDoTitleLabel.font = UIFont(name: font, size: fontSize)
            if todo.isChecked {
                cell.toDoTitleLabel.textColor = .lightGray
                cell.toDoExpireDateLabel.textColor = .lightGray
            } else {
                cell.toDoTitleLabel.textColor = .label
                cell.toDoExpireDateLabel.textColor = .label
            }
            cell.toDoCheckButton.tag = indexPath.row
            cell.toDoCheckButton.addTarget(self, action: #selector(checkToDoButton), for: .touchUpInside)
            if todo.startDate == todo.endDate {
                cell.toDoExpireDateLabel.text = "오늘"
            } else {
                cell.toDoExpireDateLabel.text = "마감일 : \(DateFormatter.customDateFormatter.dateToStr(date: todo.endDate, type: dateFormatType))"
            }
            cell.toDoExpireDateLabel.font = UIFont(name: font, size: fontSize - 6)
        }
        
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
        let todo = todayToDoList[indexPath.row]
        guard let editToDoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as? AddToDoViewController else { return }
        editToDoVC.viewType = .edit
        editToDoVC.editToDo = todo
        if todo.startDate == todo.endDate {
            editToDoVC.allDayType = .yes
        } else {
            editToDoVC.allDayType = .no
        }
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
        
        todayToDoList = MyDB.toDoList.filter { toDo in
            toDo.startDate == date
        }
        
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date, type: dateFormatType)
        
        toDoTableView.reloadData()
        selectedDate = date
        
        if todayToDoList.count == 0 {
            UIAlertController.warningAlert(message: "등록된 투두가 없습니다.", viewController: self)
        }
    }
}
