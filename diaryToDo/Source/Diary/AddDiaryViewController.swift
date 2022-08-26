//
//  AddDiaryViewController.swift
//  diaryToDo
//
//  Created by Chae_Haram on 2022/03/29.
//

import UIKit

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

    var diaryList = MyDB.diaryItem
    let imagePicker = UIImagePickerController()
    var editDiary: Diary?
    var viewType: DiaryViewType = .add
    var font: String = "Ownglyph ssojji"
    var fontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDiaryContentTextView.delegate = self
        imagePicker.delegate = self
        configureRightBarButton()
        
        if viewType == .edit {
            title = "edit Diary"
            if let editDiary = editDiary {
                var hashtag: String = ""
                addDiaryImageView.image = editDiary.picture
                addDiaryDatePicker.date = editDiary.date
                addDiaryContentTextView.text = editDiary.content
                addDiaryContentTextView.textColor = .label
                for data in editDiary.hashTag {
                    hashtag += "\(data) "
                }
                addDiaryHashTagTextField.text = hashtag
            }
        } else {
            title = "add Diary"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFontAndFontSize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                insertContentLabel.font = UIFont(name: font, size: fontSize)
                insertHashTagLabel.font = UIFont(name: font, size: fontSize)
                break
            }
        }
    }
    
    func configureRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addDiaryButton))
        self.navigationController?.navigationBar.tintColor = UIColor(named: "diaryColor")
        self.navigationItem.rightBarButtonItem = rightBarButton
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
    
    @objc func addDiaryButton() {
        let date = addDiaryDatePicker.date
        let content = addDiaryContentTextView.text!
        let hashTag = addDiaryHashTagTextField.text!
        let picture = addDiaryImageView.image!
        
        let filterHashTag = hashTag.components(separatedBy: " ")
        
        let diary = Diary(content: content, hashTag: filterHashTag, date: date, picture: picture)
        
        if content.isEmpty, hashTag.isEmpty {
            UIAlertController.warningAlert(message: "내용을 입력해주세요.", viewController: self)
            return
        }
        
        if filterHashTag.count > 3 {
            UIAlertController.warningAlert(message: "해시태그는 세개까지 설정 가능합니다.", viewController: self)
        }
        
        if editDiary?.content == content && editDiary?.hashTag == filterHashTag {
            UIAlertController.warningAlert(message: "변경 후 다시 시도해주세요.", viewController: self)
            return
        }
        
        if viewType == .add {
            MyDB.diaryItem.append(diary)
        } else {
            if let editDiary = editDiary {
                var index = 0
                for data in MyDB.diaryItem {
                    index += 1
                    if (data.content == editDiary.content && data.hashTag == editDiary.hashTag && data.date == editDiary.date && data.picture == editDiary.picture) {
                        MyDB.diaryItem[index - 1] = diary
                    }
                }
            }
        }
        MyDB.diaryItem = MyDB.diaryItem.sorted(by: { $0.date < $1.date })
        MyDB.selectDiary = diary
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addDiaryPictureButton(_ sender: UIButton) {
        showAlertSheet()
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
            print("이미지 선택 실패")
            // alert
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
