//
//  ViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/11.
//

import UIKit
import FSCalendar

class DiaryViewController: UIViewController {
    
    //MARK: Enum
    enum DiaryType {
        case basic
        case search
    }
    
    //MARK: UI
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryPictureUIImage: UIImageView!
    @IBOutlet weak var diaryHashTagLabel: UILabel!
    @IBOutlet weak var diaryContentLabel: UILabel!
    @IBOutlet weak var diaryCalendarView: FSCalendar!
    
    //MARK: Property
    var filterHashTag: [Diary] = []
    var selectDiary: Diary?
    var hashTagList: String = ""
    var diaryCount: Int = 0
    var indexNumber: Int = 0
    var selectedDate: Date = Date()
    var diaryType: DiaryType = .basic
    
    //MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture()
        configureCalendarView()
    
        indexNumber = MyDB.diaryItem.endIndex - 1
        selectedDate = MyDB.diaryItem[indexNumber].date
        diaryCount = MyDB.diaryItem.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MyDB.selectDiary != nil {
            diaryType = .search
        }
        diaryCount = MyDB.diaryItem.count
        diaryViewType()
        
    }
    
    //MARK: Configure
    func configureCalendarView() {
        diaryCalendarView.delegate = self
        diaryCalendarView.dataSource = self
        
        diaryCalendarView.locale = Locale(identifier: "ko-KR")
        diaryCalendarView.appearance.selectionColor = .systemBlue
        diaryCalendarView.isHidden = true
    }
    
    func configureTapGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageTapGesture.delegate = self
        diaryPictureUIImage.addGestureRecognizer(imageTapGesture)
        diaryPictureUIImage.isUserInteractionEnabled = true
    }
    
    //MARK: ETC
    func diaryViewType() {
        hashTagList = ""
        if diaryType == .search {
            selectDiary = MyDB.selectDiary
            guard let selectDiary = selectDiary else { return }

            for i in 0..<selectDiary.hashTag.count {
                if i == selectDiary.hashTag.count - 1 {
                    hashTagList.append("#\(selectDiary.hashTag[i])")
                    break
                }
                hashTagList.append("#\(selectDiary.hashTag[i]), ")
            }
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: selectDiary.date)
            diaryHashTagLabel.text = hashTagList
            diaryPictureUIImage.image = selectDiary.picture
            diaryContentLabel.text = selectDiary.content
        } else {
            if !MyDB.diaryItem.isEmpty {
                let recentDiary = MyDB.diaryItem[diaryCount - 1]
                
                for i in 0..<recentDiary.hashTag.count {
                    if i == recentDiary.hashTag.count - 1 {
                        hashTagList.append("#\(recentDiary.hashTag[i])")
                        break
                    }
                    hashTagList.append("#\(recentDiary.hashTag[i]), ")
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: recentDiary.date)
                diaryHashTagLabel.text = hashTagList
                diaryPictureUIImage.image = recentDiary.picture
                diaryContentLabel.text = recentDiary.content
            }
        }
    }
    
    //MARK: Actions
    @objc func imageViewTapped(_ sender: UIImageView){
        print("imageView Tapped")
        diaryPictureUIImage.isHidden = true
    }
        
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        let sortedList = MyDB.diaryItem.sorted(by: { $0.date > $1.date })
        hashTagList = ""
        
        var previousDate: Date = selectedDate
        
        for data in sortedList { // 바로 이전 날짜 추출
            if selectedDate > data.date {
                previousDate = data.date
                break
            }
        }
        
        for data in sortedList { // 위에서 추출한 날짜와 db에 날짜가 같다면 데이터를 뽑아와서 저장
            if previousDate == data.date {
                for i in 0..<data.hashTag.count {
                    if i == data.hashTag.count - 1 {
                        hashTagList.append("#\(data.hashTag[i])")
                        break
                    }
                    hashTagList.append("#\(data.hashTag[i]), ")
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.date)
                diaryHashTagLabel.text = "\(hashTagList)"
                diaryPictureUIImage.image = data.picture
                diaryContentLabel.text = data.content
                break
            } else {
//                UIAlertController.showAlert(message: "이전 다이어리가 없습니다.", vc: self)
            }
        }
        
        selectedDate = previousDate
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        hashTagList = ""
        
        var nextDate: Date = selectedDate
        
        for data in MyDB.diaryItem { // 바로 이전 날짜 추출
            if selectedDate < data.date {
                nextDate = data.date
                break
            }
        }
        
        for data in MyDB.diaryItem { // 위에서 추출한 날짜와 db에 날짜가 같다면 데이터를 뽑아와서 저장
            if nextDate == data.date {
                for i in 0..<data.hashTag.count {
                    if i == data.hashTag.count - 1 {
                        hashTagList.append("#\(data.hashTag[i])")
                        break
                    }
                    hashTagList.append("#\(data.hashTag[i]), ")
                }
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: data.date)
                diaryHashTagLabel.text = "\(hashTagList)"
                diaryPictureUIImage.image = data.picture
                diaryContentLabel.text = data.content
                break
            } else {
//                UIAlertController.showAlert(message: "다음 다이어리가 없습니다.", vc: self)
            }
        }
        
        selectedDate = nextDate
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        diaryCalendarView.isHidden.toggle()
        configureCalendarView()
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchDiaryViewController else { return }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func addDiaryButton(_ sender: UIBarButtonItem) {
        guard let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDiaryVC") as? AddDiaryViewController else { return }
        addVC.viewType = .add
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    @IBAction func showPictureButton(_ sender: UIButton) {
        diaryPictureUIImage.isHidden = false
    }
    
    @IBAction func editDiaryButton(_ sender: UIButton) {
        print("edit")
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDiaryVC") as? AddDiaryViewController else { return }
        let hashtag = diaryHashTagLabel.text!
        let arrayHashTag = hashtag.components(separatedBy: " ")
        let diary = Diary(content: diaryContentLabel.text!, hashTag: arrayHashTag, date: DateFormatter.customDateFormatter.strToDate(str: diaryDateLabel.text!), picture: diaryPictureUIImage.image!)
        editVC.viewType = .edit
        editVC.editDiary = diary
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func deleteDiaryButton(_ sender: UIButton) {
        print("delete")
    }
    
}

extension DiaryViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for diary in MyDB.diaryItem {
            let diaryEvent = diary.date
            
            if diaryEvent == date {
                let count = MyDB.diaryItem.filter { diary in
                    diary.date == date
                }.count
                
                return count
            }
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let diaryList = MyDB.diaryItem.filter { diary in
            diary.date == date
        }
        
        if diaryList.count > 0 {
            var text = ""
            var image: UIImage = UIImage(named: "cafe1")!
            
            for item in diaryList {
                for i in 0..<item.hashTag.endIndex {
                    text += item.hashTag[i]
                }
                
                image = item.picture
            }
            
            selectedDate = date
            diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: date)
            diaryPictureUIImage.image = image
            diaryHashTagLabel.text = text
        } else {
            UIAlertController.showAlert(message: "등록된 다이어리가 없습니다.", vc: self)
        }
    }
}

extension DiaryViewController: UIGestureRecognizerDelegate {
    
}
