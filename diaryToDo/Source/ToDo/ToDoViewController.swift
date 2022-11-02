//
//  ToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import UIKit
import FSCalendar
import RealmSwift

class ToDoViewController: UIViewController {

    //MARK: UI
    @IBOutlet weak var toDoCalendarView: FSCalendar!
    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var todoDateLabel: UILabel!
    @IBOutlet weak var toDoEmptyView: UIView!
    @IBOutlet weak var toDoEmptyLabel: UILabel!
    
    //MARK: Property
    let localRealm = try! Realm()
    let sectionList: [String] = ["미완료", "완료"]
    
    var todoDBList: [ToDoDB] = []
    var todayToDoList: [ToDoDB] = []
    var checkedList: [ToDoDB] = []
    var notCheckedList: [ToDoDB] = []
    var checkToDoSection: Int = 0
    var selectToDo: ToDoDB?
    var selectedDate: Date = Date()
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    var dateFormatType: String = ""
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        configureCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureDateFormat()
        configureFontAndFontSize()
        todoDBList = getToDo()
        configureDate()
        getTodayList(today: selectedDate)
        
        toDoTableView.reloadData()
        toDoCalendarView.reloadData()
    }
    
    func configureNavigationController() {
        title = "투두"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureDateFormat() {
        let dateType = UserDefaults.standard.string(forKey: SettingType.dateFormat.rawValue) ?? "type3"
        dateFormatType = dateType
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        toDoEmptyLabel.font = UIFont(name: font, size: fontSize)
        todoDateLabel.font = UIFont(name: font, size: fontSize)
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
    
    func configureDate() {
        if SelectItem.selectToDo != nil {
            selectToDo = SelectItem.selectToDo
            guard let selectToDo = selectToDo else { return }
            selectedDate = selectToDo.startDate
        } else {
            if !todoDBList.isEmpty {
                selectedDate = todoDBList[todoDBList.endIndex - 1].startDate
            }
        }
    }
    
    func getToDo() -> [ToDoDB] {
        todoDBList = []
        return localRealm.objects(ToDoDB.self).map { $0 }.sorted(by: { $0.startDate < $1.startDate })
    }
    
    func deleteToDoDB(todo: ToDoDB) {
        try! localRealm.write {
            localRealm.delete(todo)
        }
    }
    
    func getTodayList(today: Date = Date()) {
        todayToDoList = []
        checkedList = []
        notCheckedList = []
        
        let todayToDate = DateFormatter.customDateFormatter.strToDate(str: DateFormatter.customDateFormatter.dateToString(date: today))
        
        for todo in todoDBList {
            if todo.startDate == todayToDate {
                todayToDoList.append(todo)
            } else {
                if todo.startDate != todo.endDate {
                    if todo.isChecked == false {
                        if todo.startDate <= todayToDate && todayToDate <= todo.endDate {
                            todayToDoList.append(todo)
                        }
                    }
                }
            }
        }
        
        distributeToDo()
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: todayToDate, type: dateFormatType)
        toDoTableView.reloadData()
    }
    
    func distributeToDo() {
        for data in todayToDoList {
            if data.isChecked {
                checkedList.append(data)
            } else {
                notCheckedList.append(data)
            }
        }
        
        checkedList = checkedList.sorted(by: { $0.startDate < $1.startDate })
        notCheckedList = notCheckedList.sorted(by: { $0.startDate < $1.startDate })
    }
    
    func editToDoChecking(todo: ToDoDB) {
        if todo.isChecked {
            try! localRealm.write {
                localRealm.create(
                    ToDoDB.self,
                    value: [
                        "_id": todo._id,
                        "title": todo.title,
                        "memo": todo.memo,
                        "startDate": todo.startDate,
                        "endDate": todo.endDate,
                        "isChecked": 0
                    ],
                    update: .modified
                )
            }
        } else {
            try! localRealm.write {
                localRealm.create(
                    ToDoDB.self,
                    value: [
                        "_id": todo._id,
                        "title": todo.title,
                        "memo": todo.memo,
                        "startDate": todo.startDate,
                        "endDate": todo.endDate,
                        "isChecked": 1
                    ],
                    update: .modified
                )
            }
        }
    }
    
    @objc func notcheckedButton(_ sender: UIButton) {
        if !notCheckedList.isEmpty {
            guard let cell = tableView(toDoTableView, cellForRowAt: IndexPath(row: sender.tag, section: 0)) as? ToDoTableViewCell else { return }
            cell.toDoCheckButton.isHidden = false
            
            let todo = notCheckedList[sender.tag]
            editToDoChecking(todo: todo)
            getTodayList(today: todo.startDate)
        }
    }
    
    @objc func checkedButton(_ sender: UIButton) {
        if !checkedList.isEmpty {
            guard let cell = tableView(toDoTableView, cellForRowAt: IndexPath(row: sender.tag, section: 1)) as? ToDoTableViewCell else { return }
            cell.toDoCheckButton.isHidden = true
            
            let todo = checkedList[sender.tag]
            editToDoChecking(todo: todo)
            getTodayList(today: todo.startDate)
        }
    }
    
    @IBAction func previousToDoButton(_ sender: UIButton) {
        if !todoDBList.isEmpty {
            let sortedList = todoDBList.sorted(by: { $0.startDate > $1.startDate })
            
            if todoDBList[0].startDate == selectedDate {
                UIAlertController.warningAlert(title: "🚫", message: "이전 투두가 없습니다.", viewController: self)
            } else {
    
                for data in sortedList {
                    if selectedDate > data.startDate {
                        selectedDate = data.startDate
                        SelectItem.selectToDo = data
                        break
                    }
                }
                
                getTodayList(today: selectedDate)
            }
        } else {
            UIAlertController.warningAlert(title: "🚫", message: "이전 투두가 없습니다.", viewController: self)
        }
    }
    
    @IBAction func nextToDoButton(_ sender: UIButton) {
        if !todoDBList.isEmpty {
            if todoDBList[todoDBList.endIndex - 1].startDate == selectedDate {
                UIAlertController.warningAlert(title: "🚫", message: "다음 투두가 없습니다.", viewController: self)
            } else {
                for data in todoDBList {
                    if selectedDate < data.startDate {
                        selectedDate = data.startDate
                        SelectItem.selectToDo = data
                        break
                    }
                }
                
                getTodayList(today: selectedDate)
            }
        } else {
            UIAlertController.warningAlert(title: "🚫", message: "다음 투두가 없습니다.", viewController: self)
        }
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
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        toDoCalendarView.isHidden.toggle()
    }
}

// MARK: UITableViewDataSource
extension ToDoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkedList.count + notCheckedList.count <= 0 {
            toDoEmptyView.isHidden = false
        } else {
            toDoEmptyView.isHidden = true
        }
        
        if section == 0 {
            return notCheckedList.count
        }
        return checkedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        var todo: ToDoDB
        
        if indexPath.section == 0 { // 미완료 항목
            todo = notCheckedList[indexPath.row]
            cell.toDoCheckButton.isHidden = true
            cell.toDoTitleLabel.textColor = .label
            cell.toDoExpireDateLabel.textColor = .label
            cell.toDoMemoLabel.textColor = .label
            
            cell.toDoNotCheckButton.tag = indexPath.row
            cell.toDoNotCheckButton.addTarget(self, action: #selector(notcheckedButton), for: .touchUpInside)
        } else { // 완료 항목
            todo = checkedList[indexPath.row]
            cell.toDoCheckButton.isHidden = false
            cell.toDoTitleLabel.textColor = .lightGray
            cell.toDoExpireDateLabel.textColor = .lightGray
            cell.toDoMemoLabel.textColor = .lightGray
            
            cell.toDoCheckButton.tag = indexPath.row
            cell.toDoCheckButton.addTarget(self, action: #selector(checkedButton), for: .touchUpInside)
        }
        
        cell.toDoTitleLabel.text = todo.title
        cell.toDoTitleLabel.font = UIFont(name: font, size: fontSize)
        cell.toDoMemoLabel.text = todo.memo
        cell.toDoMemoLabel.font = UIFont(name: font, size: fontSize - 8)
        
        if todo.startDate == todo.endDate {
            cell.toDoExpireDateLabel.text = "오늘"
        } else {
            cell.toDoExpireDateLabel.text = "마감일 : \(DateFormatter.customDateFormatter.dateToStr(date: todo.endDate, type: dateFormatType))"
        }
        cell.toDoExpireDateLabel.font = UIFont(name: font, size: fontSize - 8)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var todo: ToDoDB
        
        if indexPath.section == 0 {
            todo = notCheckedList[indexPath.row]
        } else {
            todo = checkedList[indexPath.row]
        }
    
        if editingStyle == .delete {
            selectedDate = todo.startDate
            deleteToDoDB(todo: todo)
            todoDBList = getToDo()
            SelectItem.selectToDo = nil
            if !todoDBList.isEmpty {
                getTodayList(today: selectedDate)
            } else {
                getTodayList()
            }
        }
    }
}

// MARK: UITableViewDelegate
extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editToDoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as? AddToDoViewController else { return }
        
        var todo: ToDoDB
        
        if indexPath.section == 0 {
            todo = notCheckedList[indexPath.row]
        } else {
            todo = checkedList[indexPath.row]
        }
        
        editToDoVC.viewType = .edit
        editToDoVC.editToDo = todo
        
        if todo.startDate == todo.endDate {
            editToDoVC.allDayType = .yes
        } else {
            editToDoVC.allDayType = .no
        }
        
        self.navigationController?.pushViewController(editToDoVC, animated: true)
    }
}

extension ToDoViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for todo in todoDBList {
            let toDoEvent = todo.startDate
            
            if toDoEvent == date {
                let count = todoDBList.filter { todo in
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
        
        todayToDoList = todoDBList.filter { toDo in
            toDo.startDate == date
        }
        
        if todayToDoList.count == 0 {
            UIAlertController.warningAlert(title: "🚫", message: "등록된 투두가 없습니다.", viewController: self)
        } else {
            selectedDate = date
            getTodayList(today: selectedDate)
        }
    }
}
