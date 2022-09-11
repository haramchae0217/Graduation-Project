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
    
    let containerView = UIView()
    let label = UILabel()
    
    //MARK: Property
    let localRealm = try! Realm()
    var todoDBList: [ToDoDB] = []
    var todayToDoList: [ToDoDB] = []
    var selectToDo: ToDoDB?
    let sectionList: [String] = ["미완료", "완료"]
    var selectedDate: Date = Date()
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    var dateFormatType: String = ""
    
    var checkedList: [ToDoDB] = []
    var notCheckedList: [ToDoDB] = []
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureEmptyView()
        configureNavigationController()
        configureTableView()
        
        selectedDate = todoDBList[todoDBList.endIndex - 1].startDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureDateFormat()
        configureFontAndFontSize()
        configureCalendar()
        
        todoDBList = getToDo()
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
        
        todoDateLabel.font = UIFont(name: font, size: fontSize)
    }
    
    func configureEmptyView() {
        view.addSubview(containerView)
        containerView.addSubview(label)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    
        containerView.leadingAnchor.constraint(equalTo: toDoTableView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: toDoTableView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: toDoTableView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: toDoTableView.bottomAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "등록된 투두가 없습니다. \n투두를 추가해주세요."
        
        containerView.isHidden = true
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
    
    func getToDo() -> [ToDoDB] {
        print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find location")
        return localRealm.objects(ToDoDB.self).map { $0 }
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
        
        let todayToString = DateFormatter.customDateFormatter.dateToString(date: today)
        let todayToDate = DateFormatter.customDateFormatter.strToDate(str: todayToString)
        
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
        checkedList = checkedList.sorted(by: { $0.startDate > $1.startDate })
        notCheckedList = notCheckedList.sorted(by: { $0.startDate > $1.startDate })
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
        
        for data in todoDBList {
            // isChecked bool값 변경
        }
        
        toDoTableView.reloadData()
    }
    
    @IBAction func previousToDoButton(_ sender: UIButton) {
        let sortedList = todoDBList.sorted(by: { $0.startDate > $1.startDate })
        
        // 현재 selectedDate를 기준으로 가장 가까운 이전 날짜 가져오기
        for data in sortedList {
            if selectedDate > data.startDate {
                selectedDate = data.startDate
                break
            }
        }
        
        getTodayList(today: selectedDate)
    }
    
    @IBAction func nextToDoButton(_ sender: UIButton) {
        // 현재 selectedDate를 기준으로 가장 가까운 다음 날짜 가져오기
        for data in todoDBList {
            if selectedDate < data.startDate {
                selectedDate = data.startDate
                break
            }
        }
        
        getTodayList(today: selectedDate)
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

// MARK: UITableViewDataSource
extension ToDoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return notCheckedList.count
        }
        return checkedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        
        if todoDBList.isEmpty {
            containerView.isHidden = false
        } else {
            containerView.isHidden = true
        }
        
        var todo: ToDoDB
        
        if indexPath.section == 0 { // 미완료 항목
            todo = notCheckedList[indexPath.row]
            setToDoNotComplete(cell.toDoCheckButton)
            cell.toDoTitleLabel.textColor = .label
            cell.toDoExpireDateLabel.textColor = .label
        } else { // 완료 항목
            todo = checkedList[indexPath.row]
            setToDoComplete(cell.toDoCheckButton)
            cell.toDoTitleLabel.textColor = .lightGray
            cell.toDoExpireDateLabel.textColor = .lightGray
        }
        
        cell.toDoTitleLabel.text = todo.title
        cell.toDoTitleLabel.font = UIFont(name: font, size: fontSize)
    
        cell.toDoCheckButton.tag = indexPath.row
        cell.toDoCheckButton.addTarget(self, action: #selector(checkToDoButton), for: .touchUpInside)
        
        if todo.startDate == todo.endDate {
            cell.toDoExpireDateLabel.text = "오늘"
        } else {
            cell.toDoExpireDateLabel.text = "마감일 : \(DateFormatter.customDateFormatter.dateToStr(date: todo.endDate, type: dateFormatType))"
        }
        cell.toDoExpireDateLabel.font = UIFont(name: font, size: fontSize - 6)
        
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
            deleteToDoDB(todo: todo)
        }
        todoDBList = getToDo()
        getTodayList(today: selectedDate)
        tableView.reloadData()
//        tableView.deleteRows(at: [indexPath], with: .fade)
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
        var row: Int
        
        if indexPath.section == 0 {
            todo = notCheckedList[indexPath.row]
            row = indexPath.row
        } else {
            todo = checkedList[indexPath.row]
            row = indexPath.row
        }
        
        editToDoVC.viewType = .edit
        editToDoVC.editToDo = todo
        editToDoVC.editRow = row
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
        selectedDate = date
        getTodayList(today: selectedDate)
        
        if todayToDoList.count == 0 {
            UIAlertController.warningAlert(message: "등록된 투두가 없습니다.", viewController: self)
        }
    }
}
