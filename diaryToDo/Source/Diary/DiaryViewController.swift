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
    var imageList: [(UIImage, Int)] = []
    var moveImage: Int = 0
    var editOrDeleteDiary: DiaryDB?
    var editOrDeleteImage: UIImage?
    var selectDiary: DiaryDB?
    var selectImage: UIImage?
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
        
        if selectDiary != nil {
            diaryType = .select
        }
        configureDateFormat()
        configureFilmImage()
        configureFontAndFontSize()
        
        getDiaryImage()
        
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
        if let imageNumber = UserDefaults.standard.string(forKey: "imageNumber"), let count = Int(imageNumber) {
            for i in 0..<count {
                if let image = ImageManager.shared.getImage(name: "\(i).jpg") {
                    imageList.append((image, i))
                }
            }
        } else {
            UserDefaults.standard.set("0", forKey: "imageNumber")
        }
    }
    
    func showDiary(diary: DiaryDB) {
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
        diaryContentLabel.text = diary.content
    }
    
    func showImage(image: UIImage) {
        diaryPictureUIImage.image = image
    }
    
    func editOrDeleteDiary(diary: DiaryDB, image: UIImage) {
        editOrDeleteDiary = diary
        editOrDeleteImage = image
    }
    
    //MARK: ETC
    func diaryViewType() {
        diaryDBList = getDiary()
        if diaryType == .select {
            selectDiary = MyDB.selectDiary
            selectImage = MyDB.selectImage?.0
            moveImage = MyDB.selectImage?.1 ?? 0
            guard let selectDiary = selectDiary else { return }
            guard let selectImage = selectImage else { return }
            showDiary(diary: selectDiary)
            showImage(image: selectImage)
            editOrDeleteDiary(diary: selectDiary, image: selectImage)
            selectedDate = selectDiary.date
        } else {
            if !diaryDBList.isEmpty {
                let lastDiary = diaryDBList[diaryDBList.endIndex - 1]
                let lastImage = imageList[imageList.endIndex - 1]
                showDiary(diary: lastDiary)
                showImage(image: lastImage.0)
                editOrDeleteDiary(diary: lastDiary, image: lastImage.0)
                moveImage = lastImage.1
                selectedDate = lastDiary.date
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
        let sortedImageList = imageList.sorted(by: { $0.1 > $1.1 })
        var previousDate: Date = selectedDate
        var previousImage: Int = moveImage
        
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
        
        for data in sortedImageList {
            if moveImage > data.1 {
                previousImage = data.1
                break
            }
        }
        
        for data in sortedImageList {
            if previousImage == data.1 {
                showImage(image: data.0)
                break
            }
        }
        
        moveImage = previousImage
        selectedDate = previousDate
    }
    
    @IBAction func nextDiaryButton(_ sender: UIButton) {
        var nextDate: Date = selectedDate
        var nextImage: Int = moveImage
        
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
        
        for data in imageList {
            if moveImage < data.1 {
                nextImage = data.1
                break
            }
        }
        
        for data in imageList {
            if nextImage == data.1 {
                showImage(image: data.0)
            }
        }
        
        moveImage = nextImage
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
        editVC.editImage = editOrDeleteImage
        editVC.editImageIndex = moveImage
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func deleteDiaryButton(_ sender: UIButton) {
        let diaryDelete = UIAlertController(title: "⚠️", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if let editOrDeleteDiary = self.editOrDeleteDiary {
                let diary = editOrDeleteDiary
                self.deleteDiaryDB(diary: diary)
            }
            ImageManager.shared.deleteImage(name: "\(self.moveImage).jpg") { onSuccess in
                if onSuccess {
                    self.imageList.remove(at: self.moveImage)
                }
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
        for diary in diaryDBList {
            let diaryEvent = diary.date
            
            if diaryEvent == date {
                let count = diaryDBList.filter { diary in
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
        
        var index: Int = 0
        let diaryList = diaryDBList.filter { diary in
            diary.date == date
        }
        
        if diaryList.count > 0 {
            for data in diaryList {
                index += 1
                if data.date == date {
                    showDiary(diary: data)
                    break
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
