//
//  AddDiaryViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/29.
//

import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController {
    
    enum DiaryViewType {
        case add
        case edit
    }
    
    @IBOutlet weak var insertContentLabel: UILabel!
    @IBOutlet weak var insertHashTagLabel: UILabel!
    @IBOutlet weak var addDiaryImageView: UIImageView!
    @IBOutlet weak var addDiaryDatePicker: UIDatePicker!
    @IBOutlet weak var addDiaryContentTextView: UITextView!
    @IBOutlet weak var addDiaryHashTagTextField: UITextField!
    @IBOutlet weak var plusLabel: UILabel!
    
    let localRealm = try! Realm()
    let imagePicker = UIImagePickerController()
    
    var imageCount: Int = 0
    var editImage: UIImage?
    var editDiary: DiaryDB?
    var viewType: DiaryViewType = .add
    var font: String = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
    var fontSize: CGFloat = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureFontAndFontSize()
        configureTextView()
        configureImagePicker()
        configureRightBarButton()
        configureTapGesture()
        configureUD()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func configureEditTypeView() {
        if let editDiary = editDiary {
            var hashtag: String = ""
            plusLabel.isHidden = true
            addDiaryImageView.image = editImage
            addDiaryDatePicker.date = editDiary.date
            addDiaryContentTextView.text = editDiary.content
            addDiaryContentTextView.textColor = .label
            for data in editDiary.hashTag {
                hashtag += "\(data) "
            }
            hashtag.removeLast()
            addDiaryHashTagTextField.text = hashtag
        }
    }
    
    func configureNavigationController() {
        if viewType == .edit {
            title = "다이어리 수정"
            configureEditTypeView()
        } else {
            title = "다이어리 추가"
        }
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
    }
    
    func configureFontAndFontSize() {
        fontSize = CGFloat(NSString(string: UserDefaults.standard.string(forKey: SettingType.fontSize.rawValue) ?? "20").floatValue)
        font = UserDefaults.standard.string(forKey: SettingType.font.rawValue) ?? "Ownglyph ssojji"
        
        insertContentLabel.font = UIFont(name: font, size: fontSize)
        insertHashTagLabel.font = UIFont(name: font, size: fontSize)
    }
    
    func configureRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addDiaryButton))
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func configureTextView() {
        addDiaryContentTextView.delegate = self
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
    }
    
    func configureTapGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageTapGesture.delegate = self
        addDiaryImageView.addGestureRecognizer(imageTapGesture)
        addDiaryImageView.isUserInteractionEnabled = true
    }
    
    func addDiaryDB(diary: DiaryDB) {
        try! localRealm.write {
            localRealm.add(diary)
        }
    }
    
    func editDiaryDB(oldDiary: DiaryDB, newDiary: DiaryDB) {
        try! localRealm.write {
            localRealm.create(
                DiaryDB.self,
                value: [
                    "_id": oldDiary._id,
                    "content": newDiary.content,
                    "hashTag": newDiary.hashTag,
                    "date": newDiary.date
                ],
                update: .modified)
        }
    }
    
    func configureUD() {
        if let imageNumber = UserDefaults.standard.string(forKey: "imageNumber"), let count = Int(imageNumber) {
            imageCount = count
        } else {
            UserDefaults.standard.set("0", forKey: "")
        }
    }
    
    func addDiaryImage() {
        guard let image = addDiaryImageView.image else { return }
        
        ImageManager.shared.saveImage(image: image, pathName: "\(imageCount).jpg") { onSuccess in
            if onSuccess {
                print("저장완료")
                self.imageCount += 1
                UserDefaults.standard.set("\(self.imageCount)", forKey: "imageNumber")
            } else {
                print("저장실패")
            }
        }
    }
    
    func editDiaryImage() {
        
        
        
    }
    
    func showAlertSheet() {
        let alertAction = UIAlertController(title: "사진 추가하기", message: "어떤방식으로 추가하시겠습니까?", preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "카메라", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoLibraryButton = UIAlertAction(title: "사진첩", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
       
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertAction.addAction(cameraButton)
        alertAction.addAction(photoLibraryButton)
        alertAction.addAction(cancelButton)
        
        self.present(alertAction, animated: true, completion: nil)
    }
    
    @objc func imageViewTapped(_ sender: UIImageView){
        showAlertSheet()
        plusLabel.isHidden = true
    }
    
    @objc func addDiaryButton() {
        let date = addDiaryDatePicker.date
        let content = addDiaryContentTextView.text!
        let hashTag = addDiaryHashTagTextField.text!
        let filterHashTag = List<String>()
        
        if addDiaryImageView.image == nil {
            UIAlertController.warningAlert(message: "사진을 첨부해주세요.", viewController: self)
            return
        }
        
        if content.isEmpty || hashTag.isEmpty {
            UIAlertController.warningAlert(message: "내용을 입력해주세요.", viewController: self)
            return
        } else {
            hashTag.components(separatedBy: " ").forEach { str in
                filterHashTag.append(str)
            }
            
            if filterHashTag.count > 3 {
                UIAlertController.warningAlert(message: "해시태그는 세개까지 설정 가능합니다.", viewController: self)
                return
            }
        }
        
        let newDiary = DiaryDB(content: content, hashTag: filterHashTag, date: date)
        if viewType == .add {
            addDiaryDB(diary: newDiary)
            addDiaryImage()
        } else {
            if let oldDiary = editDiary {
                if oldDiary.content == content && oldDiary.hashTag == filterHashTag && oldDiary.date == date {
                    UIAlertController.warningAlert(message: "변경 후 다시 시도해주세요.", viewController: self)
                    return
                }
                editDiaryDB(oldDiary: oldDiary, newDiary: newDiary)
            }
        }

        MyDB.selectDiary = newDiary
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력해주세요." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요."
            textView.textColor = .lightGray
        }
    }
}

extension AddDiaryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addDiaryImageView.image = image
        } else {
            UIAlertController.warningAlert(message: "이미지 선택 실패", viewController: self)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddDiaryViewController: UIGestureRecognizerDelegate {
    
}
