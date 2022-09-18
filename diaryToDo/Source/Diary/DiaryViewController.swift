//
//  ViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/11.
//

import UIKit
import FSCalendar
import RealmSwift

class DiaryViewController: UIViewController {
    
    //MARK: Enum
    enum DiaryType {
        case basic
        case select
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
    let localRealm = try! Realm()
    
    var diaryDBList: [DiaryDB] = []
    var filterHashTag: [DiaryDB] = []
    var imageList: [(UIImage, ObjectId)] = []
    var imageCount: Int = 0
    var editOrDeleteDiary: DiaryDB?
    var selectDiary: DiaryDB?
    var diaryType: DiaryType = .basic
    var hashTagList: String = ""
    var selectedDate: Date = Date()
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    var dateFormatType: String = ""
    
    //MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureUILabel()
        configureTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MyDB.selectDiary != nil {
            diaryType = .select
        }
        configureDateFormat()
        configureFilmImage()
        configureFontAndFontSize()
        
        configureUD()
        
        configureCalendarView()
        
        diaryViewType()
        
        diaryCalendarView.reloadData()
    }
    
    //MARK: Configure
    
    func configureNavigationController() {
        title = "다이어리"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureUILabel() {
        diaryContentLabel.layer.cornerRadius = 10
        diaryContentLabel.layer.borderWidth = 1
        diaryContentLabel.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configureDateFormat() {
        let dateType = UserDefaults.standard.string(forKey: SettingType.dateFormat.rawValue) ?? "type3"
        dateFormatType = dateType
    }
    
    func configureFilmImage() {
        let filmName = UserDefaults.standard.string(forKey: SettingType.film.rawValue) ?? "film1"
        diaryFilmImage.image = UIImage(named: filmName)
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        diaryDateLabel.font = UIFont(name: font, size: fontSize)
        diaryContentLabel.font = UIFont(name: font, size: fontSize)
        diaryHashTagLabel.font = UIFont(name: font, size: fontSize)
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
    
    func configureUD() {
        if let imageNumber = UserDefaults.standard.string(forKey: "imageNumber"), let count = Int(imageNumber) {
            imageCount = count
        } else {
            UserDefaults.standard.set("0", forKey: "")
        }
    }
    
    func getDiary() -> [DiaryDB] {
        print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find location")
        return localRealm.objects(DiaryDB.self).map { $0 }
    }
    
    func deleteDiaryDB(diary: DiaryDB) {
        try! localRealm.write {
            localRealm.delete(diary)
        }
    }
    
    func getDiaryImage() {
        for data in diaryDBList {
            if let image = ImageManager.shared.getImage(name: "\(data._id).jpg") {
                imageList.append((image, data._id))
            } else {
                UserDefaults.standard.set("0", forKey: "imageNumber")
            }
        }
    }
    
    func showDiary(diary: DiaryDB) {
        hashTagList = ""
        let id = diary._id
        for i in 0..<diary.hashTag.count {
            if i == diary.hashTag.count - 1 {
                hashTagList.append("#\(diary.hashTag[i])")
                break
            }
            hashTagList.append("#\(diary.hashTag[i]), ")
        }
        showImage(id: id)
        editOrDeleteDiary = diary
        selectedDate = diary.date
        diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: diary.date, type: dateFormatType)
        diaryHashTagLabel.text = hashTagList
        diaryContentLabel.text = diary.content
    }
    
    func showImage(id: ObjectId) {
        for data in imageList {
            if data.1 == id {
                diaryPictureUIImage.image = data.0
            }
        }
    }
    
    func deleteImage(id: ObjectId) {
        ImageManager.shared.deleteImage(name: "\(id).jpg") { onSuccess in
            if onSuccess {
                UIAlertController.warningAlert(title: "☑️", message: "삭제가 완료되었습니다.", viewController: self)
            }
        }
    }
    
    //MARK: ETC
    func diaryViewType() {
        diaryDBList = getDiary()
        diaryDBList = diaryDBList.sorted(by: { $0.date < $1.date })
        getDiaryImage()
        if diaryType == .select {
            selectDiary = MyDB.selectDiary
            guard let selectDiary = selectDiary else { return }
            showDiary(diary: selectDiary)
        } else {
            if !diaryDBList.isEmpty {
                let lastDiary = diaryDBList[diaryDBList.endIndex - 1]
                showDiary(diary: lastDiary)
            } else {
                diaryPictureUIImage.isHidden = false
                diaryDateLabel.text = DateFormatter.customDateFormatter.dateToStr(date: Date(), type: dateFormatType)
                diaryPictureUIImage.image = UIImage(named: "noImage")
                diaryHashTagLabel.text = "작성된 다이어리가 없습니다."
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
        let sortedList = diaryDBList.sorted(by: { $0.date > $1.date })
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
                break
            }
        }
        
        selectedDate = previousDate
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        var nextDate: Date = selectedDate
        
        for data in diaryDBList {
            if selectedDate < data.date {
                nextDate = data.date
                break
            }
        }
        
        for data in diaryDBList {
            if nextDate == data.date {
                showDiary(diary: data)
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
        editVC.editDiary = editOrDeleteDiary
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func deleteDiaryButton(_ sender: UIButton) {
        let diaryDelete = UIAlertController(title: "⚠️", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if let editOrDeleteDiary = self.editOrDeleteDiary {
                let diary = editOrDeleteDiary
                self.deleteImage(id: diary._id)
                self.deleteDiaryDB(diary: diary)
                self.diaryViewType()
            }
        }
        diaryDelete.addAction(cancelButton)
        diaryDelete.addAction(deleteButton)
        present(diaryDelete, animated: true, completion: nil)
    }
}

extension DiaryViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for diary in diaryDBList {
            let diaryEvent = DateFormatter.customDateFormatter.strToDate(str: DateFormatter.customDateFormatter.dateToString(date: diary.date))
            
            if diaryEvent == date {
                let count = diaryDBList.filter { diary in
                    DateFormatter.customDateFormatter.strToDate(str: DateFormatter.customDateFormatter.dateToString(date: diary.date)) == date
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
        
        let diaryList = diaryDBList.filter { diary in
            DateFormatter.customDateFormatter.strToDate(str: DateFormatter.customDateFormatter.dateToString(date: diary.date)) == date
        }
        
        if diaryList.count > 0 {
            for data in diaryList {
                if DateFormatter.customDateFormatter.strToDate(str: DateFormatter.customDateFormatter.dateToString(date: data.date)) == date {
                    showDiary(diary: data)
                    selectedDate = data.date
                    break
                }
            }
        } else {
            UIAlertController.warningAlert(title: "🚫", message: "등록된 다이어리가 없습니다.", viewController: self)
        }
    }
}

extension DiaryViewController: UIGestureRecognizerDelegate {
    
}
