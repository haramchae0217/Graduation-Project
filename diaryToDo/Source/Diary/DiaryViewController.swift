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
    @IBOutlet weak var diaryFilmImage: UIImageView!
    @IBOutlet weak var editDiaryButton: UIButton!
    @IBOutlet weak var deleteDiaryButton: UIButton!
    
    //MARK: Property
    var filterHashTag: [Diary] = []
    var editDiary: Diary?
    var selectDiary: Diary?
    var deleteDiary: Diary?
    var diaryType: DiaryType = .basic
    var diaryList = MyDB.diaryItem
    var hashTagList: String = ""
    var selectedDate: Date = Date()
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    var dateFormatType: DateFormatType = .type1
    
    //MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "다이어리"
        
        configureUILabel()
        configureTapGesture()
        configureCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MyDB.selectDiary != nil {
            diaryType = .search
        }
        diaryList = MyDB.diaryItem
        configureDateFormat()
        configureFilmImage()
        configureFontAndFontSize()
        diaryViewType()
        diaryCalendarView.reloadData()
    }
    
    //MARK: Configure
    
    func configureUILabel() {
        diaryContentLabel.layer.cornerRadius = 10
        diaryContentLabel.layer.borderWidth = 1
        diaryContentLabel.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configureDateFormat() {
        for data in MyDB.dateFormatList {
            if data.isSelected {
                dateFormatType = data.dateformatType
                break
            }
        }
    }
    
    func configureFilmImage() {
        for data in MyDB.filmList {
            if data.isSelected {
                let filmName = data.filmName.rawValue
                diaryFilmImage.image = UIImage(named: filmName)
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
                diaryDateLabel.font = UIFont(name: font, size: fontSize)
                diaryContentLabel.font = UIFont(name: font, size: fontSize)
                diaryHashTagLabel.font = UIFont(name: font, size: fontSize)
                break
            }
        }
    }
    
    func configureCalendarView() {
        diaryCalendarView.delegate = self
        diaryCalendarView.dataSource = self
        
        diaryCalendarView.isHidden = true
        diaryCalendarView.locale = Locale(identifier: "ko-KR")
        
        diaryCalendarView.appearance.headerTitleFont = UIFont(name: font, size: fontSize)
        diaryCalendarView.appearance.weekdayFont = UIFont(name: font, size: fontSize)
        diaryCalendarView.appearance.titleFont = UIFont(name: font, size: fontSize)
        diaryCalendarView.appearance.headerTitleColor = UIColor(named: "diaryColor")
        diaryCalendarView.appearance.weekdayTextColor = UIColor(named: "diaryColor")
        diaryCalendarView.appearance.titlePlaceholderColor = UIColor(named: "diaryColor2")
        diaryCalendarView.appearance.titleDefaultColor = UIColor(named: "diaryColor3")
        diaryCalendarView.appearance.selectionColor = .systemBlue
        diaryCalendarView.layer.cornerRadius = 16
    }
    
    func configureTapGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageTapGesture.delegate = self
        diaryPictureUIImage.addGestureRecognizer(imageTapGesture)
        diaryPictureUIImage.isUserInteractionEnabled = true
        
        let contentTapGesture = UITapGestureRecognizer(target: self, action: #selector(contentTapped))
        diaryContentLabel.addGestureRecognizer(contentTapGesture)
        diaryContentLabel.isUserInteractionEnabled = true
    }
    
    func showDiary(diary: Diary) {
        hashTagList = ""
        
        for i in 0..<diary.hashTag.count {
            if i == diary.hashTag.count - 1 {
                hashTagList.append("#\(diary.hashTag[i])")
                break
            }
            hashTagList.append("#\(diary.hashTag[i]), ")
        }
        
        diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: diary.date, type: dateFormatType)
        diaryHashTagLabel.text = hashTagList
        diaryPictureUIImage.image = diary.picture
        diaryContentLabel.text = diary.content
        
    }
    
    //MARK: ETC
    func diaryViewType() {
        diaryList = MyDB.diaryItem
        if diaryType == .search {
            selectDiary = MyDB.selectDiary
            guard let selectDiary = selectDiary else { return }
            showDiary(diary: selectDiary)
            selectedDate = selectDiary.date
            editDiary = selectDiary
            deleteDiary = selectDiary
        } else {
            if !MyDB.diaryItem.isEmpty {
                let recentDiary = diaryList[diaryList.endIndex - 1]
                showDiary(diary: recentDiary)
                selectedDate = recentDiary.date
                editDiary = recentDiary
                deleteDiary = recentDiary
            } else {
                diaryPictureUIImage.isHidden = false
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: Date(), type: dateFormatType)
                diaryPictureUIImage.image = UIImage(named: "noImage")
                diaryHashTagLabel.text = "작성된 다이어리가 없습니다. 다이어리를 작성해주세요."
                diaryContentLabel.isHidden = true
                editDiaryButton.isHidden = true
                deleteDiaryButton.isHidden = true
            }
        }
    }
    
    //MARK: Actions
    @objc func imageViewTapped(_ sender: UIImageView) {
        diaryPictureUIImage.isHidden = true
        editDiaryButton.isHidden = false
        deleteDiaryButton.isHidden = false
        diaryContentLabel.isHidden = false
    }
    
    @objc func contentTapped(_ sender: UILabel) {
        diaryPictureUIImage.isHidden = false
        editDiaryButton.isHidden = true
        deleteDiaryButton.isHidden = true
        diaryContentLabel.isHidden = true
    }
        
    @IBAction func previousDiaryButton(_ sender: UIButton) {
        let sortedList = diaryList.sorted(by: { $0.date > $1.date })
        var previousDate: Date = selectedDate
        
        for data in sortedList {
            if selectedDate > data.date {
                previousDate = data.date
                break
            }
        }
        
        for data in sortedList {
            if previousDate == data.date {
                showDiary(diary: data)
                editDiary = data
                deleteDiary = data
                break
            }
        }
        
        selectedDate = previousDate
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        var nextDate: Date = selectedDate
        
        for data in diaryList {
            if selectedDate < data.date {
                nextDate = data.date
                break
            }
        }
        
        for data in diaryList {
            if nextDate == data.date {
                showDiary(diary: data)
                editDiary = data
                deleteDiary = data
                break
            }
        }
        
        selectedDate = nextDate
    }
    
    @IBAction func calendarButton(_ sender: UIBarButtonItem) {
        diaryCalendarView.isHidden.toggle()
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
    
    @IBAction func editDiaryButton(_ sender: UIButton) {
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDiaryVC") as? AddDiaryViewController else { return }
        editVC.viewType = .edit
        editVC.editDiary = editDiary
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func deleteDiaryButton(_ sender: UIButton) {
        let diaryDelete = UIAlertController(title: "⚠️", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
            MyDB.diaryItem.removeAll { data in
                data.content == self.deleteDiary?.content && data.picture == self.deleteDiary?.picture && data.hashTag == self.deleteDiary?.hashTag && data.date == self.deleteDiary?.date
            }
            self.diaryViewType()
        }
        diaryDelete.addAction(cancelButton)
        diaryDelete.addAction(deleteButton)
        present(diaryDelete, animated: true, completion: nil)
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
        diaryCalendarView.isHidden.toggle()
        
        let diaryList = MyDB.diaryItem.filter { diary in
            diary.date == date
        }
        
        if diaryList.count > 0 {
            for data in diaryList {
                if data.date == date {
                    showDiary(diary: data)
                }
            }
            selectedDate = date
            
        } else {
            UIAlertController.warningAlert(message: "등록된 다이어리가 없습니다.", viewController: self)
        }
    }
}

extension DiaryViewController: UIGestureRecognizerDelegate {
    
}
