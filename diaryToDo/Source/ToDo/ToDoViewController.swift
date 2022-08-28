//
//  ToDoViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/12.
//

import UIKit
import FSCalendar

class ToDoViewController: UIViewController {

    //MARK: UI
    @IBOutlet weak var toDoCalendarView: FSCalendar!
    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var todoDateLabel: UILabel!
    
    let containerView = UIView()
    let label = UILabel()
    
    //MARK: Property
    let sectionList: [String] = ["미완료", "완료"]
    var toDoList = MyDB.toDoList
    var todayToDoList: [ToDo] = []
    var selectToDo: ToDo?
    var selectedDate: Date = Date()
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    var dateFormatType: DateFormatType = .type1
    
    var checkedList: [ToDo] = []
    var notCheckedList: [ToDo] = []
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "투두"
        
//        configureEmptyView()
        configureTableView()
        configureCalendar()
        
        if !MyDB.toDoList.isEmpty {
            selectedDate = toDoList[toDoList.endIndex - 1].startDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toDoList = MyDB.toDoList
        configureDateFormat()
        configureFontAndFontSize()
        getTodayList(today: selectedDate)
        toDoTableView.reloadData()
        
        print("todoList count : \(MyDB.toDoList.count)")
        print("checkedList count: \(checkedList.count)")
        print("notCheckedList count : \(notCheckedList.count)")
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
    
    func getTodayList(today: Date = Date()) {
        todayToDoList = []
        checkedList = []
        notCheckedList = []
        
        for todo in toDoList {
            if todo.startDate <= today && today <= todo.endDate {
                todayToDoList.append(todo)
            }
        }
        distributeToDo()
        todoDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: today, type: dateFormatType)
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
        var toDoListIndex = 0
        todayToDoList[index].isChecked.toggle()
        
        for data in MyDB.toDoList {
            toDoListIndex += 1
            if (data.title == todo.title && data.memo == todo.memo && data.startDate == todo.startDate && data.endDate == todo.endDate ) {
                MyDB.toDoList[toDoListIndex - 1].isChecked.toggle()
                break
            }
        }
        
        todayToDoList = todayToDoList.sorted(by: { $0.startDate < $1.startDate })
        toDoTableView.reloadData()
    }
    
    @IBAction func previousToDoButton(_ sender: UIButton) {
        let sortedList = MyDB.toDoList.sorted(by: { $0.startDate > $1.startDate })
        
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
        for data in toDoList {
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
        
        if toDoList.isEmpty {
            containerView.isHidden = false
        } else {
            containerView.isHidden = true
        }
        
        var todo: ToDo
        
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
        if editingStyle == .delete {
            MyDB.toDoList.removeAll { data in
                data.title == todayToDoList[indexPath.row].title && data.memo == todayToDoList[indexPath.row].memo && data.startDate == todayToDoList[indexPath.row].startDate && data.endDate == todayToDoList[indexPath.row].endDate
            }
            todayToDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
